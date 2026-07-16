# frida-pharo bootstrap build/test loop.
#
# Targets:
#   make dylib     - link frida-core (+deps) into a uFFI-loadable shared library
#   make generate  - run the Python generator, emitting Tonel into src/FridaPharo
#   make image     - load the baseline into a fresh Pharo image (build/pharo/FridaBuilt.image)
#   make test      - run the SUnit suite headless against that image
#   make all       - dylib + generate + image + test

# --- Configuration (override on the command line as needed) ---------------
FRIDA_CORE      ?= /Users/oleavr/src/frida-core
FRIDA_MACHINE   ?= macos-arm64
FRIDA_BUILD     := $(FRIDA_CORE)/build/$(FRIDA_MACHINE)
FRIDA_SDK       := $(FRIDA_CORE)/deps/sdk-$(FRIDA_MACHINE)/lib
GIR_DIR         := $(FRIDA_BUILD)/src/api

REPO            := $(abspath .)
PHARO_DIR       := $(REPO)/build/pharo
PHARO           := $(PHARO_DIR)/pharo
BASE_IMAGE      := $(PHARO_DIR)/Pharo.image
BUILT_IMAGE     := $(PHARO_DIR)/FridaBuilt.image

BINDGEN         := $(REPO)/frida-bindgen

# --- Platform-conditional linker vocabulary -------------------------------
# The shared-library suffix and the glue's link flags differ between macOS's
# ld64 and the GNU toolchain: the soname flag, the loader-relative rpath token,
# and how each spells "leave undefined symbols to be resolved at load time".
# tools/build-dylib.sh handles the frida-core link's own OS split; this covers
# the Makefile-driven glue link and the artefact names.
UNAME_S         := $(shell uname -s)
ifeq ($(UNAME_S),Darwin)
LIBEXT          := dylib
GLUE_LDFLAGS    := -Wl,-rpath,@loader_path -install_name @rpath/libfrida-pharo-glue.dylib -undefined dynamic_lookup
else
LIBEXT          := so
GLUE_LDFLAGS    := -Wl,-rpath,'$$ORIGIN' -Wl,-soname,libfrida-pharo-glue.so -Wl,--unresolved-symbols=ignore-all
endif

DYLIB           := $(REPO)/build/dylib/libfrida-core.$(LIBEXT)
GLUE            := $(REPO)/build/dylib/libfrida-pharo-glue.$(LIBEXT)

# Include flags for the glue's GLib/GObject/GIO types. Default to frida-core's
# SDK headers (keeps the macOS dev build byte-identical); override GLUE_CFLAGS on
# the command line to use system headers, e.g. on CI:
#   make glue GLUE_CFLAGS="$$(pkg-config --cflags glib-2.0 gobject-2.0 gio-2.0)"
GLIB_INC        := $(FRIDA_CORE)/deps/sdk-$(FRIDA_MACHINE)/include/glib-2.0
GLIBCONF_INC    := $(FRIDA_CORE)/deps/sdk-$(FRIDA_MACHINE)/lib/glib-2.0/include
GLUE_CFLAGS     := -I$(GLIB_INC) -I$(GLIBCONF_INC)

.PHONY: all dylib glue generate image test clean

all: dylib glue generate image test

# --- 1. Shared library ----------------------------------------------------
# frida-core ships as static archives. tools/build-dylib.sh derives the full,
# ordered dependency list from frida-core's own pkg-config metadata and resolves
# archive paths from the build tree/SDK, so the recipe is not pinned to exact
# meson subpaths. It force_loads only the archives whose GObject registrations
# must survive dead-stripping.
dylib: $(DYLIB)

$(DYLIB):
	bash tools/build-dylib.sh $(FRIDA_CORE) $(FRIDA_MACHINE) $@

# --- 1b. Async glue shim --------------------------------------------------
# Pure-C bridge: schedules frida_*_begin on frida's own GMainContext thread and
# hands the completed result back to the Pharo thread via signalSemaphoreWithIndex.
glue: $(GLUE)

$(GLUE): $(DYLIB) glue/frida-pharo-glue.c
	clang -fPIC -c glue/frida-pharo-glue.c -o build/dylib/frida-pharo-glue.o \
	  $(GLUE_CFLAGS)
	clang -shared -o $@ build/dylib/frida-pharo-glue.o \
	  -Lbuild/dylib -lfrida-core \
	  $(GLUE_LDFLAGS)

# --- 2. Generate Tonel from .gir -----------------------------------------
generate:
	PYTHONPATH=$(BINDGEN) python3 -m frida_pharo \
	  --frida-gir $(GIR_DIR)/Frida-1.0.gir \
	  --glib-gir $(GIR_DIR)/GLib-2.0.gir \
	  --gobject-gir $(GIR_DIR)/GObject-2.0.gir \
	  --gio-gir $(GIR_DIR)/Gio-2.0.gir \
	  --output-dir $(REPO)/src/FridaPharo

# --- 3. Load into a fresh image ------------------------------------------
image: $(DYLIB)
	cp $(BASE_IMAGE) $(BUILT_IMAGE)
	cp $(PHARO_DIR)/Pharo.changes $(PHARO_DIR)/FridaBuilt.changes
	$(PHARO) $(BUILT_IMAGE) eval --save \
	  "[ Metacello new baseline: 'FridaPharo'; repository: 'tonel://$(REPO)/src'; load. 'ok' ] on: Error do: [:e | e messageText ]"

# --- 4. Run the SUnit suite ----------------------------------------------
test:
	FRIDA_CORE_DYLIB=$(DYLIB) \
	FRIDA_PHARO_GLUE=$(GLUE) \
	FRIDA_EXPECTED_VERSION=$$(python3 -c "import ctypes,sys; l=ctypes.CDLL('$(DYLIB)'); l.frida_version_string.restype=ctypes.c_char_p; sys.stdout.write(l.frida_version_string().decode())") \
	$(PHARO) $(BUILT_IMAGE) test --junit-xml-output FridaPharo-Tests

clean:
	rm -f $(DYLIB) $(GLUE) build/dylib/frida-pharo-glue.o $(BUILT_IMAGE) $(PHARO_DIR)/FridaBuilt.changes

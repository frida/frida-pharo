# frida-pharo bootstrap build/test loop.
#
# Targets:
#   make lib       - link frida-core (+deps) into a uFFI-loadable shared library
#   make generate  - run the Python generator, emitting Tonel into src/FridaPharo
#   make image     - load the baseline into a fresh Pharo image (build/pharo/FridaBuilt.image)
#   make test      - run the SUnit suite headless against that image
#   make all       - lib + generate + image + test

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

# --- Platform-conditional library suffix ----------------------------------
# macOS's ld64 and the GNU toolchain differ on the shared-library suffix;
# tools/build-lib.sh handles the frida-core link's own OS split.
UNAME_S         := $(shell uname -s)
ifeq ($(UNAME_S),Darwin)
LIBEXT          := dylib
else
LIBEXT          := so
endif

CORE_LIB        := $(REPO)/build/dylib/libfrida-core.$(LIBEXT)

.PHONY: all lib generate image test clean

all: lib generate image test

# --- 1. Shared library ----------------------------------------------------
# frida-core ships as static archives. tools/build-lib.sh derives the full,
# ordered dependency list from frida-core's own pkg-config metadata and resolves
# archive paths from the build tree/SDK, so the recipe is not pinned to exact
# meson subpaths. It force_loads only the archives whose GObject registrations
# must survive dead-stripping.
lib: $(CORE_LIB)

$(CORE_LIB):
	bash tools/build-lib.sh $(FRIDA_CORE) $(FRIDA_MACHINE) $@

# --- 2. Generate Tonel from .gir -----------------------------------------
generate:
	PYTHONPATH=$(BINDGEN) python3 -m frida_pharo \
	  --frida-gir $(GIR_DIR)/Frida-1.0.gir \
	  --glib-gir $(GIR_DIR)/GLib-2.0.gir \
	  --gobject-gir $(GIR_DIR)/GObject-2.0.gir \
	  --gio-gir $(GIR_DIR)/Gio-2.0.gir \
	  --output-dir $(REPO)/src/FridaPharo

# --- 3. Load into a fresh image ------------------------------------------
# FridaMainLoop runs as a long-lived background process. SUnit's watchdog
# terminates processes a test leaves running, which would kill the loop between
# tests; this is the frida test image, so we let tests leave it running.
image: $(CORE_LIB)
	cp $(BASE_IMAGE) $(BUILT_IMAGE)
	cp $(PHARO_DIR)/Pharo.changes $(PHARO_DIR)/FridaBuilt.changes
	$(PHARO) $(BUILT_IMAGE) eval --save \
	  "[ Metacello new baseline: 'FridaPharo'; repository: 'tonel://$(REPO)/src'; load. \
	     ProcessMonitorTestService shouldTerminateProcesses: false. \
	     ProcessMonitorTestService shouldFailTestLeavingProcesses: false. 'ok' ] on: Error do: [:e | e messageText ]"

# --- 4. Run the SUnit suite ----------------------------------------------
test:
	FRIDA_CORE_LIB=$(CORE_LIB) \
	FRIDA_EXPECTED_VERSION=$$(python3 -c "import ctypes,sys; l=ctypes.CDLL('$(CORE_LIB)'); l.frida_version_string.restype=ctypes.c_char_p; sys.stdout.write(l.frida_version_string().decode())") \
	$(PHARO) $(BUILT_IMAGE) test --junit-xml-output FridaPharo-Tests

clean:
	rm -f $(CORE_LIB) $(BUILT_IMAGE) $(PHARO_DIR)/FridaBuilt.changes

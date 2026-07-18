#!/usr/bin/env bash
#
# Reproducibly link frida-core's static build into one uFFI-loadable shared
# library, WITHOUT hardcoding the dependency list.
#
# Two modes:
#
#   Source mode (dev builds):
#     build-lib.sh <frida-core-repo> <machine> <output-lib>
#   The authoritative, ordered dependency list comes from frida-core's own
#   pkg-config metadata (the build tree's private .pc plus the SDK .pc files).
#   We force_load the handful of frida archives whose GObject type registrations
#   and cross-references must survive dead-stripping (the API library, frida-gum,
#   the gumjs inspector, and the gioopenssl GIO module) and let pkg-config supply
#   every other -l in the correct order. Archive search paths (-L) are discovered
#   from the build tree and SDK rather than pinned to exact meson subpaths.
#
#   Devkit mode (CI / reproducible):
#     build-lib.sh --devkit <devkit-dir> <output-lib>
#   A published frida-core devkit (frida-core-devkit-<ver>-<os>-<arch>.tar.xz)
#   is a single self-contained static archive (libfrida-core.a, already bundling
#   gum/gumjs/gio/glib/openssl) plus its header and pkg-config file. We whole-
#   archive that one lib and take the extra system deps from the devkit's own
#   .pc (falling back to the platform baseline when absent), so CI needs no full
#   frida-core source build.
#
# The macOS vs GNU-toolchain linker vocabulary (whole-archive spelling, soname,
# system libs) is shared by both modes via platform_setup.
set -euo pipefail

# Restrict the shared library's dynamic exports to the symbols the Pharo uFFI
# layer actually imports -- every ffiCall target plus the glibFunction:/
# symbolAvailable: string literals in the vendored .st sources. This keeps the
# export table to the ~430 frida_*/g_* the binding calls (down from thousands of
# internal gum/gumjs/openssl/glib symbols) and, paired with dead-stripping,
# gives those exports as the roots for discarding unreachable code. Sets
# export_args[]; requires $OUT.
setup_export_list () {
  local src symbols list
  src="$(cd "$(dirname "$0")/.." && pwd)/src"
  symbols=$(
    {
      perl -ne 'while (/ffiCall:\s*#\(\s*\S+\s+(\w+)\s*\(/g) { print "$1\n" }' "$src"/FridaPharo/*.st
      perl -ne "while (/(?:glibFunction|symbolAvailable):\s*'([A-Za-z_]\w*)'/g) { print \"\$1\\n\" }" \
        "$src"/FridaPharo/*.st "$src"/FridaPharo-Tests/*.st
    } | sort -u
  )
  list="$OUT.exported-symbols"
  case "$(uname -s)" in
    Darwin)
      printf '_%s\n' $symbols > "$list"
      export_args=(-Wl,-exported_symbols_list,"$list")
      ;;
    *)
      { echo '{'; echo '  global:'; printf '    %s;\n' $symbols; echo '  local: *;'; echo '};'; } > "$list"
      export_args=(-Wl,--version-script="$list")
      ;;
  esac
}

# Sets: force_load_prefix (fn), soname_args[], system_libs[], strip_args[].
# Requires $OUT.
platform_setup () {
  case "$(uname -s)" in
    Darwin)
      force_load_prefix () { printf -- '-Wl,-force_load,%s' "$1"; }
      soname_args=(-install_name "@rpath/$(basename "$OUT")")
      system_libs=(-framework Foundation -framework AppKit -framework IOKit
        -framework Security -framework CoreFoundation -framework CoreServices
        -framework CoreGraphics -framework Network -lresolv -lbsm -lm)
      # Discard code unreachable from the exported roots (constructors / +load /
      # module-init reachable from the force_loaded archives stay live, so the
      # GObject type registrations survive), then drop the local symbol table
      # and debug info. The dynamic export trie is left intact.
      strip_args=(-Wl,-dead_strip -Wl,-x -Wl,-S)
      ;;
    *)
      # GNU ld: --whole-archive brackets the force-loaded archives. Emit them as
      # a single token per archive that the link step expands into three args.
      force_load_prefix () { printf -- '-Wl,--whole-archive,%s,--no-whole-archive' "$1"; }
      soname_args=(-Wl,-soname,"$(basename "$OUT")")
      system_libs=(-lpthread -ldl -lm -lrt -lresolv)
      # --gc-sections drops unreachable sections; -s strips all non-dynamic
      # symbols and debug info (the .dynsym export table is kept).
      strip_args=(-Wl,--gc-sections -Wl,-s)
      ;;
  esac
}

# --- Devkit mode ----------------------------------------------------------
if [ "${1:-}" = "--devkit" ]; then
  DEVKIT=$2
  OUT=$3
  platform_setup

  archive="$DEVKIT/libfrida-core.a"
  [ -f "$archive" ] || { echo "error: $archive not found" >&2; exit 1; }

  # Extra system deps from the devkit's own pkg-config metadata, if it ships any.
  extra_libs=()
  pc=$(ls "$DEVKIT"/*.pc 2>/dev/null | head -1 || true)
  if [ -n "$pc" ]; then
    pcname=$(basename "$pc" .pc)
    for tok in $(PKG_CONFIG_PATH="$DEVKIT" pkg-config --static --libs "$pcname" 2>/dev/null || true); do
      case "$tok" in
        -L*|-lfrida-core|-lfrida-core-1.0) ;;  # the archive itself / bogus prefix
        *) extra_libs+=("$tok") ;;
      esac
    done
  fi
  # Fall back to the platform baseline when the devkit ships no usable metadata
  # (a documented first-CI-run tuning point).
  [ ${#extra_libs[@]} -ne 0 ] || extra_libs=("${system_libs[@]}")

  # The published devkit renames every bundled glib/gobject/gio symbol with a
  # _frida_ prefix (g_object_unref -> _frida_g_object_unref, and so on), so the
  # plain names are gone from the exports -- only frida_* and these prefixed
  # copies remain. Our FFI layer and glue still call glib by its canonical name,
  # so re-export an alias from each prefixed symbol back to its plain name. This
  # binds every glib call to frida's OWN bundled glib -- the single type universe
  # its GObjects are registered in -- rather than a second, ABI-incompatible
  # system glib (which yields "non-instantiatable type" GObject corruption).
  alias_args=()
  while read -r sym; do
    alias_args+=("-Wl,--defsym,${sym#_frida_}=${sym}")
  done < <(nm "$archive" 2>/dev/null | awk '$2 == "T" && $3 ~ /^_frida_g_/ { print $3 }' | sort -u)

  mkdir -p "$(dirname "$OUT")"
  setup_export_list
  exec clang -shared -o "$OUT" \
    "$(force_load_prefix "$archive")" \
    -L"$DEVKIT" \
    "${extra_libs[@]}" \
    ${alias_args[@]+"${alias_args[@]}"} \
    "${export_args[@]}" \
    "${strip_args[@]}" \
    "${soname_args[@]}"
fi

# --- Source mode ----------------------------------------------------------
FRIDA_CORE=$1
MACHINE=$2
OUT=$3

BUILD="$FRIDA_CORE/build/$MACHINE"
SDK="$FRIDA_CORE/deps/sdk-$MACHINE/lib"

platform_setup

# Authoritative dependency list from the build tree's pkg-config graph.
PCP="$BUILD/meson-private:$SDK/pkgconfig"
libs=$(PKG_CONFIG_PATH="$PCP" pkg-config --static --libs frida-core-1.0)

# Archives we must force_load (order matters: they cross-reference each other).
FORCE_NAMES=(frida-core-1.0 frida-gum-1.0 frida-gumjs-inspector-1.0 gioopenssl)

# Every directory under the build tree or SDK that holds a static archive; used
# both as -L search paths and to resolve the force_load archives by name.
# (Portable to macOS's bash 3.2 -- no mapfile/process-substitution.)
archive_dirs=$( (find "$BUILD" -name '*.a' -not -path '*arch-support*' -exec dirname {} \; ; find "$SDK" -name '*.a' -exec dirname {} \;) | sort -u )

force_load_args=()
for name in "${FORCE_NAMES[@]}"; do
  path=$(find "$BUILD" "$SDK" -name "lib$name.a" -not -path '*arch-support*' | head -1)
  [ -n "$path" ] || { echo "error: lib$name.a not found" >&2; exit 1; }
  force_load_args+=("$(force_load_prefix "$path")")
done

# Drop the force_loaded libraries from the pkg-config -l list (avoid double
# linking) and rewrite the bogus install-prefix -L flags to our real dirs.
link_args=()
for tok in $libs; do
  case "$tok" in
    -L*) ;;  # replaced by discovered dirs below
    -lfrida-core-1.0|-lfrida-gum-1.0|-lfrida-gumjs-inspector-1.0|-lgioopenssl) ;;
    *) link_args+=("$tok") ;;
  esac
done

search_args=()
for d in $archive_dirs; do search_args+=(-L"$d"); done

mkdir -p "$(dirname "$OUT")"
setup_export_list
exec clang -shared -o "$OUT" \
  "${force_load_args[@]}" \
  "${search_args[@]}" \
  "${link_args[@]}" \
  "${system_libs[@]}" \
  "${export_args[@]}" \
  "${strip_args[@]}" \
  "${soname_args[@]}"

#!/usr/bin/env bash
#
# Link frida-core's devkit into one uFFI-loadable shared library.
#
#   build-lib.sh <devkit-dir> <output-lib>
#
# A frida-core devkit -- published as frida-core-devkit-<ver>-<os>-<arch>.tar.xz,
# or built from a frida-core tree with `--with-devkits=core` -- is a single self-
# contained static archive (libfrida-core.a, already bundling gum/gumjs/gio/glib/
# openssl) plus a header and .gir. This is the only thing we link against: users
# get a prebuilt automatically (see FridaLibrary), CI downloads the devkit, and a
# contributor testing unreleased frida-core changes builds a core devkit.
#
# We whole-archive the one .a, take extra system deps from the devkit's own
# pkg-config metadata when present (else a platform baseline), alias the devkit's
# _frida_-prefixed glib symbols back to their plain names, limit the dynamic
# exports to the symbols the Pharo uFFI layer imports, and dead-strip + strip
# everything else.
set -euo pipefail

# Every ffiCall target plus the glibFunction:/symbolAvailable: string literals in
# the vendored .st -- the ~430 frida_*/g_* the binding calls, hiding the thousands
# of internal symbols. These are the roots the export limit and strip step keep.
src="$(cd "$(dirname "$0")/.." && pwd)/src"
scan_symbols() {
  {
    perl -ne 'while (/ffiCall:\s*#\(\s*\S+\s+(\w+)\s*\(/g) { print "$1\n" }' "$src"/FridaPharo/*.st
    perl -ne "while (/(?:glibFunction|symbolAvailable):\s*'([A-Za-z_]\w*)'/g) { print \"\$1\\n\" }" \
      "$src"/FridaPharo/*.st "$src"/FridaPharo-Tests/*.st
  } | sort -u
}

# --symbols prints the import set (the Makefile gates relinking on its content).
if [ "${1:-}" = "--symbols" ]; then
  scan_symbols
  exit 0
fi

DEVKIT=$1
OUT=$2

archive="$DEVKIT/libfrida-core.a"
[ -f "$archive" ] || { echo "error: $archive not found (pass an extracted devkit dir)" >&2; exit 1; }

# --- Platform vocabulary --------------------------------------------------
# macOS ld64 vs GNU ld differ on whole-archive spelling, soname, the baseline
# system libs, and how to strip. All keep the dynamic export table intact.
arch_args=()
case "$(uname -s)" in
  Darwin)
    whole_archive=(-Wl,-force_load,"$archive")
    soname_args=(-install_name "@rpath/$(basename "$OUT")")
    baseline_libs=(-framework Foundation -framework AppKit -framework IOKit
      -framework Security -framework CoreFoundation -framework CoreServices
      -framework CoreGraphics -framework Network -lresolv -lbsm -lm)
    strip_args=(-Wl,-dead_strip -Wl,-x -Wl,-S)
    arch_args=(-arch "$(lipo -archs "$archive" | awk '{print $1}')")
    ;;
  *)
    whole_archive=(-Wl,--whole-archive,"$archive",--no-whole-archive)
    soname_args=(-Wl,-soname,"$(basename "$OUT")")
    baseline_libs=(-lpthread -ldl -lm -lrt -lresolv)
    strip_args=(-Wl,--gc-sections -Wl,-s)
    ;;
esac

# --- Extra system deps from the devkit's .pc, else the platform baseline ---
# (Published devkits ship no .pc, so this normally falls back to the baseline;
# a documented first-CI-run tuning point.)
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
[ ${#extra_libs[@]} -ne 0 ] || extra_libs=("${baseline_libs[@]}")

# --- Alias the devkit's _frida_-prefixed glib symbols to plain names -------
# The devkit renames every bundled glib/gobject/gio symbol with a _frida_ prefix
# (g_object_unref -> _frida_g_object_unref), so the plain names are gone. Our FFI
# layer calls glib by its canonical name, so re-export an alias from each prefixed
# symbol back to its plain name -- binding every glib call to frida's OWN bundled
# glib (the single type universe its GObjects are registered in) rather than a
# second, ABI-incompatible system glib.
alias_args=()
while read -r sym; do
  alias_args+=("-Wl,--defsym,${sym#_frida_}=${sym}")
done < <("${NM:-nm}" "$archive" 2>/dev/null | awk '$2 == "T" && $3 ~ /^_frida_g_/ { print $3 }' | sort -u)

# --- Limit dynamic exports to the uFFI import set -------------------------
symbols=$(scan_symbols)

mkdir -p "$(dirname "$OUT")"
export_list="$OUT.exported-symbols"
case "$(uname -s)" in
  Darwin)
    printf '_%s\n' $symbols > "$export_list"
    export_args=(-Wl,-exported_symbols_list,"$export_list")
    ;;
  *)
    { echo '{'; echo '  global:'; printf '    %s;\n' $symbols; echo '  local: *;'; echo '};'; } > "$export_list"
    export_args=(-Wl,--version-script="$export_list")
    ;;
esac

# --- Link -----------------------------------------------------------------
exec "${CC:-clang}" -shared -o "$OUT" \
  ${arch_args[@]+"${arch_args[@]}"} \
  "${whole_archive[@]}" \
  -L"$DEVKIT" \
  "${extra_libs[@]}" \
  ${alias_args[@]+"${alias_args[@]}"} \
  "${export_args[@]}" \
  "${strip_args[@]}" \
  "${soname_args[@]}"

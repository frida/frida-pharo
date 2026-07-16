from __future__ import annotations

import argparse
from pathlib import Path

from . import codegen
from .customization import load_customizations
from .loader import compute_model


def main():
    run(build_arguments())


def build_arguments() -> argparse.Namespace:
    p = argparse.ArgumentParser(description="Generate the Pharo bindings for Frida.")
    p.add_argument("--frida-gir", required=True, type=Path)
    p.add_argument("--glib-gir", required=True, type=Path)
    p.add_argument("--gobject-gir", required=True, type=Path)
    p.add_argument("--gio-gir", required=True, type=Path)
    p.add_argument(
        "--output-dir",
        required=True,
        type=Path,
        help="Tonel package directory to write generated .class.st files into.",
    )
    return p.parse_args()


def run(args: argparse.Namespace) -> None:
    customizations = load_customizations()
    model = compute_model(
        args.frida_gir, args.glib_gir, args.gobject_gir, args.gio_gir, customizations
    )

    artefacts = codegen.generate_all(model)

    args.output_dir.mkdir(parents=True, exist_ok=True)
    for filename, contents in artefacts.items():
        _write_if_changed(args.output_dir / filename, contents)


def _write_if_changed(path: Path, contents: str) -> None:
    if path.exists() and path.read_text(encoding="utf-8") == contents:
        return
    path.write_text(contents, encoding="utf-8")

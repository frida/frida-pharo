from __future__ import annotations

from pathlib import Path

import frida_bindgen_core as core

from .model import FACTORY, Customizations, Model

# Kept small on purpose for the bootstrap: the version+enum slice needs no Gio
# object types yet. Widen these as the object surface grows.
INCLUDED_GIO_OBJECT_TYPES: list[str] = []
INCLUDED_GIO_ENUMERATIONS: list[str] = []


def compute_model(
    frida_gir: Path,
    glib_gir: Path,
    gobject_gir: Path,
    gio_gir: Path,
    customizations: Customizations,
) -> Model:
    return core.compute_model(
        frida_gir,
        glib_gir,
        gobject_gir,
        gio_gir,
        customizations,
        FACTORY,
        INCLUDED_GIO_OBJECT_TYPES,
        INCLUDED_GIO_ENUMERATIONS,
        seed_object_first=True,
    )

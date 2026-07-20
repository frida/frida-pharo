from __future__ import annotations

from .model import (
    Customizations,
    FacadeMethod,
    NamespaceFunction,
    ObjectTypeCustomizations,
    PrintSpec,
)

# Namespace-level Frida functions that are not attached to any GObject type and
# therefore don't appear in the .gir class model. These are wired here as data
# and emitted as class-side methods on the `Frida` facade.
NAMESPACE_FUNCTIONS = (
    NamespaceFunction(
        pharo_name="version",
        c_symbol="frida_version_string",
        return_typing="String",
        arg_typings=[],
    ),
)


# RpcClient's `call` traffics in JsonNode (json-glib), a namespace this bootstrap
# doesn't load; drop it like the other bindings do until GVariant/JSON marshalling
# lands.
TYPE_CUSTOMIZATIONS = {
    "RpcClient": ObjectTypeCustomizations(drop=True),
}


# High-level facade sugar. The bodies are Frida-specific, so they live here as
# data rather than in the type-agnostic codegen.
FACADE_METHODS = (
    FacadeMethod(
        target="Frida",
        class_side=True,
        selector="deviceManager",
        body=["^ DeviceManager ifNil: [ DeviceManager := FridaDeviceManager new ]"],
    ),
    FacadeMethod(
        target="Frida",
        class_side=True,
        selector="closeDeviceManager",
        body=[
            "DeviceManager ifNil: [ ^ self ].",
            "DeviceManager close.",
            "DeviceManager := nil",
        ],
    ),
    FacadeMethod(
        target="Frida",
        class_side=True,
        selector="localDevice",
        body=[
            "^ self deviceManager",
            "\tgetDeviceByType: #local",
            "\ttimeout: 0",
        ],
    ),
    FacadeMethod(
        target="FridaScript",
        class_side=False,
        selector="exports",
        body=["^ FridaRpcExports on: self"],
    ),
    # Script sugar: post JSON without an accompanying binary blob.
    FacadeMethod(
        target="FridaScript",
        class_side=False,
        selector="post: json",
        body=["^ self post: json data: nil"],
    ),
    # Processes and applications carry an 'icons' array in their parameters; wrap
    # each entry as a FridaIcon that renders graphically in the inspector. They also
    # opt into the FridaList inspector's icon-first alphabetical ordering.
    *[
        method
        for target in ("FridaApplication", "FridaProcess")
        for method in (
            FacadeMethod(
                target=target,
                class_side=False,
                selector="icons",
                category="accessing",
                body=["^ (self parameters at: 'icons' ifAbsent: [ #() ]) collect: [ :each | FridaIcon fromDictionary: each ]"],
            ),
            FacadeMethod(
                target=target,
                class_side=False,
                selector="hasIcon",
                category="accessing",
                body=["^ self icons notEmpty"],
            ),
            FacadeMethod(
                target=target,
                class_side=False,
                selector="preferredIcon",
                category="accessing",
                body=["^ self icons detectMax: [ :each | each width ]"],
            ),
            FacadeMethod(
                target=target,
                class_side=False,
                selector="fridaListSortsByName",
                category="inspecting",
                body=["^ true"],
            ),
        )
    ],
    # A device carries a single icon variant; wrap it the same way. Devices keep
    # their natural enumeration order, so they don't opt into sorting.
    FacadeMethod(
        target="FridaDevice",
        class_side=False,
        selector="preferredIcon",
        category="accessing",
        body=[
            "| variant |",
            "variant := self icon.",
            "(variant isNil or: [ variant isEmpty ]) ifTrue: [ ^ nil ].",
            "^ FridaIcon fromDictionary: variant",
        ],
    ),
    FacadeMethod(
        target="FridaDevice",
        class_side=False,
        selector="hasIcon",
        category="accessing",
        body=["^ self preferredIcon notNil"],
    ),
    # Graphical single-icon inspector view, shared by every icon-bearing type.
    *[
        FacadeMethod(
            target=target,
            class_side=False,
            selector="gtIconFor: aView",
            category="inspecting",
            body=[
                "<gtView>",
                "| icon |",
                "icon := self preferredIcon.",
                "icon ifNil: [ ^ aView empty ].",
                "^ aView explicit",
                "\ttitle: 'Icon';",
                "\tpriority: 15;",
                "\tstencil: [ icon asForm asElement ]",
            ],
        )
        for target in ("FridaApplication", "FridaProcess", "FridaDevice")
    ],
    # DeviceManager lookups take a timeout in milliseconds; default it to 0 (return
    # immediately) so callers can omit it, mirroring the cancellable overloads.
    *[
        FacadeMethod(
            target="FridaDeviceManager",
            class_side=False,
            selector=selector,
            category="convenience",
            body=[body],
        )
        for selector, body in (
            ("getDeviceById: id", "^ self getDeviceById: id timeout: 0"),
            ("getDeviceByType: type", "^ self getDeviceByType: type timeout: 0"),
            ("findDeviceById: id", "^ self findDeviceById: id timeout: 0"),
            ("findDeviceByType: type", "^ self findDeviceByType: type timeout: 0"),
        )
    ],
)


# GIR types outside the Frida namespace with a hand-written Pharo wrapper. Wiring
# Gio.IOStream here un-skips FridaDevice>>openChannel:, whose async result is a
# GIOStream* rather than a Frida GObject.
EXTERNAL_OBJECT_TYPES = {
    "Gio.IOStream": "FridaIOStream",
}


# Identifying properties printed by each type's generated #printOn:. Data only;
# the codegen stays type-agnostic (see codegen._emit_print_on).
PRINT_SPECS = (
    PrintSpec("FridaDevice", ["id", "name"]),
    PrintSpec("FridaProcess", ["pid", "name"]),
    PrintSpec("FridaApplication", ["identifier", "pid"]),
    PrintSpec("FridaSpawn", ["pid", "identifier"]),
    PrintSpec("FridaChild", ["pid", "identifier"]),
    PrintSpec("FridaSession", ["pid"]),
    PrintSpec("FridaCrash", ["pid", "processName"]),
)


def load_customizations() -> Customizations:
    return Customizations(
        namespace_functions=NAMESPACE_FUNCTIONS,
        facade_methods=FACADE_METHODS,
        facade_class_vars={"Frida": ["DeviceManager"]},
        type_customizations=TYPE_CUSTOMIZATIONS,
        external_object_types=EXTERNAL_OBJECT_TYPES,
        print_specs=PRINT_SPECS,
    )

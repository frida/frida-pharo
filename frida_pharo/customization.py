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
        selector="localDevice",
        body=[
            "^ self deviceManager",
            "\tgetDeviceByType: FridaDeviceType FridaDeviceTypeLocal",
            "\ttimeout: 0",
        ],
    ),
    FacadeMethod(
        target="FridaScript",
        class_side=False,
        selector="onMessage: aBlock",
        body=["^ FridaSignalSubscription onScriptMessage: self do: aBlock"],
    ),
    FacadeMethod(
        target="FridaScript",
        class_side=False,
        selector="exports",
        body=["^ FridaRpcExports on: self"],
    ),
    # Device sugar: spawn with default options.
    FacadeMethod(
        target="FridaDevice",
        class_side=False,
        selector="spawn: program",
        body=["^ self spawn: program options: nil"],
    ),
    # Session sugar: create an unconfigured script.
    FacadeMethod(
        target="FridaSession",
        class_side=False,
        selector="createScript: source",
        body=["^ self createScript: source options: nil"],
    ),
    # Device sugar: attach with default options.
    FacadeMethod(
        target="FridaDevice",
        class_side=False,
        selector="attach: pid",
        body=["^ self attach: pid options: nil"],
    ),
    # Device sugar: find a process with default match options.
    FacadeMethod(
        target="FridaDevice",
        class_side=False,
        selector="findProcessByName: name",
        body=["^ self findProcessByName: name options: nil"],
    ),
    FacadeMethod(
        target="FridaDevice",
        class_side=False,
        selector="findProcessByPid: pid",
        body=["^ self findProcessByPid: pid options: nil"],
    ),
    # Script sugar: post JSON without an accompanying binary blob.
    FacadeMethod(
        target="FridaScript",
        class_side=False,
        selector="post: json",
        body=["^ self post: json data: nil"],
    ),
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

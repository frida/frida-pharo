from __future__ import annotations

from collections import OrderedDict
from dataclasses import dataclass, field
from functools import cached_property
from typing import List, Mapping, Optional, Sequence, Tuple

import frida_bindgen_core as core
from frida_bindgen_core.naming import to_pascal_case


class Model(core.Model):
    @cached_property
    def regular_object_types(self) -> List[ObjectType]:
        return [t for t in self.object_types.values() if not t.is_frida_list]


class ObjectType(core.ObjectType):
    @cached_property
    def pharo_name(self) -> str:
        return self.c_type


class ClassObjectType(ObjectType):
    pass


class InterfaceObjectType(ObjectType):
    pass


class Constructor(core.Constructor):
    pass


class Method(core.Method):
    pass


class Property(core.Property):
    pass


class Signal(core.Signal):
    pass


class Parameter(core.Parameter):
    pass


class ReturnValue(core.ReturnValue):
    pass


class Enumeration(core.Enumeration):
    @cached_property
    def pharo_name(self) -> str:
        return self.c_type

    @cached_property
    def pharo_members(self) -> List[Tuple[str, int]]:
        """(Pharo member name, integer value), read straight off the .gir elements.

        The core EnumerationMember only carries name + C identifier, so we read
        the numeric ``value`` attribute off the raw XML here instead.
        """
        result = []
        for element in self._members:
            # Prefix with the enum name so members materialised as shared
            # variables never collide with existing Pharo globals, e.g.
            # FridaScriptRuntimeDefault, FridaXnuBsdSyscallSocket.
            name = self.pharo_name + to_pascal_case(element.get("name"))
            value = int(element.get("value"))
            result.append((name, value))
        return result


class EnumerationMember(core.EnumerationMember):
    pass


@dataclass
class NamespaceFunction:
    pharo_name: str
    c_symbol: str
    return_typing: str
    arg_typings: List[str] = field(default_factory=list)


@dataclass
class FacadeMethod:
    """A hand-authored convenience method (Smalltalk body) placed on a class.

    Used for the high-level facade sugar (e.g. Frida class >> localDevice) whose
    logic is Frida-specific and therefore lives here as data, not in codegen.
    """
    target: str            # Pharo class name, e.g. "Frida"
    class_side: bool
    selector: str          # full selector, e.g. "localDevice" or "attach: pid"
    body: List[str]        # Smalltalk statement lines
    category: str = "facade"


@dataclass
class ObjectTypeCustomizations:
    drop: bool = False
    constructor: Optional[object] = None
    methods: Mapping[str, object] = field(default_factory=dict)
    properties: Mapping[str, object] = field(default_factory=dict)
    signals: Mapping[str, object] = field(default_factory=dict)


@dataclass
class PrintSpec:
    """Which property selectors identify a type in its #printOn: output.

    Data only: the codegen emits a generic #printOn: reading these selectors, so
    the choice of identifying fields per type stays out of the type-agnostic
    generator.
    """
    target: str            # Pharo class name, e.g. "FridaDevice"
    properties: List[str]  # camelCase selectors, e.g. ["id", "name"]


@dataclass
class Customizations:
    namespace_functions: Sequence[NamespaceFunction] = ()
    # Enumerations whose members carry generic names (e.g. the XNU syscall
    # tables) collide with existing Pharo globals when materialised as shared
    # variables. Dropped here as data until a namespacing scheme is chosen.
    dropped_enumerations: Sequence[str] = ()
    facade_methods: Sequence[FacadeMethod] = ()
    # Class variables to declare on a facade class (target Pharo class name ->
    # shared variable names), e.g. a lazily-cached singleton a facade method
    # memoises. Data only; the codegen just declares them.
    facade_class_vars: Mapping[str, Sequence[str]] = field(default_factory=dict)
    type_customizations: Mapping[str, object] = field(default_factory=OrderedDict)
    # GIR types outside the Frida namespace that nonetheless have a hand-written
    # Pharo wrapper (e.g. Gio.IOStream -> FridaIOStream). Maps the fully-qualified
    # GIR type name to the wrapper's Pharo class name so the generic type mapper
    # can marshal them as objects.
    external_object_types: Mapping[str, str] = field(default_factory=dict)
    # Per-type identifying properties for #printOn: (see PrintSpec).
    print_specs: Sequence[PrintSpec] = ()


def _make_class(*, name, c_type, get_type, type_struct, parent, constructors,
                methods, properties, signals, implements, resolve_type, model):
    return ClassObjectType(name, c_type, get_type, type_struct, parent,
                           constructors, methods, properties, signals,
                           resolve_type, model)


def _make_interface(*, name, c_type, get_type, type_struct, parent, constructors,
                    methods, properties, signals, resolve_type, model):
    return InterfaceObjectType(name, c_type, get_type, type_struct, parent,
                               constructors, methods, properties, signals,
                               resolve_type, model)


FACTORY = core.Factory(
    class_object_type=_make_class,
    interface_object_type=_make_interface,
    constructor=Constructor,
    method=Method,
    parameter=Parameter,
    return_value=ReturnValue,
    signal=Signal,
    property_=Property,
    enumeration=Enumeration,
    enumeration_member=EnumerationMember,
    model=Model,
)


def parse_gir(file_path: str, dependencies: Sequence[Model]) -> Model:
    return core.parse_gir(file_path, dependencies, FACTORY)

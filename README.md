# frida-pharo

Pharo/Smalltalk bindings for [Frida](https://frida.re), the dynamic
instrumentation toolkit.

The binding is **auto-generated** from Frida's GObject-Introspection metadata
(`Frida-1.0.gir`) by the shared `frida_bindgen_core` generator, and vendored as
[Tonel](https://github.com/pharo-vcs/tonel) source under `src/FridaPharo/`. At
runtime it talks to a hand-linked `libfrida-core` shared library through Pharo's
uFFI, with a small C shim (`libfrida-pharo-glue`) bridging Frida's asynchronous,
single-threaded C API onto the Pharo scheduler.

## Loading the bindings

The generated Tonel sources load into any Pharo 11+ image via Metacello:

```smalltalk
Metacello new
	baseline: 'FridaPharo';
	repository: 'tonel:///path/to/frida-pharo/src';
	load.
```

At image start-up (or before the first call) the runtime dynamically loads the
two shared libraries. Point it at them via the `FRIDA_CORE_DYLIB` and
`FRIDA_PHARO_GLUE` environment variables (as the test harness does), or install
them where the OS loader can find them.

## Usage

```smalltalk
"Enumerate the processes running on the local device."
device := Frida localDevice.
(device enumerateProcesses: nil) do: [ :process |
	Transcript showLn: process pid printString, ' ', process name ].

"Attach, inject a script, and receive its messages."
session := device attach: (device getProcessByName: 'Twitter') pid.
script := session createScript: 'Interceptor.attach(Module.getExportByName(null, "open"), {
	onEnter(args) { send(args[0].readUtf8String()); }
});'.
script onMessage: [ :message | Transcript showLn: message ].
script load.

"Call RPC exports exposed by the script via rpc.exports."
result := script exports add: 3 to: 4.

"Subscribe to any GObject signal; the block runs on the Pharo thread."
session on: 'detached' do: [ :args | Transcript showLn: 'detached: ', args printString ].

"Spawn, instrument at start-up, then resume."
pid := device spawn: '/bin/ls'.
session := device attach: pid.
"... createScript / load ..."
device resume: pid.
```

Async Frida operations (`attach:`, `spawn:`, `enumerateProcesses:`, ...) are
exposed as ordinary synchronous-looking Pharo methods: the call is scheduled on
Frida's own thread and the calling Pharo process blocks on a semaphore until the
result (or a `FridaError`) comes back.

## Building from source

`make all` performs the full loop end to end:

1. **dylib** — `tools/build-dylib.sh` links frida-core's static archives into one
   uFFI-loadable shared library, deriving the ordered dependency list from
   frida-core's own pkg-config metadata. The link vocabulary is OS-conditional
   (`-force_load` + frameworks on macOS, `--whole-archive` + system libs on
   Linux), so it produces a `.dylib` or `.so` as appropriate.
2. **glue** — compiles the `libfrida-pharo-glue` async/signal shim.
3. **generate** — runs the Python generator over the `.gir` files, refreshing the
   Tonel sources under `src/FridaPharo/`.
4. **image** — loads the baseline into a fresh Pharo image.
5. **test** — runs the SUnit suite headless.

Override the defaults on the command line as needed, e.g.:

```sh
make all FRIDA_CORE=/path/to/frida-core FRIDA_MACHINE=linux-x86_64
```

## Layout

| Path                     | What it is                                             |
| ------------------------ | ------------------------------------------------------ |
| `frida_pharo/`           | The generator: thin model subclasses, data-only `customization.py`, type-agnostic `codegen.py`. |
| `frida-bindgen/`         | The shared `frida_bindgen_core` generator (submodule). |
| `glue/frida-pharo-glue.c`| The C async/signal bridge.                             |
| `src/FridaPharo/`        | Vendored generated Tonel sources + the hand-written runtime base classes (`FridaObject`, `FridaSignalSubscription`, `FridaVariant`, ...). |
| `src/FridaPharo-Tests/`  | The SUnit suite.                                        |
| `tools/build-dylib.sh`   | Reproducible frida-core static-to-shared link step.    |

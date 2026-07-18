# frida-pharo

Pharo/Smalltalk bindings for [Frida](https://frida.re), the dynamic
instrumentation toolkit.

The binding is **auto-generated** from Frida's GObject-Introspection metadata
(`Frida-1.0.gir`) by the shared `frida_bindgen_core` generator, and vendored as
[Tonel](https://github.com/pharo-vcs/tonel) source under `src/FridaPharo/`. At
runtime it talks to a hand-linked `libfrida-core` shared library through Pharo's
uFFI. There is no C glue: Frida is initialised with the GLib runtime and its
GMainContext is driven directly from Smalltalk (`FridaMainLoop`), so async
completions and signals dispatch on the Pharo thread.

## Loading the bindings

The generated Tonel sources load into any Pharo 11+ image via Metacello,
straight from GitHub:

```smalltalk
Metacello new
	baseline: 'FridaPharo';
	repository: 'github://frida/frida-pharo:main/src';
	load.
```

Nothing to compile: on first use, `FridaLibrary` downloads the prebuilt
`libfrida-core` for the current platform and pinned frida version from the
GitHub release, verifies it against `SHA256SUMS`, and caches it next to the
image. So `Frida localDevice` just works.

To use a local build instead (contributors, or an unreleased frida version),
set the `FRIDA_CORE_LIB` environment variable to its path — it takes
precedence over the download.

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

Only needed for development — end users get a prebuilt library automatically
(see [Loading the bindings](#loading-the-bindings)). The prebuilts themselves are
produced by the `Release prebuilt libraries` workflow, which links the same
`tools/build-lib.sh` against frida-core's published devkit for each platform.

`make all` performs the full loop end to end:

1. **lib** — `tools/build-lib.sh` links frida-core's static archives into one
   uFFI-loadable shared library, deriving the ordered dependency list from
   frida-core's own pkg-config metadata. The link vocabulary is OS-conditional
   (`-force_load` + frameworks on macOS, `--whole-archive` + system libs on
   Linux), so it produces a `.dylib` or `.so` as appropriate.
2. **generate** — runs the Python generator over the `.gir` files, refreshing the
   Tonel sources under `src/FridaPharo/`.
3. **image** — loads the baseline into a fresh Pharo image.
4. **test** — runs the SUnit suite headless.

Override the defaults on the command line as needed, e.g.:

```sh
make all FRIDA_CORE=/path/to/frida-core FRIDA_MACHINE=linux-x86_64
```

## Layout

| Path                     | What it is                                             |
| ------------------------ | ------------------------------------------------------ |
| `frida_pharo/`           | The generator: thin model subclasses, data-only `customization.py`, type-agnostic `codegen.py`. |
| `frida-bindgen/`         | The shared `frida_bindgen_core` generator (submodule). |
| `src/FridaPharo/`        | Vendored generated Tonel sources + the hand-written runtime base classes (`FridaObject`, `FridaMainLoop`, `FridaSignalSubscription`, `FridaVariant`, ...). |
| `src/FridaPharo-Tests/`  | The SUnit suite.                                        |
| `tools/build-lib.sh`   | Reproducible frida-core static-to-shared link step.    |

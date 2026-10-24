# AGENTS.md

Guidance for coding agents working in this repo: Thyris, Tacit's browser, a Qt Quick application on Chromium's engine
(CEF). Read CONTRIBUTING.md first: it says what changes are welcome, what needs agreement first, and the design rules
every change keeps.

## How changes get in

This repo is published from the one Thyris is developed in. Pull requests are read line by line and applied there with
their author kept; nothing is merged on GitHub. Keep a pull request to one fix or one agreed change, and sign off every
commit (`git commit -s`).

## Layout

| Path | What it is |
|---|---|
| `PLAN.md` | the browser's behaviour, screen by screen. A change to what Thyris does updates PLAN.md in the same commit |
| `DESIGN.md` | its visual language |
| `qml/` | the interface: `Main.qml` (a window), `Rail.qml` (the side rail), `Session.qml` (tasks, pages, pins), ... |
| `src/` | C++: the application, and `src/cef/` the bridge to the engine |
| `engine/` | Tacit's patches to Chromium and CEF and how the engine is built; the build takes hours on a large machine, so work against the installed `tacit-cef` |
| `adblock/` | content blocking (Rust) |
| `tests/`, `tools/` | checks and development tools |

## Building

On a computer running Tacit, which already has the engine (`tacit-cef`):

```bash
sudo pacman -S --needed tacit-cef-sdk cmake ninja rust qt6-shadertools
cp -a /usr/share/tacit/cef-sdk ~/src/cef && mkdir -p ~/src/cef/Release
ln -sf /usr/lib/tacit/cef/libcef.so /usr/lib/tacit/cef/icudtl.dat ~/src/cef/Release/
cmake -S ~/src/cef -B ~/src/cef/build -G Ninja -DCMAKE_BUILD_TYPE=Release -DPROJECT_ARCH=x86_64
cmake --build ~/src/cef/build --target libcef_dll_wrapper
cmake -S . -B build -G Ninja -DCMAKE_BUILD_TYPE=Release -DBROWSER_ENGINE=cef -DCEF_ROOT=$HOME/src/cef
cmake --build build --target browser browser-page
```

`-DPROJECT_ARCH=arm64` on ARM computers. These are the steps Tacit's own package uses (tacit-build, `tacit-thyris`).

## Rules for code

- **The page is the window.** Thyris has no toolbar; what a toolbar would carry lives in the rail and the notch
  (PLAN.md). Do not add floating windows: links, sign-ins and popups open as pages.
- **Colours come from the desktop's palette** through `qml/Theme.qml`. Never write a colour value.
- **Wayland only.** No X11 code or fallbacks.
- **Match the code around you:** its naming, idiom and comment density. Comments say what the code does and why, in
  plain words. Do not reformat files you are not changing.
- **Do not edit** README.md, CONTRIBUTING.md, AGENTS.md, CLAUDE.md, LICENSE, `.github/` or `docs/`: they are written
  by the publishing step and a change to them is lost.

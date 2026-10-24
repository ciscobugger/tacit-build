# AGENTS.md

Guidance for coding agents working in this repo: Tacit's desktop and its own apps, written in QML on
[Quickshell](https://quickshell.outfoxxed.me) and [Hyprland](https://hyprland.org). Read CONTRIBUTING.md first: it says
what changes are welcome, what needs agreement first, and the design rules every change keeps.

## How changes get in

This repo is published from the one Tacit is developed in. Pull requests are read line by line and applied there with
their author kept; nothing is merged on GitHub. Keep a pull request to one fix or one agreed change, and sign off every
commit (`git commit -s`).

## Layout

| Path | What it is |
|---|---|
| `shell.qml` | the desktop: notch, palette, panels, notifications, lock |
| `tacit-settings.qml` | Settings |
| `claude.qml` | Praxis, the agent session app |
| `code.qml` | Pinax (files) and Graphis (code) |
| `viewer.qml`, `activity.qml`, `store.qml` | Viewer, Activity, Apps |
| `setup.qml`, `welcome.qml`, `bootlock.qml` | the installer, the first start, the lock at boot |
| `modules/` | the parts of each surface, by area (`modules/ii/` the desktop's, `modules/settings/`, `modules/claude/`, ...) |
| `modules/common/` | what everything shares: `Appearance.qml` (palette roles, sizes), `Tacit.qml` (inks, colour by meaning, type, corners), `Directories.qml`, `widgets/` |
| `services/` | singletons for system state (audio, network, power, updates, ...) |
| `scripts/` | Python and shell helpers: colours from the wallpaper, Setup, the Apps sandbox, thumbnails, ... |
| `assets/` | wallpapers, images, and the files Setup and Apps use |
| `session/`, `bin/`, `native/` | the Hyprland session, helper commands and compiled QML modules; installed by Tacit's packages, so a change here takes effect only once the packages are rebuilt |

## Running and checking

- Try a change on a computer or VM running Tacit: DEVELOPING.md, "Try a change on Tacit". A QML file with an error is
  not loaded; Tacit keeps running the last version that worked, and `qs log -p <your copy>` shows the error.
- Check what you touched before committing: `bash -n` for shell scripts, `python3 -m py_compile` for Python, `luac -p`
  for Lua. The same checks run on every pull request.

## Rules for code

- **Colours, sizes and corners come from `Appearance` and `Tacit`.** Never write a colour value: the palette follows
  the wallpaper. Text colour is an ink (`Tacit.inkMain`, `inkSec`, `inkMeta`, `inkFaint`), never text with opacity.
- **Paths:** use `Directories` in QML and `$TACIT_SHELL` / `$TACIT_BIN` in scripts. Installed computers have no
  `~/.local/bin` helpers and no source folders; never hard-code a home directory.
- **Wayland only.** No X11 code or fallbacks.
- **Singletons load lazily.** An app that needs the palette calls `MaterialThemeLoader.reapplyTheme()` at start, as
  `tacit-settings.qml` does.
- **Line endings are LF.** A CRLF script fails to start.
- **Match the code around you:** its naming, idiom and comment density. Comments say what the code does and why, in
  plain words. Do not reformat files you are not changing.
- **Do not edit** README.md, CONTRIBUTING.md, AGENTS.md, CLAUDE.md, LICENSE, `.github/` or `docs/`: they are written
  by the publishing step and a change to them is lost.
- **Do not add a dependency** (a package, a Python module, a font) without saying so in the pull request.

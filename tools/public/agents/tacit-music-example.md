# AGENTS.md

Guidance for coding agents working in this repo: a music player made only of Tacit.Kit's parts, kept as an example to
read and build on. If you are turning it into your own app, these notes still apply: they are how any Tacit app is
built.

## Running it

`QML_IMPORT_PATH=/path/to/tacit-kit/qml qs -p shell.qml` (on Tacit, `qs -p shell.qml`). It plays the music in
`~/Music`; `MUSIC_DIR=<folder>` points it elsewhere. README.md says how to render its pages without a screen.

## Layout

| Path | What it is |
|---|---|
| `shell.qml` | the window: the rail, the page in view, the player bar |
| `*Page.qml` | one file per page (albums, artists, songs, playing, lyrics, ...) |
| `Library.qml`, `Player.qml` | the app's state: the music found on disk, what is playing |
| `tools/` | renders of every page, for checking a change |

## Rules

This app follows the kit's guide for app makers: https://github.com/ciscobugger/tacit-kit/blob/main/docs/agents.md
(also at https://design.tacitos.co/agents.md). Read it before changing anything. In short:

- Build from kit parts; choose a part by the job it does (the guide's table).
- Every colour, size, space, corner and duration comes from `Kit.tokens`; text is quieter by ink, never by opacity.
- No dialogs: ask where the person already is, offer Undo for what can be undone.
- Every pointer action has a key; lists are one Tab stop.
- Check with the kit's `tools/lint.py` and look at the app on two wallpapers (`tools/grab.sh` in the kit).
- Match the code around you: its naming, idiom and comment density.

# AGENTS.md

Guidance for coding agents working in this repo: Tacit.Kit, the QML parts Tacit's own apps are made of, and the
figures of its guide, https://design.tacitos.co. Read CONTRIBUTING.md first: it says what changes are welcome and what
needs agreement first.

**Building an app with the kit, not changing the kit?** Read `docs/agents.md` instead, or copy it into your app's repo
as its AGENTS.md.

## How changes get in

This repo is published from the one Tacit is developed in. Pull requests are read line by line and applied there with
their author kept; nothing is merged on GitHub. Keep a pull request to one fix or one agreed change, and sign off every
commit (`git commit -s`). A new part, or a change to how a part looks or behaves, needs agreement first: open an idea
issue with a picture of it on two wallpapers.

## Layout

| Path | What it is |
|---|---|
| `qml/Tacit/Kit/` | the parts, one file each; `qmldir` lists them; `Kit.qml` is the singleton (tokens, fonts, focus, motion) |
| `tokens/tokens.json` | every value the parts use: colour roles as recipes over the wallpaper's palette, sizes, spaces, corners, motion |
| `generated/` and `qml/Tacit/Kit/Live.qml`, `Defaults.qml` | written by `tools/generate.py` from the tokens; never edit them by hand |
| `docs/figures/` | the guide's figures, one QML file per page; `lib/` holds their shared helpers |
| `docs/examples/` | small apps the guide runs as they are |
| `docs/assets/` | the wallpapers, covers and pictures the figures use |
| `catalogue/` | every part in its states, rendered on two palettes |
| `tools/` | `lint.py`, `grab.sh`, `behaviour.sh`, `generate.py`, `catalogue.sh` |

## Checking a change

- `python3 tools/lint.py qml` reports nothing.
- `sh tools/behaviour.sh` ends in ALL PASS, and again with `TACIT_REDUCED_MOTION=1`.
- A token change: `python3 tools/generate.py kit`, `live` and `tables`, and commit what they write.
- A part that looks different: render its page's figures with `sh docs/render.sh <page> <out dir>` and look at dusk
  and Moss; render the catalogue with `tools/catalogue.sh <out dir>`.

## Rules for code

- **Each part's first comment is its spec:** what it is for, its properties, signals, keys, states and what a screen
  reader hears. Change the comment with the behaviour.
- **Values come from the tokens.** No colour, font size, corner or duration written by hand; a new value is a new token
  with a description of what it is for.
- **Text is quieter by ink, never by opacity.** Disabled is the faint ink.
- **No dialog part.** Tacit asks in place: a name is edited in its row, what can be undone is done and offers Undo, what
  cannot be undone is confirmed by the action itself (`confirm`). Don't add a sheet, a modal or a popup that dims.
- **Signals use one word per meaning:** `activated` does the thing, `picked` chooses one of a set, `toggled` turns
  something on or off.
- **Every pointer action has a key**, and the focus ring shows only after a key (`Kit.focusVisible`).
- **Motion goes through `Kit.ms(Kit.motion(name).ms)`**, so reduced motion stops it.
- **Wayland only.** No X11 code or fallbacks.
- **Comments say what the code does and why,** in plain British English. Match the file around you.
- **Do not edit** README.md, CONTRIBUTING.md, AGENTS.md, CLAUDE.md, LICENSE or `.github/`: the publishing step writes
  them and a change to them is lost.

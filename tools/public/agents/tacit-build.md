# AGENTS.md

Guidance for coding agents working in this repo: how Tacit is built, its Arch packages, the installer image and the
tools that test them. Read CONTRIBUTING.md first.

## How changes get in

This repo is published from the one Tacit is built from. Pull requests are read line by line and applied there with
their author kept; nothing is merged on GitHub. Signing and publishing packages is done by Tacit's maintainers only.
Keep a pull request to one fix, and sign off every commit (`git commit -s`).

## Layout

| Path | What it is |
|---|---|
| `<package>/PKGBUILD` | one directory per package: its recipe, install script and small files |
| `tacit/` | the `tacit` package: the release's version and `notes.json`, what changed in each release in plain words |
| `iso/` | the installer image |
| `tools/` | building on the build machine, the release checks, the test VM, publishing |
| `RELEASE.md` | the steps every change and every release follows |

## Rules for recipes

- A recipe names the exact commit or tag it builds. A changed package gets a new `pkgver` or `pkgrel`; never reuse one.
- Check a recipe with `bash -n PKGBUILD`, and build it with `makepkg` on a computer running Tacit before sending it.
- Release notes speak to people, not developers: no package names and no commands (RELEASE.md, "Say what the person
  sees").
- No keys, tokens or passwords in any file.
- **Do not edit** README.md, CONTRIBUTING.md, AGENTS.md, CLAUDE.md, LICENSE, `.github/` or `docs/`: they are written
  by the publishing step and a change to them is lost.

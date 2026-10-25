# How Tacit is made and released

The rules every change follows, and the steps every release takes, in order. `tools/release-check <version>` checks the
gates it can; the rest are written here so they are not skipped.

## Every change

1. **Commit in the repo the change belongs to, by path.** `git commit -- <paths>`, never `git commit -a`: other work
   lives uncommitted beside yours. Push the same day.
2. **Test it where it runs, without touching the owner's desktop.**
   - Shell QML: the live shell picks it up at once; check its log (`/run/user/$UID/quickshell/by-id/*/log.log`) for
     errors. Apps that run as their own process (Settings, Praxis, Graphis) load off-screen from a copy of the tree
     (`env -u DISPLAY QT_QPA_OFFSCREEN_NO_GLX=1 QT_QPA_PLATFORM=offscreen QT_QUICK_BACKEND=software qs -p <copy>/<app>.qml`).
   - Thyris: `tools/check-engine <groups>` (a private headless screen).
   - agent-host: `cargo test`; a test never opens anything on the desktop.
   - Scripts: `bash -n`, `python3 -m py_compile`, `luac -p`; edit a script that may be running by writing a copy and
     moving it over the original.
   - A bug: reproduce it first, then show the fix changes the result (the old code fails the same test).
3. **Works on the owner's machine is not works.** Installs have no `~/dev`, no `~/.local/bin` helpers and no hand-made
   links. Call Tacit's helpers through `$TACIT_BIN` (`Directories.tacitBin` in QML), the shell through
   `qs -p $TACIT_SHELL`, and ship every file a feature needs in a package.
4. **Say what the person sees.** Release notes, the notch and Settings speak in plain words: no package names, no
   commands.

## Version numbers

Owner, 2026-10-25: the numbers follow how a release reaches people, not how many there have been.

- **A fix between weekly releases** bumps the last number: 1.2 -> 1.2.1 -> 1.2.2. After .9 comes .10, never a rollover.
- **The weekly release** bumps the middle number: 1.2, 1.3, 1.4. It carries the release notes and the Discord post.
- **2.0** comes when its content is done (nothing broken, everything findable, one design language, Tacit's own
  foundations, Thyris complete, easy to try), whatever the middle number has reached by then. Never by count.
- The ISO keeps its dated name (2026.10.24.1).

## A release

1. **Gather.** Read Discord since the last release; every report is fixed, answered, or written down for later in
   the release's bug list.
2. **Pick the day of Arch.** `tools/arch-day` is what installs have now. A newer day is a candidate: build and test
   with `ARCH_MIRROR=https://archive.archlinux.org/repos/YYYY/MM/DD/$repo/os/$arch`. A day with another Hyprland needs
   tacit-boot and tacit-portal rebuilt on it (their plugins are built for one Hyprland and pin it), or updates refuse.
3. **Pin.** Each PKGBUILD names the pushed commit or tag it ships; a version that changed gets a new `pkgver` or
   `pkgrel` (never reuse one, even unpublished: a test computer's cache keeps the old file). `tacit/notes.json` leads
   with the release and what changed in it; `tacit` depends on the new versions it needs.
4. **Build.** `tools/cloud-packages <recipes>` on the build machine, against that day.
5. **Test in the VM like a person.** A test repo (the live `tacit.db` plus the new packages), the mirror on the day:
   Settings > Check for updates, Restart, then the version in About, "What's new", and each note in it checked one by
   one, plus a sign-in, a page in Thyris, an app from Apps, and no errors in the shell's log. Record it:
   `tools/release-check <version> --vm-passed "what was checked"`.
6. **Gate.** `tools/release-check <version>` passes.
7. **Publish.** `tools/publish <packages>`; then `tools/arch-day <day>` if the day moved; then
   `tools/publish-source <version>`.
8. **The ISO**, when Setup, the live system or the first start changed: `tools/iso`, a fresh install in the VM, upload
   under a new dated name, move the download's `LATEST`.
9. **Say it.** The site's release notes and install page; a post in Discord's #releases once the owner has read it.

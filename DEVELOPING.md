# tacit-packages

How every part of Tacit becomes an Arch package. One folder per package: its `PKGBUILD` (built from a tagged
commit of the part's own repo), install hooks and anything only the package needs. The plan and the rules are in
`~/book4-edge/tacit-packaging-plan.md`; what goes where is in `tacit-packaging-inventory.md`.

    ./build.sh tacit-cpu-policy      # one package, into out/<arch>/
    ./build.sh                       # all of them

Nothing here installs anything. Building happens in each folder's src/ and pkg/, which git ignores.

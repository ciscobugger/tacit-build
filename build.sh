#!/bin/bash
# build.sh [package ...]: builds Tacit packages into out/<arch>/ and checks each one. Installs nothing.
set -u
cd "$(dirname "$(readlink -f "$0")")"
arch=$(uname -m)
mkdir -p "out/$arch"
# The parts' repos are private: makepkg ignores the personal git config, so the GitHub login (gh) is handed to git
# for these builds only. Nothing is written into a recipe or a package.
export GIT_CONFIG_COUNT=1 GIT_CONFIG_KEY_0="credential.https://github.com.helper" GIT_CONFIG_VALUE_0="!/usr/bin/gh auth git-credential"
pkgs=("$@"); [ ${#pkgs[@]} -gt 0 ] || pkgs=($(ls -d tacit-*/ | tr -d /))
fail=0
for p in "${pkgs[@]}"; do
	echo "== $p"
	(cd "$p" && makepkg -f --cleanbuild --noconfirm --nodeps PKGDEST="$PWD/../out/$arch" >/dev/null 2>"../out/$arch/$p.log") || { echo "   build FAILED (out/$arch/$p.log)"; fail=1; continue; }
	f=$(ls -t "out/$arch/$p"-[0-9]*.pkg.tar.zst 2>/dev/null | head -1)
	# the checks every package must pass: no files in a home folder or /usr/local, nothing naming the owner's home
	bad=$(bsdtar -tf "$f" | grep -E "^(home|usr/local|root)/" || true)
	# the package's own files only: .BUILDINFO records the build folder, which is not shipped behaviour
	named=$(bsdtar -xOf "$f" --exclude '.BUILDINFO' --exclude '.PKGINFO' --exclude '.MTREE' --exclude '.INSTALL' 2>/dev/null | grep -a -c "/home/abdul" || true)
	echo "   $(basename "$f")  $(bsdtar -tf "$f" | grep -v '^\.' | grep -vc '/$') files  $( [ -z "$bad" ] && echo "places ok" || echo "BAD PLACES: $bad")  $( [ "$named" = 0 ] && echo "no home paths" || echo "NAMES /home/abdul x$named")"
done
exit $fail

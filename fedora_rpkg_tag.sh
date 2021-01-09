#!/usr/bin/env bash
#
# Parse debian/changelog and set package version same as on PopOS! and Ubuntu
# 
# ----------------------------------------------------------------------------
# 2021-02-01 Marcin Szydelski
#		init

# verification
[ -f debian/changelog ] || { echo "No debian/changelog found."; exit 1; }

# main

version_in_changelog=$(grep -E "system76-driver \([[:digit:]]+\.[[:digit:]]+\.[[:digit:]]+\)" debian/changelog | head -1)
_tmp=${version_in_changelog%%)*}
version=${_tmp##*\(}

_tmp=$(git tag --list system76-driver-"$version"-'*' | sort -r -n | head -1)
release=${_tmp##*-}

if [ "z$release" == "z" ]; then
	release=1
else
	if ! [[ "$release" =~ ^[0-9]+$ ]]; then
		echo "Release should be a number"
		exit 2
	fi
	# increment release number
	((release++))
fi

# as a workaround set static version in spec file
sed -i "s#^Version:    .*#Version:    $version#" system76-driver.spec.rpkg
sed -i "s#^Release:    .*#Release:    $release#" system76-driver.spec.rpkg
git commit -m"bump Version to: $version-$release" system76-driver.spec.rpkg
# rpkg tag
rpkg tag --version="$version"  --release="$release"
rpkg local


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
tmp=${version_in_changelog%%)*}
tmp=${tmp##*\(}
release=${tmp##*\.}
version=${tmp%%\.$release}

# rpkg tag
rpkg tag --version="$version" --release="$release"

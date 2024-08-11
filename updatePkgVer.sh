#!/bin/bash

if [ $# -ne 2 ]; then
    echo "$0 <path to project> <version>"
    exit 1
fi

PROJECT_PATH="$(realpath $1)"
NEW_VERSION="${2}"
PKGBUILD_FILE="${PROJECT_PATH}/PKGBUILD"

sed -i "s/^pkgver=.*\$/pkgver=${NEW_VERSION}/" "${PKGBUILD_FILE}"
sed -i "/^md5sums=/d" "${PKGBUILD_FILE}"

cd "${PROJECT_PATH}"
makepkg -g >> "${PKGBUILD_FILE}"
makepkg --printsrcinfo > .SRCINFO
cd -

git -C ${PROJECT_PATH} diff

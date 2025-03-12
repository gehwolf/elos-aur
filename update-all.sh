#!/bin/bash
CMD_DIR=$(realpath $(dirname $0))
BASE_DIR=${CMD_DIR%%/ci}

if [ $# -ne 3 ]; then
    echo "Usage:"
    echo "$0 <safu-version> <samconf-verison> <elos-version>"
fi

$BASE_DIR/updateAurRepos.sh

CHROOT="$BASE_DIR/chroot"
sudo rm -rf "$CHROOT"
mkdir -p "$CHROOT"
mkarchroot $CHROOT/root base-devel

$BASE_DIR/updatePkgVer.sh $BASE_DIR/safu $1
pushd safu
makechrootpkg -c -r $CHROOT
popd

$BASE_DIR/updatePkgVer.sh $BASE_DIR/samconf $2
pushd samconf
makechrootpkg -c -r $CHROOT -I ../safu/safu-$1-1-x86_64.pkg.tar.zst
popd

$BASE_DIR/updatePkgVer.sh $BASE_DIR/elos $3
pushd elos
makechrootpkg -c -r $CHROOT -I ../safu/safu-$1-1-x86_64.pkg.tar.zst -I ../samconf/samconf-$2-1-x86_64.pkg.tar.zst
popd

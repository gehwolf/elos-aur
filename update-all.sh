#!/bin/bash
CMD_DIR=$(realpath $(dirname $0))
BASE_DIR=${CMD_DIR%%/ci}

function get_latest_version {
    curl -s "https://api.github.com/repos/Elektrobit/${1}/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/'|cut -d "-" -f 2
}

LATEST_SAFU_TAG=$(get_latest_version safu)
LATEST_SAMCONF_TAG=$(get_latest_version samconf)
LATEST_ELOS_TAG=$(get_latest_version elos)
echo "safu ${LATEST_SAFU_TAG}"
echo "samconf ${LATEST_SAMCONF_TAG}"
echo "elos ${LATEST_ELOS_TAG}"

${BASE_DIR}/updateAurRepos.sh

CHROOT="${BASE_DIR}/chroot"
sudo rm -rf "${CHROOT}"
mkdir -p "${CHROOT}"
mkarchroot "${CHROOT}/root" base-devel

"${BASE_DIR}/updatePkgVer.sh" "${BASE_DIR}/safu" "${LATEST_SAFU_TAG}"
pushd safu
makechrootpkg -c -r "${CHROOT}"
popd

"${BASE_DIR}/updatePkgVer.sh" "${BASE_DIR}/samconf" "${LATEST_SAMCONF_TAG}"
pushd samconf
makechrootpkg -c -r "${CHROOT}" -I "../safu/safu-${LATEST_SAFU_TAG}-1-x86_64.pkg.tar.zst"
popd

"${BASE_DIR}/updatePkgVer.sh" "${BASE_DIR}/elos" "${LATEST_ELOS_TAG}"
pushd elos
makechrootpkg -c -r "${CHROOT}" -I "../safu/safu-${LATEST_SAFU_TAG}-1-x86_64.pkg.tar.zst" -I "../samconf/samconf-${LATEST_SAMCONF_TAG}-1-x86_64.pkg.tar.zst"
popd

#!/bin/bash

# This script is meant to make it easy to rebuild packages using the
# linux-fresh yuzu-emu container.

# Run this from within the source directory

THIS=$(readlink -e $0)
USER_ID=${1}
GROUP_ID=${2}
VERSION=5_15_2
BASE_NAME=$(readlink -e $(pwd) | sed 's/.*\///g')
ARCHIVE_NAME=${BASE_NAME}_${VERSION}.tar.xz
NUM_CORES=$(nproc)


mkdir build || true
cd build
mkdir out || true
../configure -opensource -confirm-license -prefix $(pwd)/out
make -j${NUM_CORES} NINJAJOBS=-j${NUM_CORES}
make -j${NUM_CORES} install DESTDIR=out


mkdir -pv ${BASE_NAME}/
mv -v build/out/* ${BASE_NAME}/
cp -v ${THIS} ${BASE_NAME}/

tar cv ${BASE_NAME} | xz -c > ${ARCHIVE_NAME}

if [ -e ${ARCHIVE_NAME} ]; then
    echo "hidapi package can be found at $(readlink -e ${ARCHIVE_NAME})"
fi


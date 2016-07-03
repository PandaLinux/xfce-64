#!/usr/bin/env bash

shopt -s -o pipefail
set -e 		# Exit on error

PKG_NAME="xfconf"
PKG_VERSION="4.6.2"

TARBALL="${PKG_NAME}-${PKG_VERSION}.tar.bz2"
SRC_DIR="${PKG_NAME}-${PKG_VERSION}"

function showHelp() {
    echo -e "--------------------------------------------------------------------------------------------------------------"
    echo -e "This is the library of GUI functions for XFCE."
    echo -e "--------------------------------------------------------------------------------------------------------------"
    echo -e ""
}

function prepare() {
    ln -sv /sources/${TARBALL} ${TARBALL}
}

function unpack() {
    tar xf ${TARBALL}
}

function build() {
	CC="gcc ${BUILD64}" USE_ARCH=64             \
	./configure --prefix=${XFCE_PREFIX}         \
				--libdir=${XFCE_PREFIX}/lib     &&
    make ${MAKE_PARALLEL}
}

function instal() {
	make ${MAKE_PARALLEL} install
}

function clean() {
    rm -rf ${SRC_DIR} ${TARBALL}
}

# Run the installation procedure
time { showHelp;clean;prepare;unpack;pushd ${SRC_DIR};build;instal;popd;clean; }
# Verify installation
#if [ -f /usr/sbin/xfce4-kiosk-query ]; then
#    touch ${DONE_DIR_BUILD_SYSTEM}/$(basename $(pwd))
#fi

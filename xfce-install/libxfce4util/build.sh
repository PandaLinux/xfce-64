#!/usr/bin/env bash

shopt -s -o pipefail
set -e 		# Exit on error

PKG_NAME="libxfce4util"
PKG_VERSION="4.6.2"

TARBALL="${PKG_NAME}-${PKG_VERSION}.tar.bz2"
SRC_DIR="${PKG_NAME}-${PKG_VERSION}"

function showHelp() {
    echo -e "--------------------------------------------------------------------------------------------------------------"
    echo -e "This is the basic utility library for Xfce4."
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
	CC="gcc ${BUILD64}" CXX="g++ ${BUILD64}"    \
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
if [ -f /usr/sbin/xfce4-kiosk-query ]; then
    touch ${DONE_DIR_BUILD_SYSTEM}/$(basename $(pwd))
fi

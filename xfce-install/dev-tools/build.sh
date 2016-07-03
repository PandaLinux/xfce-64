#!/usr/bin/env bash

shopt -s -o pipefail
set -e 		# Exit on error

PKG_NAME="xfce4-dev-tools"
PKG_VERSION="4.6.2"

TARBALL="${PKG_NAME}-${PKG_VERSION}.tar.bz2"
SRC_DIR="${PKG_NAME}-${PKG_VERSION}"

function showHelp() {
    echo -e "--------------------------------------------------------------------------------------------------------------"
    echo -e "Description: The Xfce development tools are a collection of tools and macros for Xfce developers and people "
    echo -e "that want to build Xfce from SVN. In addition it contains the Xfce developer's handbook."
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
	./configure --prefix=${XFCE_PREFIX} &&
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
#if [ -f /usr/lib/libacl.so ]; then
#    touch ${DONE_DIR_BUILD_SYSTEM}/$(basename $(pwd))
#fi

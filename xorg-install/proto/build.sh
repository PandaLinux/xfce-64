#!/usr/bin/env bash

shopt -s -o pipefail
set -e 		# Exit on error

function showHelp() {
    echo -e "--------------------------------------------------------------------------------------------------------------"
    echo -e "The Xorg protocol headers provide the header files required to build the system, and to allow other"
    echo -e "applications to build against the installed X Window system."
    echo -e "--------------------------------------------------------------------------------------------------------------"
    echo -e ""
}

function prepare() {
    ln -sv /sources/proto/* ./
}

function build() {
	cat /wget-xorg-proto | while read package; do
		pkgdir=$(sed -e "s/\.tar.bz2//" <<< ${package})

		echo -e "\nInstalling ${package}\n"

		tar xf ${package}
		pushd ${pkgdir}
			./configure ${XORG_CONFIG}
			make ${MAKE_PARALLEL} install
		popd
		rm -rf ${pkgdir}
	done
}

function clean() {
    rm -rf *.bz2
}

# Run the installation procedure
time { showHelp;clean;prepare;build;clean; }
# Verify installation
#if [ -f /usr/lib/libacl.so ]; then
#    touch ${DONE_DIR_BUILD_SYSTEM}/$(basename $(pwd))
#fi

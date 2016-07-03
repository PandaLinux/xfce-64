#!/usr/bin/env bash

shopt -s -o pipefail
set -e 		# Exit on error

function showHelp() {
    echo -e "--------------------------------------------------------------------------------------------------------------"
    echo -e ""
    echo -e "--------------------------------------------------------------------------------------------------------------"
    echo -e ""
}

function prepare() {
    ln -sv /sources/util/* ./
}

function build() {
	for i in *.tar.bz2; do
		tar xvf ${i};
	done

	top=${PWD}

	echo -e "\nInstalling xorg-cf-files...\n"
	cd xorg-cf-files*                               &&
	sed -i "s@/usr/X11R6@$XORG_PREFIX@" X11.tmpl    &&
	./configure ${XORG_CONFIG}                      &&
	make ${MAKE_PARALLEL}                           &&
	make ${MAKE_PARALLEL} install                   &&
	cd ${top}

	for dir in imake gccmakedep util-macros lndir makedepend; do
		cd ${dir}*                      &&
		./configure ${XORG_CONFIG}      &&
		make ${MAKE_PARALLEL}           &&
		make ${MAKE_PARALLEL} install   &&
		cd ${top};
	done
}

function clean() {
    rm -rf *.bz2 */
}

# Run the installation procedure
time { showHelp;clean;prepare;build;clean; }
# Verify installation
#if [ -f /usr/lib/libacl.so ]; then
#    touch ${DONE_DIR_BUILD_SYSTEM}/$(basename $(pwd))
#fi

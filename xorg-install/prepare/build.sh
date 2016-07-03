#!/usr/bin/env bash

shopt -s -o pipefail
set -e 		# Exit on error

function build() {
	# Set the XORG installation directory
	echo "export XORG_PREFIX=/usr" >> /etc/profile
	echo "export XORG_CONFIG=\"--prefix=${XORG_PREFIX} --sysconfdir=/etc --localstatedir=/var"\" >> /etc/profile
	echo "export ACLOCAL=\"aclocal -I ${XORG_PREFIX}/share/aclocal"\" >> /etc/profile

	cat >> /etc/ld.so.conf << EOF
# Begin Xorg addition to /etc/ld.so.conf

${XORG_PREFIX}/lib

# End Xorg addition to /etc/ld.so.conf
EOF

	source /etc/profile

}

# Run the installation procedure
time { build; }
# Verify installation
if [ -d ../xorg/util ]; then
    touch ${DONE_DIR}/$(basename $(pwd))
fi
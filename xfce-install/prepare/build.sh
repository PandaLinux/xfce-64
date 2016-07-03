#!/usr/bin/env bash

shopt -s -o pipefail
set -e 		# Exit on error

function build() {
    cat > /etc/profile.d/30-xfce.sh << "EOF"
# Begin /etc/profile.d/30-xfce.sh

export XFCE_PREFIX=/usr

export XDG_CONFIG_DIRS="${XDG_CONFIG_DIRS}${XDG_CONFIG_DIRS+:}/etc/xfce/xdg"

# End /etc/profile.d/30-xfce.sh
EOF

	source /etc/profile

}

# Run the installation procedure
time { build; }
# Verify installation
if [ -f /etc/profile.d/30-xfce.sh ]; then
    touch ${DONE_DIR}/$(basename $(pwd))
fi
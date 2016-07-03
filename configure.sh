#!/usr/bin/env bash

## This is script configures the system and download all the necessary packages required
## for compiling the system from source.

source functions.sh
source variables.sh

function configureSys() {
	# Download all
    downloadPkgs;

	# Ask user for ${INSTALL_DIR}
	echo warn "Mount point: "
	read INSTALL_DIR

    if [ ! "$(cat /proc/mounts | grep -w ${INSTALL_DIR} | cut -d' ' -f1)" ]; then
        echo empty
		echo error "Invalid installation path."
		echo error "Please read the documentation properly and fix the errors!"
		echo empty
		exit 1
	else
		# Move all the data to the ${INSTALL_DIR}/home
        sudo cp -rf ./* ${INSTALL_DIR}/home
	fi

	echo success "Your system is now configured!!"
    echo empty
}

# Configure System
configureSys;

echo success "Environment is now ready!!"
echo empty

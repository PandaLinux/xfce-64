#!/usr/bin/env bash

set -e  # Exit upon error

source variables.sh
source functions.sh

# Detect system before starting
detectSystem;

#----------------------------------------------------------------------------------------------------#
#                             C O N F I G U R E   I N S T A L L A T I O N                            #
#----------------------------------------------------------------------------------------------------#

# Display help messgae
function show_help() {
    cat << EOF
Usage: ${0##*/} [-i INSTALL_DIR] [-j CONCURRENT JOBS] [-t RUN TESTS] ...

Compile & install 64bit Panda Linux

Note: If you decide not to use any arguments, the previously set values will
be used by default.

    -h          Display this help and exit

    -j          Run concurrent jobs. Defaults to value in nproc.
                    0       - Uses all cores
                    1-      - Any number onwards 1 no. of core(s) will be used

    -t          Whether to run all the tests. Defaults to TRUE.
                    TRUE    - Run
                    FALSE   - Don't run

EOF
}

# Parse options
while getopts ":t:j:h" opt; do
    case ${opt} in

        h )
            show_help;
            exit 1
            ;;

        j )
            if [ ${OPTARG} -eq 0 ]; then
                sed -i "s#.*MAKE_PARALLEL=.*#MAKE_PARALLEL=-j$(cat /proc/cpuinfo | grep processor | wc -l)#" variables.sh
            else
                sed -i "s#.*MAKE_PARALLEL=.*#MAKE_PARALLEL=-j${OPTARG}#" variables.sh
            fi
            ;;

        t )
            if [ ${OPTARG} = TRUE ] || [ ${OPTARG} = FALSE ]; then
                sed -i "s#.*MAKE_TESTS=.*#MAKE_TESTS=${OPTARG}#" variables.sh
            else
                echo error "Invalid argument. -t only takes either 'TRUE' or 'FALSE'."
                exit 1
            fi
            ;;

        \? )
            echo error "Invalid option: -{$OPTARG}" >&2
            exit 1
            ;;

        : )
            echo error "Option -${OPTARG} requires an argument."
            exit 1
            ;;
    esac
done

source variables.sh
source /etc/profile

# Show installation configuration information to the user
echo empty
echo warn "General Installation Configuration"
echo norm "${BOLD}Run tests:${NORM}                 ${MAKE_TESTS}"
echo norm "${BOLD}No. of jobs:${NORM}               ${MAKE_PARALLEL}"
echo norm "${BOLD}Path:${NORM}                      ${PATH}"
echo empty

#----------------------------------------------------------------------------------------------------#
#                               S T A R T   I N S T A L L A T I O N                                  #
#----------------------------------------------------------------------------------------------------#

if [ ! -f /.xfce ]; then
	echo empty
	echo success "Starting installation..."
	echo empty

	# Install Xorg
	pushd ${XORG_DIR} && bash init.sh && popd
	# Install XFCE
	pushd ${XFCE_DIR} && bash init.sh && popd
fi
#!/usr/bin/env bash

# Path of current script
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

## User information
PANDA_USER="cub"
PANDA_GROUP="cub"
PANDA_HOME="den"

# Set install directory
INSTALL_DIR=/tmp/panda64
HOST_TDIR=/tools
HOST_CDIR=/cross-tools
LOGS_DIR=/logs
DONE_DIR=/done
XFCE_DIR=/xfce-install
XORG_DIR=/xorg-install

## Rest of the configurations
BUILD64="-m64"

# XFCE Version
XFCE_VERSION=4.6.2

# Set fonts for Help.
NORM=`tput sgr0`
BOLD=`tput bold`
REV=`tput smso`
RED=`tput setaf 1`
GREEN=`tput setaf 2`
YELLOW=`tput setaf 3`

MAKE_TESTS=TRUE
MAKE_PARALLEL=-j4

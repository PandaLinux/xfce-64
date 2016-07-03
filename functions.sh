#!/usr/bin/env bash

source variables.sh

# Override echo to colorize output
echo() {
    case $1 in
        success )
            command echo "${GREEN}$2${NORM}";;

        warn )
            command echo "${YELLOW}$2${NORM}";;

        error )
            command echo "${RED}$2${NORM}";;

        bold )
            command echo "${BOLD}$2${NORM}";;

        rev )
            command echo "${REV}$2${NORM}";;

        norm )
            command echo "$2";;

        empty )
            command echo "";;
    esac
}

# Override `pushd` to dump data onto `/dev/null`
pushd() {
    command pushd "$@" > /dev/null
}

# Override `popd` to dump data onto `/dev/null`
popd() {
    command popd "$@" > /dev/null
}

# Verify command ended successfully
function checkCommand() {
	if [ $? -eq 0 ]; then
		echo success "Finished!"
	else
		[ $# -gt 0 ] && echo error "$@" || echo error "Failed!"
        exit 1
	fi
}

# Override cp
cp() {
    command cp "$@"
    checkCommand;
}

function detectSystem() {
	# Detect distribution name
    if [[ `which lsb_release 2>&1 /dev/null` ]]; then
        # lsb_release is available
        DISTRIB_NAME=`lsb_release -is`
    else
        # lsb_release is not available
        cat /etc/os-release | grep -w ID | cut -d= -f2
    fi

	echo empty
    echo warn "Detected system: ${BOLD}${DISTRIB_NAME}${NORM}"

    shopt -s nocasematch
    # Let's do the installation of missing packages
    if [ ${DISTRIB_NAME} != "panda" ]; then
        # Unsupported system
        echo norm "${REV}Panda Linux cannot be compiled from your system.${NORM}"
        exit 0
    fi

    shopt -u nocasematch
}

function downloadPkgs() {
	URL_XFCE="http://archive.xfce.org/xfce/${XFCE_VERSION}/src/"

	# Verify that all the packages have been downloaded
	if md5sum --status -c ${DIR}/md5sums; then
        echo success "Packages have already been downloaded. Skipping this step!"
	else
        # Download the required packages
        echo warn "Downloading XFCE packages..."
		wget -k -l 0 ${URL_XFCE} -O ${DIR}/index.html --quiet --show-progress ; cat ${DIR}/index.html   |
		grep -o "${URL_XFCE}[^\"]*.bz2"                                                                 |
		uniq -c                                                                                         |
		sort                                                                                            |
		xargs wget -P ${DIR}/sources --quiet --show-progress --continue

		# Download the XORG files
		echo empty
		echo warn "Downloading XORG Protocols..."
		wget -B http://xorg.freedesktop.org/releases/individual/proto/  \
			 -i ${DIR}/wget-xorg-proto                                  \
			 -P ${DIR}/sources/proto                                    \
			 --no-check-certificate                                     \
			 --show-progress                                            \
			 --continue                                                 \
			 --quiet

		echo empty
		echo warn "Downloading XORG utilities..."
		wget -B http://xorg.freedesktop.org/releases/individual/util/   \
			 -i ${DIR}/wget-xorg-util                                   \
			 -P ${DIR}/sources/util                                     \
			 --no-check-certificate                                     \
			 --show-progress                                            \
			 --continue                                                 \
			 --quiet

		echo empty
		echo warn "Downloading XORG libraries..."
		wget -B http://xorg.freedesktop.org/releases/individual/lib/    \
			 -i ${DIR}/wget-xorg-libraries                              \
			 -P ${DIR}/sources/libraries                                \
			 --no-check-certificate                                     \
			 --show-progress                                            \
			 --continue                                                 \
			 --quiet

		echo empty
		echo warn "Downloading XORG applications..."
		wget -B http://xorg.freedesktop.org/releases/individual/app/    \
			 -i ${DIR}/wget-xorg-app                                    \
			 -P ${DIR}/sources/app                                      \
			 --no-check-certificate                                     \
			 --show-progress                                            \
			 --continue                                                 \
			 --quiet

		echo empty
		echo warn "Downloading XORG fonts..."
		wget -B http://xorg.freedesktop.org/releases/individual/font/   \
			 -i ${DIR}/wget-xorg-font                                   \
			 -P ${DIR}/sources/font                                     \
			 --no-check-certificate                                     \
			 --show-progress                                            \
			 --continue                                                 \
			 --quiet

		echo empty
		echo warn "Downloading XORG drivers..."
		wget -B http://xorg.freedesktop.org/archive/individual/driver/  \
			 -i ${DIR}/wget-xorg-drivers                                \
			 -P ${DIR}/sources/drivers                                  \
			 --no-check-certificate                                     \
			 --show-progress                                            \
			 --continue                                                 \
			 --quiet

		echo empty
		echo warn "Downloading XORG dependencies..."
		wget -i ${DIR}/wget-xorg-rest   \
			 -P ${DIR}/sources          \
			 --continue                 \
			 --no-check-certificate     \
			 --show-progress            \
			 --quiet

		# Update the md5sums file
		find ${DIR}/sources -type f -exec md5sum {} \; | sort -k 2 > ${DIR}/md5sums

		# Remove the index.html file
		rm ${DIR}/index.html
	fi
}

# Ask for confirmation to begin
function askConfirm() {
    read -p "${YELLOW}Continue? [Y/n]:${NORM} " -n 1 -r
    echo empty
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 0
    fi
    echo empty
}

# Creates backup
function createBackup() {
    if [ ${DO_BACKUP} = TRUE ]; then
        echo empty
        echo warn "Removing old backups..."
        requireRoot rm -f ${DIR}/backup.tar.bz2
        requireRoot rm -f ${INSTALL_DIR}/backup.tar.bz2

        echo empty
        echo warn "Creating new backup..."
        requireRoot tar -jcpPf ${DIR}/backup.tar.bz2 ${INSTALL_DIR}
        checkCommand;

        requireRoot chown -R `whoami` ${DIR}/backup.tar.bz2
    fi
}

#!/usr/bin/env bash

shopt -s -o pipefail
set -e 		# Exit on error

source ${HOME}/variables.sh
source ${HOME}/functions.sh

detectSystem;

echo warn "Installing XFCE packages..."

# Create log directory
install -d ${LOGS_DIR}
# Create DONE directory
install -d ${DONE_DIR}

if [ -f ./done ]; then
    _list=(prepare dev-tools libxfce4util xfconf libxfcegui4)

    for i in ${_list[@]}; do
        case $i in
            * )
				pushd ${i}
                    if [ -f ${DONE_DIR}/${i} ]; then
                        echo success "${i} --> Already Built"
                    else
                        echo empty
                        echo warn "Building ---> ${i}"
                        bash build.sh |& tee ${LOGS_DIR}/${i}.log

                        if [ -f ${DONE_DIR}/${i} ]; then
                            echo success "Building ---> ${i} completed"
                        else
                            echo error "Building ---> ${i} failed"
                            echo error "See ${LOGS_DIR}/${i}.log for more details..."
                            exit 1
                        fi

                        echo empty
                    fi
                popd;;
        esac
    done
fi

echo empty
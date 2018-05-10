#!/bin/zsh
#
# System agnostic installer aliasing
#
# Assumes if you are on a mac, brew is used
# Suse = zypper
# ubuntu/debian = apt
# Redhat = yum
#

source "${0:h}/core.sh"

case $OS in
    'mac')
        alias in='brew install'
        alias up='brew upgrade'
        ;;
    'linux')
        if [[ "$DIST" == "ubuntu" ]]; then
            alias in="sudo -E apt-get install"
            alias up="sudo -E apt-get upgrade"
        elif [[ "$DIST" == "suse" ]]; then
            alias in="sudo -E zypper in"
            alias up="sudo -E zypper up"
        elif [[ "$DIST" == "redhat" ]]; then
            alias in="sudo -E yum install"
            alias up="sudo -E yup upgrade"
        fi
        ;;
    *) ;;
esac

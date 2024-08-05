#!/bin/zsh
lowercase(){
    echo "$1" | sed "y/ABCDEFGHIJKLMNOPQRSTUVWXYZ/abcdefghijklmnopqrstuvwxyz/"
}

####################################################################
# Get System Info
####################################################################
shootProfile(){
    OS=`lowercase \`uname\``
    KERNEL=`uname -r`
    MACH=`uname -m`

    if [ "${OS}" = "windowsnt" ]; then
        OS=windows
    elif [ "${OS}" = "darwin" ]; then
        OS=mac
        DIST="apple"
        DistroBasedOn='RedHat'
        REV=`sw_vers | grep ProductVersion | awk '{ print $2 }'`
    else
        OS=`uname`
        if [ "${OS}" = "SunOS" ] ; then
            OS=Solaris
            ARCH=`uname -p`
            OSSTR="${OS} ${REV}(${ARCH} `uname -v`)"
        elif [ "${OS}" = "AIX" ] ; then
            OSSTR="${OS} `oslevel` (`oslevel -r`)"
        elif [ "${OS}" = "Linux" ] ; then
            if [ -f /etc/redhat-release ] ; then
                DistroBasedOn='RedHat'
                DIST=`cat /etc/redhat-release |sed s/\ release.*//`
                PSEUDONAME=`cat /etc/redhat-release | sed s/.*\(// | sed s/\)//`
                REV=`cat /etc/redhat-release | sed s/.*release\ // | sed s/\ .*//`
            elif [ -f /etc/SuSE-release ] ; then
                DIST='suse'
                DistroBasedOn='SuSe'
                PSEUDONAME=`lsb_release -a | grep Description | cut -f2-`
                REV=`lsb_release -a | grep Release | cut -f2-`
            elif [ -f /etc/mandrake-release ] ; then
                DistroBasedOn='Mandrake'
                PSEUDONAME=`cat /etc/mandrake-release | sed s/.*\(// | sed s/\)//`
                REV=`cat /etc/mandrake-release | sed s/.*release\ // | sed s/\ .*//`
            elif [ -f /etc/debian_version ] ; then
                DistroBasedOn='Debian'
                if [ -f /etc/lsb-release ] ; then
                        DIST=`cat /etc/lsb-release | grep '^DISTRIB_ID' | awk -F=  '{ print $2 }'`
                            PSEUDONAME=`cat /etc/lsb-release | grep '^DISTRIB_CODENAME' | awk -F=  '{ print $2 }'`
                            REV=`cat /etc/lsb-release | grep '^DISTRIB_RELEASE' | awk -F=  '{ print $2 }'`
                        fi
            fi
            if [ -f /etc/UnitedLinux-release ] ; then
                DIST="${DIST}[`cat /etc/UnitedLinux-release | tr "\n" ' ' | sed s/VERSION.*//`]"
            fi
            OS=`lowercase $OS`
            DIST=`lowercase $DIST`
            DistroBasedOn=`lowercase $DistroBasedOn`
            readonly OS
            readonly DIST
            readonly DistroBasedOn
            readonly PSEUDONAME
            readonly REV
            readonly KERNEL
            readonly MACH
        fi

    fi
}
shootProfile
#echo "OS: $OS"
#echo "DIST: $DIST"
#echo "PSUEDONAME: $PSUEDONAME"
#echo "REV: $REV"
#echo "DistroBasedOn: $DistroBasedOn"
#echo "KERNEL: $KERNEL"
#echo "MACH: $MACH"
#echo "========"

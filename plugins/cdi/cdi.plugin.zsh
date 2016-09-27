# vim: set sw=4 expandtab:
#
# Licence: GPL
# Created: 2016-09-27 14:41:53+02:00
# Main authors:
#     - Jérôme Pouiller <jezz@sysmic.org>
#
# "Change Directory Interactive"
#
# Allow to change directory by editing current working directory path.
#

cdi() {
    local _TMP=$PWD
    vared _TMP
    cd $_TMP
}




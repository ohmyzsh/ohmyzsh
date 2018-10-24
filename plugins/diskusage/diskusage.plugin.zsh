#!/usr/bin/env zsh
# @author Markus Ritzmann <markus@snowflakeops.ch>

# ===================
# Settings
# ===================

local DISKUSAGE_PREFIX='disk:'
local DISKUSAGE_SUFFIX='%%'

local DISKUSAGE_WARNING='80'  # in percentage
local DISKUSAGE_CRITICAL='90' # in percentage

local DISKUSAGE_COLOR_WARNING='\033[33m'  # yellow
local DISKUSAGE_COLOR_CRITICAL='\033[31m' # red

# ===================
# Used disk space
# ===================

function DISKUSAGE() {

	# check working directory permissions
	[[ -r . ]] || exit 0

	# get diskusage
	DISKUSAGE_CAPACITY=$(df -P . | sed 1d | awk '{print $5}' | tr -d '%')

	# determines color depending on DISKUSAGE_CAPACITY
	if [ "${DISKUSAGE_CAPACITY}" -ge "${DISKUSAGE_WARNING}" ] ; then DISKUSAGE_COLOR=${DISKUSAGE_COLOR_WARNING} ; fi
	if [ "${DISKUSAGE_CAPACITY}" -ge "${DISKUSAGE_CRITICAL}" ] ; then DISKUSAGE_COLOR=${DISKUSAGE_COLOR_CRITICAL} ; fi

	# output
	echo "${DISKUSAGE_COLOR}${DISKUSAGE_PREFIX}${DISKUSAGE_CAPACITY}${DISKUSAGE_SUFFIX}"
}

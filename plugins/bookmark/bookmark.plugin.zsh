#############################################################
# Author: Amila Perera
# File Name: bookmark.plugin.zsh
#
# This plugin can primarily be used to add bookmarks which
# makes it easier to navigate through the file system.
# The added bookmarks can also be listed, deleted, renamed and modified.
#
# After enabling this plugin, 'bm' command is created.
# Use 'bm' to create bookmarks in the file system, manage those
# bookmarks and navigate through the file system using the created bookmarks.
# To invoke the basic usage of the command, type the following in command line.
# % bm -h
#
# NOTE: zsh completion works with 'bm' command
#############################################################

_bm_usage()
{
	printf "Usage: bm: bm [option] [bookmarkname]\nType bm -h for help\n" 1>&2
}

_bm_help()
{
	cat <<- HELPMSG
			bm: Folder BookMark Utility
			Usage: bm [OPTION] [BOOKMARK] [DIRECTORY]

			bm BOOKMARK                     Jumps to the directory given by BOOKMARK
			Options:
			  -c BOOKMARK [DIRECTORY]        Creates a bookmark.
			                                 If no directory is given the current directory is bookmarked
			  -d BOOKMARK1 BOOKMARK2...      Delete bookmarks
			  -r BOOKMARK_OLD BOOKMARK_NEW   Renames a bookmark
			  -m BOOKMARK DIRECTORY          Modifies directory for a given bookmark
			  -l                             Lists bookmarks(same operation is performed if bm is executed with no option)
			  -h                             Displays this help
	HELPMSG
}

_check_if_bm_exists()
{
	local bmexist= name="${1}" bmfile="${2}"
	[ ! -f "${bmfile}" ] && return 0		# returns false since bookmark file doesn't exist

	# check if book mark exists in particular bookmark file
	bmexist=$(awk -F':' '$1 == "'${name}'" { print $1 }' ${bmfile})
	[ ! -z $bmexist ] && { return 1; } || { return 0; }
}

_bm_gotobm()
{
	local name=${1} bmfile=${2} dirname=

	_check_if_bm_exists $name $bmfile
	(($? == 0)) && { printf "bm: bookmark doesn't exist\n" 1>&2; return 1; }

	dirname=$(awk -F':' '$1 == "'${name}'" { print $2 }' ${bmfile})

	[ ! -d "${dirname}" ] && { printf "bm: directory doesn't exist\n" 1>&2; return 1; }

	cd "${dirname}"
	return 0
}

_bm_list()
{
	if [ -f "${1}" ]; then
		sed 's/:/\t/' ${1} | sort | \
		{
		while read rbm rdir
		do
			[ -d "$rdir" ] && printf "%-20s ---> %s\n" "$rbm" "$rdir" \
						   || printf "%-20s ---> %s <====> [%s]\n" "$rbm" "$rdir" "doesn't exist"
		done
		}
	else
		printf "No bookmarks are entered\n" 1>&2 && _bm_usage
	fi
}

##################################################################
##bm()
##folder bookmark function
##################################################################
bm()
{
	local bm= dir= file="${HOME}/.bmarks"

	case $1 in
	-c)
		shift
		[ $# -gt 2 -o $# -eq 0 ] && { _bm_usage; return 101; }
		bm=$1
		if [ -z "${2}" ]; then
			dir="${PWD}"
		else
			[[ "${2}" =~ ^~ || "${2}" =~ ^\/[^\/]* ]] && dir="${2}" || dir="$PWD/${2}"
		fi
		_check_if_bm_exists $bm $file
		[ $? -eq 1 ] && { printf "bm: bookmark name already exists\n" 1>&2; return 102; }
		dir=$(echo "${dir}/" | sed 's/\/\/*$/\//')	# appending a / at the end of directory whether user supplies one or not
		[ ! -d "${dir}" ] \
			&& printf "bm: directory doesn't exist\n" 1>&2 \
			|| printf "%s:%s\n" "$bm" "$dir" >> $file
		;;

	-d)
		shift
		for bm in "$@"; do
			_check_if_bm_exists $bm $file
			if [ $? -eq 1 ]; then
				local tempfile="${file}"".tmp"
				sed "/$bm:/d" $file > $tempfile; mv -f $tempfile $file
			else
				printf "bm: bookmark doesn't exist : %s\n" "$bm"
			fi
		done
		;;

	-r)
		shift
		[ $# -ne 2 ] && { _bm_usage; return 101; }
		local oldbm=${1} newbm=${2}
		_check_if_bm_exists $oldbm $file
		if [ $? -eq 1 ]; then
			local tempfile="${file}"".tmp"
			sed "s/$oldbm:/$newbm:/" $file > $tempfile; mv -f $tempfile $file
		else
			printf "bm: bookmark doesn't exist : %s\n" "$oldbm"
		fi
		;;

	-m)
		shift
		[ $# -gt 2 -o $# -eq 0 ] && { _bm_usage; return 101; }
		bm=$1
		if [ -z "${2}" ]; then
			dir="${PWD}"
		else
			[[ "${2}" =~ ^~ || "${2}" =~ ^\/[^\/]* ]] && dir="${2}" || dir="$PWD/${2}"
		fi
		_check_if_bm_exists $bm $file
		if [ $? -eq 1 ]; then
			[ ! -d "${dir}" ] && { printf "bm: directory doesn't exists\n" 1>&2; return 101; }
			dir=$(echo "${dir}/" | sed 's/\/\/*$/\//')	# appending a / at the end of directory whether user supplies one or not
			local tempfile="${file}"".tmp"
				sed "/$bm:/d" $file > $tempfile
				printf "%s:%s\n" "$bm" "$dir" >> $tempfile
				mv -f $tempfile $file
		else
			printf "bm: bookmark doesn't exist : %s\n" "$bm"
		fi
		;;

	-l)
		shift
		_bm_list "$file"
		;;

	-h)
		_bm_help ;;

	*)
		if [ $# -eq 0 ]; then
			_bm_list "$file"
		elif [ $# -gt 1 ]; then
			_bm_usage; return 1;
		else
			_bm_gotobm $1 $file
			[ $? -ne 0 ] && { _bm_usage; return 1; };
			return 0
		fi
		;;
	esac

	return $?
}

_bm()
{
	typeset -A opt_args

	local file="$HOME/.bmarks"
	local curcontext="$curcontext" state line

	_arguments -C \
		'1: :->cmds'\
		'2:: :->args' && ret=0

	case $state in
		cmds)
			if [ -f $file ]; then
				_values=( $(awk -F':' '{ print $1 }' $file) \
						'-c:create' \
						'-d:delete' \
						'-r:rename' \
						'-m:move' \
						'-l:list' \
						'-h:help')
			else
				_values=('-c:create' \
						'-d:delete' \
						'-r:rename' \
						'-m:move' \
						'-l:list' \
						'-h:help')
			fi
			_describe -t _values 'vaules' _values && ret=0
			;;
		args)
			case $line[1] in
				-m|-d)
					_bms=(`awk -F':' '{ print $1 }' $file`)
					_values 'bms' $_bms
					ret=0
					;;
			esac
	esac
	return ret
}

compdef _bm bm B

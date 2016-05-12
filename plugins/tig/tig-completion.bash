##
# bash completion support for tig
#
# Copyright (C) 2007-2010 Jonas fonseca
# Copyright (C) 2006,2007 Shawn Pearce
#
# Based git's git-completion.sh: http://repo.or.cz/w/git/fastimport.git
#
# The contained completion routines provide support for completing:
#
#    *) local and remote branch names
#    *) local and remote tag names
#    *) tig 'subcommands'
#    *) tree paths within 'ref:path/to/file' expressions
#
# To use these routines:
#
#    1) Copy this file to somewhere (e.g. ~/.tig-completion.sh).
#    2) Added the following line to your .bashrc:
#        source ~/.tig-completion.sh
#
#    3) You may want to make sure the git executable is available
#       in your PATH before this script is sourced, as some caching
#       is performed while the script loads.  If git isn't found
#       at source time then all lookups will be done on demand,
#       which may be slightly slower.
#

__tigdir ()
{
	if [ -z "$1" ]; then
		if [ -n "$__git_dir" ]; then
			echo "$__git_dir"
		elif [ -d .git ]; then
			echo .git
		else
			git rev-parse --git-dir 2>/dev/null
		fi
	elif [ -d "$1/.git" ]; then
		echo "$1/.git"
	else
		echo "$1"
	fi
}

_tigcomp ()
{
	local all c s=$'\n' IFS=' '$'\t'$'\n'
	local cur="${COMP_WORDS[COMP_CWORD]}"
	if [ $# -gt 2 ]; then
		cur="$3"
	fi
	for c in $1; do
		case "$c$4" in
		--*=*) all="$all$c$4$s" ;;
		*.)    all="$all$c$4$s" ;;
		*)     all="$all$c$4 $s" ;;
		esac
	done
	IFS=$s
	COMPREPLY=($(compgen -P "$2" -W "$all" -- "$cur"))
	return
}

__tig_refs ()
{
	local cmd i is_hash=y dir="$(__tigdir "$1")"
	if [ -d "$dir" ]; then
		for i in HEAD FETCH_HEAD ORIG_HEAD MERGE_HEAD; do
			if [ -e "$dir/$i" ]; then echo $i; fi
		done
		for i in $(git --git-dir="$dir" \
			for-each-ref --format='%(refname)' \
			refs/tags refs/heads refs/remotes); do
			case "$i" in
				refs/tags/*)    echo "${i#refs/tags/}" ;;
				refs/heads/*)   echo "${i#refs/heads/}" ;;
				refs/remotes/*) echo "${i#refs/remotes/}" ;;
				*)              echo "$i" ;;
			esac
		done
		return
	fi
	for i in $(git-ls-remote "$dir" 2>/dev/null); do
		case "$is_hash,$i" in
		y,*) is_hash=n ;;
		n,*^{}) is_hash=y ;;
		n,refs/tags/*) is_hash=y; echo "${i#refs/tags/}" ;;
		n,refs/heads/*) is_hash=y; echo "${i#refs/heads/}" ;;
		n,refs/remotes/*) is_hash=y; echo "${i#refs/remotes/}" ;;
		n,*) is_hash=y; echo "$i" ;;
		esac
	done
}

__tig_complete_file ()
{
	local pfx ls ref cur="${COMP_WORDS[COMP_CWORD]}"
	case "$cur" in
	?*:*)
		ref="${cur%%:*}"
		cur="${cur#*:}"
		case "$cur" in
		?*/*)
			pfx="${cur%/*}"
			cur="${cur##*/}"
			ls="$ref:$pfx"
			pfx="$pfx/"
			;;
		*)
			ls="$ref"
			;;
	    esac
		COMPREPLY=($(compgen -P "$pfx" \
			-W "$(git --git-dir="$(__tigdir)" ls-tree "$ls" \
				| sed '/^100... blob /s,^.*	,,
				       /^040000 tree /{
				           s,^.*	,,
				           s,$,/,
				       }
				       s/^.*	//')" \
			-- "$cur"))
		;;
	*)
		_tigcomp "$(__tig_refs)"
		;;
	esac
}

__tig_complete_revlist ()
{
	local pfx cur="${COMP_WORDS[COMP_CWORD]}"
	case "$cur" in
	*...*)
		pfx="${cur%...*}..."
		cur="${cur#*...}"
		_tigcomp "$(__tig_refs)" "$pfx" "$cur"
		;;
	*..*)
		pfx="${cur%..*}.."
		cur="${cur#*..}"
		_tigcomp "$(__tig_refs)" "$pfx" "$cur"
		;;
	*.)
		_tigcomp "$cur."
		;;
	*)
		_tigcomp "$(__tig_refs)"
		;;
	esac
}

_tig_options ()
{
	local cur="${COMP_WORDS[COMP_CWORD]}"
	case "$cur" in
	--pretty=*)
		_tigcomp "
			oneline short medium full fuller email raw
			" "" "${cur##--pretty=}"
		return
		;;
	--*)
		_tigcomp "
			--max-count= --max-age= --since= --after=
			--min-age= --before= --until=
			--root --not --topo-order --date-order
			--no-merges
			--abbrev-commit --abbrev=
			--relative-date
			--author= --committer= --grep=
			--all-match
			--pretty= --name-status --name-only
			--not --all
			--help --version
			"
		return
		;;
	-*)
		_tigcomp "-v -h"
		return
		;;
	esac
	__tig_complete_revlist
}

_tig_blame ()
{
	local reply="" ref=HEAD cur="${COMP_WORDS[COMP_CWORD]}" p=""
	local pfx=$(git rev-parse --show-prefix 2>/dev/null)

	if test "$COMP_CWORD" -lt 3; then
		_tigcomp "$(__tig_refs)"
	else
		ref="${COMP_WORDS[2]}"
	fi

	case "$cur" in
		*/)	p=${cur%/} ;;
		*/*)	p=${cur%/*} ;;
		*)	p= ;;
	esac

	i=${#COMPREPLY[@]}
	local IFS=$'\n'
	for c in $(git --git-dir="$(__tigdir)" ls-tree "$ref:$pfx$p" 2>/dev/null |
		sed -n '/^100... blob /{
			s,^.*	,,
			s,$, ,
			p
		}
		/^040000 tree /{
			s,^.*	,,
			s,$,/,
			p
		}')
	do
		c="${p:+$p/}$c"
		if [[ "$c" == "$cur"* ]]; then
			COMPREPLY[i++]=$c
		fi
	done
}

_tig_show ()
{
	local cur="${COMP_WORDS[COMP_CWORD]}"
	case "$cur" in
	--pretty=*)
		_tigcomp "
			oneline short medium full fuller email raw
			" "" "${cur##--pretty=}"
		return
		;;
	--*)
		_tigcomp "--pretty="
		return
		;;
	esac
	__tig_complete_file
}

_tig ()
{
	local i c=1 command __tig_dir

	while [ $c -lt $COMP_CWORD ]; do
		i="${COMP_WORDS[c]}"
		case "$i" in
		--) command="log"; break;;
		-*) ;;
		*) command="$i"; break ;;
		esac
		c=$((++c))
	done

	if [ $c -eq $COMP_CWORD -a -z "$command" ]; then
		case "${COMP_WORDS[COMP_CWORD]}" in
		--*=*) COMPREPLY=() ;;
		-*)   _tig_options ;;
		*)    _tigcomp "blame status show log stash grep $(__tig_refs)" ;;
		esac
		return
	fi

	case "$command" in
	blame)  _tig_blame ;;
	show)   _tig_show ;;
	status) ;;
	*)	_tigcomp "
			$(__tig_complete_file)
			$(__tig_refs)
		" ;;
	esac
}

# Detect if current shell is ZSH, and if so, load this file in bash
# compatibility mode.
if [ -n "$ZSH_VERSION" ]; then
	autoload bashcompinit
	bashcompinit
fi

complete -o default -o nospace -F _tig tig

# The following are necessary only for Cygwin, and only are needed
# when the user has tab-completed the executable name and consequently
# included the '.exe' suffix.
if [ Cygwin = "$(uname -o 2>/dev/null)" ]; then
complete -o default -o nospace -F _tig tig.exe
fi

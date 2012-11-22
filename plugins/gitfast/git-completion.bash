#!bash
#
# bash/zsh completion support for core Git.
#
# Copyright (C) 2006,2007 Shawn O. Pearce <spearce@spearce.org>
# Conceptually based on gitcompletion (http://gitweb.hawaga.org.uk/).
# Distributed under the GNU General Public License, version 2.0.
#
# The contained completion routines provide support for completing:
#
#    *) local and remote branch names
#    *) local and remote tag names
#    *) .git/remotes file names
#    *) git 'subcommands'
#    *) tree paths within 'ref:path/to/file' expressions
#    *) common --long-options
#
# To use these routines:
#
#    1) Copy this file to somewhere (e.g. ~/.git-completion.sh).
#    2) Add the following line to your .bashrc/.zshrc:
#        source ~/.git-completion.sh
#    3) Consider changing your PS1 to also show the current branch,
#       see git-prompt.sh for details.

if [[ -n ${ZSH_VERSION-} ]]; then
	autoload -U +X bashcompinit && bashcompinit
fi

case "$COMP_WORDBREAKS" in
*:*) : great ;;
*)   COMP_WORDBREAKS="$COMP_WORDBREAKS:"
esac

# __gitdir accepts 0 or 1 arguments (i.e., location)
# returns location of .git repo
__gitdir ()
{
	# Note: this function is duplicated in git-prompt.sh
	# When updating it, make sure you update the other one to match.
	if [ -z "${1-}" ]; then
		if [ -n "${__git_dir-}" ]; then
			echo "$__git_dir"
		elif [ -n "${GIT_DIR-}" ]; then
			test -d "${GIT_DIR-}" || return 1
			echo "$GIT_DIR"
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

__gitcomp_1 ()
{
	local c IFS=$' \t\n'
	for c in $1; do
		c="$c$2"
		case $c in
		--*=*|*.) ;;
		*) c="$c " ;;
		esac
		printf '%s\n' "$c"
	done
}

# The following function is based on code from:
#
#   bash_completion - programmable completion functions for bash 3.2+
#
#   Copyright © 2006-2008, Ian Macdonald <ian@caliban.org>
#             © 2009-2010, Bash Completion Maintainers
#                     <bash-completion-devel@lists.alioth.debian.org>
#
#   This program is free software; you can redistribute it and/or modify
#   it under the terms of the GNU General Public License as published by
#   the Free Software Foundation; either version 2, or (at your option)
#   any later version.
#
#   This program is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU General Public License for more details.
#
#   You should have received a copy of the GNU General Public License
#   along with this program; if not, write to the Free Software Foundation,
#   Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
#
#   The latest version of this software can be obtained here:
#
#   http://bash-completion.alioth.debian.org/
#
#   RELEASE: 2.x

# This function can be used to access a tokenized list of words
# on the command line:
#
#	__git_reassemble_comp_words_by_ref '=:'
#	if test "${words_[cword_-1]}" = -w
#	then
#		...
#	fi
#
# The argument should be a collection of characters from the list of
# word completion separators (COMP_WORDBREAKS) to treat as ordinary
# characters.
#
# This is roughly equivalent to going back in time and setting
# COMP_WORDBREAKS to exclude those characters.  The intent is to
# make option types like --date=<type> and <rev>:<path> easy to
# recognize by treating each shell word as a single token.
#
# It is best not to set COMP_WORDBREAKS directly because the value is
# shared with other completion scripts.  By the time the completion
# function gets called, COMP_WORDS has already been populated so local
# changes to COMP_WORDBREAKS have no effect.
#
# Output: words_, cword_, cur_.

__git_reassemble_comp_words_by_ref()
{
	local exclude i j first
	# Which word separators to exclude?
	exclude="${1//[^$COMP_WORDBREAKS]}"
	cword_=$COMP_CWORD
	if [ -z "$exclude" ]; then
		words_=("${COMP_WORDS[@]}")
		return
	fi
	# List of word completion separators has shrunk;
	# re-assemble words to complete.
	for ((i=0, j=0; i < ${#COMP_WORDS[@]}; i++, j++)); do
		# Append each nonempty word consisting of just
		# word separator characters to the current word.
		first=t
		while
			[ $i -gt 0 ] &&
			[ -n "${COMP_WORDS[$i]}" ] &&
			# word consists of excluded word separators
			[ "${COMP_WORDS[$i]//[^$exclude]}" = "${COMP_WORDS[$i]}" ]
		do
			# Attach to the previous token,
			# unless the previous token is the command name.
			if [ $j -ge 2 ] && [ -n "$first" ]; then
				((j--))
			fi
			first=
			words_[$j]=${words_[j]}${COMP_WORDS[i]}
			if [ $i = $COMP_CWORD ]; then
				cword_=$j
			fi
			if (($i < ${#COMP_WORDS[@]} - 1)); then
				((i++))
			else
				# Done.
				return
			fi
		done
		words_[$j]=${words_[j]}${COMP_WORDS[i]}
		if [ $i = $COMP_CWORD ]; then
			cword_=$j
		fi
	done
}

if ! type _get_comp_words_by_ref >/dev/null 2>&1; then
if [[ -z ${ZSH_VERSION:+set} ]]; then
_get_comp_words_by_ref ()
{
	local exclude cur_ words_ cword_
	if [ "$1" = "-n" ]; then
		exclude=$2
		shift 2
	fi
	__git_reassemble_comp_words_by_ref "$exclude"
	cur_=${words_[cword_]}
	while [ $# -gt 0 ]; do
		case "$1" in
		cur)
			cur=$cur_
			;;
		prev)
			prev=${words_[$cword_-1]}
			;;
		words)
			words=("${words_[@]}")
			;;
		cword)
			cword=$cword_
			;;
		esac
		shift
	done
}
else
_get_comp_words_by_ref ()
{
	while [ $# -gt 0 ]; do
		case "$1" in
		cur)
			cur=${COMP_WORDS[COMP_CWORD]}
			;;
		prev)
			prev=${COMP_WORDS[COMP_CWORD-1]}
			;;
		words)
			words=("${COMP_WORDS[@]}")
			;;
		cword)
			cword=$COMP_CWORD
			;;
		-n)
			# assume COMP_WORDBREAKS is already set sanely
			shift
			;;
		esac
		shift
	done
}
fi
fi

# Generates completion reply with compgen, appending a space to possible
# completion words, if necessary.
# It accepts 1 to 4 arguments:
# 1: List of possible completion words.
# 2: A prefix to be added to each possible completion word (optional).
# 3: Generate possible completion matches for this word (optional).
# 4: A suffix to be appended to each possible completion word (optional).
__gitcomp ()
{
	local cur_="${3-$cur}"

	case "$cur_" in
	--*=)
		COMPREPLY=()
		;;
	*)
		local IFS=$'\n'
		COMPREPLY=($(compgen -P "${2-}" \
			-W "$(__gitcomp_1 "${1-}" "${4-}")" \
			-- "$cur_"))
		;;
	esac
}

# Generates completion reply with compgen from newline-separated possible
# completion words by appending a space to all of them.
# It accepts 1 to 4 arguments:
# 1: List of possible completion words, separated by a single newline.
# 2: A prefix to be added to each possible completion word (optional).
# 3: Generate possible completion matches for this word (optional).
# 4: A suffix to be appended to each possible completion word instead of
#    the default space (optional).  If specified but empty, nothing is
#    appended.
__gitcomp_nl ()
{
	local IFS=$'\n'
	COMPREPLY=($(compgen -P "${2-}" -S "${4- }" -W "$1" -- "${3-$cur}"))
}

__git_heads ()
{
	local dir="$(__gitdir)"
	if [ -d "$dir" ]; then
		git --git-dir="$dir" for-each-ref --format='%(refname:short)' \
			refs/heads
		return
	fi
}

__git_tags ()
{
	local dir="$(__gitdir)"
	if [ -d "$dir" ]; then
		git --git-dir="$dir" for-each-ref --format='%(refname:short)' \
			refs/tags
		return
	fi
}

# __git_refs accepts 0, 1 (to pass to __gitdir), or 2 arguments
# presence of 2nd argument means use the guess heuristic employed
# by checkout for tracking branches
__git_refs ()
{
	local i hash dir="$(__gitdir "${1-}")" track="${2-}"
	local format refs
	if [ -d "$dir" ]; then
		case "$cur" in
		refs|refs/*)
			format="refname"
			refs="${cur%/*}"
			track=""
			;;
		*)
			for i in HEAD FETCH_HEAD ORIG_HEAD MERGE_HEAD; do
				if [ -e "$dir/$i" ]; then echo $i; fi
			done
			format="refname:short"
			refs="refs/tags refs/heads refs/remotes"
			;;
		esac
		git --git-dir="$dir" for-each-ref --format="%($format)" \
			$refs
		if [ -n "$track" ]; then
			# employ the heuristic used by git checkout
			# Try to find a remote branch that matches the completion word
			# but only output if the branch name is unique
			local ref entry
			git --git-dir="$dir" for-each-ref --shell --format="ref=%(refname:short)" \
				"refs/remotes/" | \
			while read -r entry; do
				eval "$entry"
				ref="${ref#*/}"
				if [[ "$ref" == "$cur"* ]]; then
					echo "$ref"
				fi
			done | uniq -u
		fi
		return
	fi
	case "$cur" in
	refs|refs/*)
		git ls-remote "$dir" "$cur*" 2>/dev/null | \
		while read -r hash i; do
			case "$i" in
			*^{}) ;;
			*) echo "$i" ;;
			esac
		done
		;;
	*)
		git ls-remote "$dir" HEAD ORIG_HEAD 'refs/tags/*' 'refs/heads/*' 'refs/remotes/*' 2>/dev/null | \
		while read -r hash i; do
			case "$i" in
			*^{}) ;;
			refs/*) echo "${i#refs/*/}" ;;
			*) echo "$i" ;;
			esac
		done
		;;
	esac
}

# __git_refs2 requires 1 argument (to pass to __git_refs)
__git_refs2 ()
{
	local i
	for i in $(__git_refs "$1"); do
		echo "$i:$i"
	done
}

# __git_refs_remotes requires 1 argument (to pass to ls-remote)
__git_refs_remotes ()
{
	local i hash
	git ls-remote "$1" 'refs/heads/*' 2>/dev/null | \
	while read -r hash i; do
		echo "$i:refs/remotes/$1/${i#refs/heads/}"
	done
}

__git_remotes ()
{
	local i IFS=$'\n' d="$(__gitdir)"
	test -d "$d/remotes" && ls -1 "$d/remotes"
	for i in $(git --git-dir="$d" config --get-regexp 'remote\..*\.url' 2>/dev/null); do
		i="${i#remote.}"
		echo "${i/.url*/}"
	done
}

__git_list_merge_strategies ()
{
	git merge -s help 2>&1 |
	sed -n -e '/[Aa]vailable strategies are: /,/^$/{
		s/\.$//
		s/.*://
		s/^[ 	]*//
		s/[ 	]*$//
		p
	}'
}

__git_merge_strategies=
# 'git merge -s help' (and thus detection of the merge strategy
# list) fails, unfortunately, if run outside of any git working
# tree.  __git_merge_strategies is set to the empty string in
# that case, and the detection will be repeated the next time it
# is needed.
__git_compute_merge_strategies ()
{
	test -n "$__git_merge_strategies" ||
	__git_merge_strategies=$(__git_list_merge_strategies)
}

__git_complete_revlist_file ()
{
	local pfx ls ref cur_="$cur"
	case "$cur_" in
	*..?*:*)
		return
		;;
	?*:*)
		ref="${cur_%%:*}"
		cur_="${cur_#*:}"
		case "$cur_" in
		?*/*)
			pfx="${cur_%/*}"
			cur_="${cur_##*/}"
			ls="$ref:$pfx"
			pfx="$pfx/"
			;;
		*)
			ls="$ref"
			;;
		esac

		case "$COMP_WORDBREAKS" in
		*:*) : great ;;
		*)   pfx="$ref:$pfx" ;;
		esac

		__gitcomp_nl "$(git --git-dir="$(__gitdir)" ls-tree "$ls" \
				| sed '/^100... blob /{
				           s,^.*	,,
				           s,$, ,
				       }
				       /^120000 blob /{
				           s,^.*	,,
				           s,$, ,
				       }
				       /^040000 tree /{
				           s,^.*	,,
				           s,$,/,
				       }
				       s/^.*	//')" \
			"$pfx" "$cur_" ""
		;;
	*...*)
		pfx="${cur_%...*}..."
		cur_="${cur_#*...}"
		__gitcomp_nl "$(__git_refs)" "$pfx" "$cur_"
		;;
	*..*)
		pfx="${cur_%..*}.."
		cur_="${cur_#*..}"
		__gitcomp_nl "$(__git_refs)" "$pfx" "$cur_"
		;;
	*)
		__gitcomp_nl "$(__git_refs)"
		;;
	esac
}


__git_complete_file ()
{
	__git_complete_revlist_file
}

__git_complete_revlist ()
{
	__git_complete_revlist_file
}

__git_complete_remote_or_refspec ()
{
	local cur_="$cur" cmd="${words[1]}"
	local i c=2 remote="" pfx="" lhs=1 no_complete_refspec=0
	if [ "$cmd" = "remote" ]; then
		((c++))
	fi
	while [ $c -lt $cword ]; do
		i="${words[c]}"
		case "$i" in
		--mirror) [ "$cmd" = "push" ] && no_complete_refspec=1 ;;
		--all)
			case "$cmd" in
			push) no_complete_refspec=1 ;;
			fetch)
				COMPREPLY=()
				return
				;;
			*) ;;
			esac
			;;
		-*) ;;
		*) remote="$i"; break ;;
		esac
		((c++))
	done
	if [ -z "$remote" ]; then
		__gitcomp_nl "$(__git_remotes)"
		return
	fi
	if [ $no_complete_refspec = 1 ]; then
		COMPREPLY=()
		return
	fi
	[ "$remote" = "." ] && remote=
	case "$cur_" in
	*:*)
		case "$COMP_WORDBREAKS" in
		*:*) : great ;;
		*)   pfx="${cur_%%:*}:" ;;
		esac
		cur_="${cur_#*:}"
		lhs=0
		;;
	+*)
		pfx="+"
		cur_="${cur_#+}"
		;;
	esac
	case "$cmd" in
	fetch)
		if [ $lhs = 1 ]; then
			__gitcomp_nl "$(__git_refs2 "$remote")" "$pfx" "$cur_"
		else
			__gitcomp_nl "$(__git_refs)" "$pfx" "$cur_"
		fi
		;;
	pull|remote)
		if [ $lhs = 1 ]; then
			__gitcomp_nl "$(__git_refs "$remote")" "$pfx" "$cur_"
		else
			__gitcomp_nl "$(__git_refs)" "$pfx" "$cur_"
		fi
		;;
	push)
		if [ $lhs = 1 ]; then
			__gitcomp_nl "$(__git_refs)" "$pfx" "$cur_"
		else
			__gitcomp_nl "$(__git_refs "$remote")" "$pfx" "$cur_"
		fi
		;;
	esac
}

__git_complete_strategy ()
{
	__git_compute_merge_strategies
	case "$prev" in
	-s|--strategy)
		__gitcomp "$__git_merge_strategies"
		return 0
	esac
	case "$cur" in
	--strategy=*)
		__gitcomp "$__git_merge_strategies" "" "${cur##--strategy=}"
		return 0
		;;
	esac
	return 1
}

__git_list_all_commands ()
{
	local i IFS=" "$'\n'
	for i in $(git help -a|egrep '^  [a-zA-Z0-9]')
	do
		case $i in
		*--*)             : helper pattern;;
		*) echo $i;;
		esac
	done
}

__git_all_commands=
__git_compute_all_commands ()
{
	test -n "$__git_all_commands" ||
	__git_all_commands=$(__git_list_all_commands)
}

__git_list_porcelain_commands ()
{
	local i IFS=" "$'\n'
	__git_compute_all_commands
	for i in "help" $__git_all_commands
	do
		case $i in
		*--*)             : helper pattern;;
		applymbox)        : ask gittus;;
		applypatch)       : ask gittus;;
		archimport)       : import;;
		cat-file)         : plumbing;;
		check-attr)       : plumbing;;
		check-ref-format) : plumbing;;
		checkout-index)   : plumbing;;
		commit-tree)      : plumbing;;
		count-objects)    : infrequent;;
		credential-cache) : credentials helper;;
		credential-store) : credentials helper;;
		cvsexportcommit)  : export;;
		cvsimport)        : import;;
		cvsserver)        : daemon;;
		daemon)           : daemon;;
		diff-files)       : plumbing;;
		diff-index)       : plumbing;;
		diff-tree)        : plumbing;;
		fast-import)      : import;;
		fast-export)      : export;;
		fsck-objects)     : plumbing;;
		fetch-pack)       : plumbing;;
		fmt-merge-msg)    : plumbing;;
		for-each-ref)     : plumbing;;
		hash-object)      : plumbing;;
		http-*)           : transport;;
		index-pack)       : plumbing;;
		init-db)          : deprecated;;
		local-fetch)      : plumbing;;
		lost-found)       : infrequent;;
		ls-files)         : plumbing;;
		ls-remote)        : plumbing;;
		ls-tree)          : plumbing;;
		mailinfo)         : plumbing;;
		mailsplit)        : plumbing;;
		merge-*)          : plumbing;;
		mktree)           : plumbing;;
		mktag)            : plumbing;;
		pack-objects)     : plumbing;;
		pack-redundant)   : plumbing;;
		pack-refs)        : plumbing;;
		parse-remote)     : plumbing;;
		patch-id)         : plumbing;;
		peek-remote)      : plumbing;;
		prune)            : plumbing;;
		prune-packed)     : plumbing;;
		quiltimport)      : import;;
		read-tree)        : plumbing;;
		receive-pack)     : plumbing;;
		remote-*)         : transport;;
		repo-config)      : deprecated;;
		rerere)           : plumbing;;
		rev-list)         : plumbing;;
		rev-parse)        : plumbing;;
		runstatus)        : plumbing;;
		sh-setup)         : internal;;
		shell)            : daemon;;
		show-ref)         : plumbing;;
		send-pack)        : plumbing;;
		show-index)       : plumbing;;
		ssh-*)            : transport;;
		stripspace)       : plumbing;;
		symbolic-ref)     : plumbing;;
		tar-tree)         : deprecated;;
		unpack-file)      : plumbing;;
		unpack-objects)   : plumbing;;
		update-index)     : plumbing;;
		update-ref)       : plumbing;;
		update-server-info) : daemon;;
		upload-archive)   : plumbing;;
		upload-pack)      : plumbing;;
		write-tree)       : plumbing;;
		var)              : infrequent;;
		verify-pack)      : infrequent;;
		verify-tag)       : plumbing;;
		*) echo $i;;
		esac
	done
}

__git_porcelain_commands=
__git_compute_porcelain_commands ()
{
	__git_compute_all_commands
	test -n "$__git_porcelain_commands" ||
	__git_porcelain_commands=$(__git_list_porcelain_commands)
}

__git_pretty_aliases ()
{
	local i IFS=$'\n'
	for i in $(git --git-dir="$(__gitdir)" config --get-regexp "pretty\..*" 2>/dev/null); do
		case "$i" in
		pretty.*)
			i="${i#pretty.}"
			echo "${i/ */}"
			;;
		esac
	done
}

__git_aliases ()
{
	local i IFS=$'\n'
	for i in $(git --git-dir="$(__gitdir)" config --get-regexp "alias\..*" 2>/dev/null); do
		case "$i" in
		alias.*)
			i="${i#alias.}"
			echo "${i/ */}"
			;;
		esac
	done
}

# __git_aliased_command requires 1 argument
__git_aliased_command ()
{
	local word cmdline=$(git --git-dir="$(__gitdir)" \
		config --get "alias.$1")
	for word in $cmdline; do
		case "$word" in
		\!gitk|gitk)
			echo "gitk"
			return
			;;
		\!*)	: shell command alias ;;
		-*)	: option ;;
		*=*)	: setting env ;;
		git)	: git itself ;;
		*)
			echo "$word"
			return
		esac
	done
}

# __git_find_on_cmdline requires 1 argument
__git_find_on_cmdline ()
{
	local word subcommand c=1
	while [ $c -lt $cword ]; do
		word="${words[c]}"
		for subcommand in $1; do
			if [ "$subcommand" = "$word" ]; then
				echo "$subcommand"
				return
			fi
		done
		((c++))
	done
}

__git_has_doubledash ()
{
	local c=1
	while [ $c -lt $cword ]; do
		if [ "--" = "${words[c]}" ]; then
			return 0
		fi
		((c++))
	done
	return 1
}

__git_whitespacelist="nowarn warn error error-all fix"

_git_am ()
{
	local dir="$(__gitdir)"
	if [ -d "$dir"/rebase-apply ]; then
		__gitcomp "--skip --continue --resolved --abort"
		return
	fi
	case "$cur" in
	--whitespace=*)
		__gitcomp "$__git_whitespacelist" "" "${cur##--whitespace=}"
		return
		;;
	--*)
		__gitcomp "
			--3way --committer-date-is-author-date --ignore-date
			--ignore-whitespace --ignore-space-change
			--interactive --keep --no-utf8 --signoff --utf8
			--whitespace= --scissors
			"
		return
	esac
	COMPREPLY=()
}

_git_apply ()
{
	case "$cur" in
	--whitespace=*)
		__gitcomp "$__git_whitespacelist" "" "${cur##--whitespace=}"
		return
		;;
	--*)
		__gitcomp "
			--stat --numstat --summary --check --index
			--cached --index-info --reverse --reject --unidiff-zero
			--apply --no-add --exclude=
			--ignore-whitespace --ignore-space-change
			--whitespace= --inaccurate-eof --verbose
			"
		return
	esac
	COMPREPLY=()
}

_git_add ()
{
	__git_has_doubledash && return

	case "$cur" in
	--*)
		__gitcomp "
			--interactive --refresh --patch --update --dry-run
			--ignore-errors --intent-to-add
			"
		return
	esac
	COMPREPLY=()
}

_git_archive ()
{
	case "$cur" in
	--format=*)
		__gitcomp "$(git archive --list)" "" "${cur##--format=}"
		return
		;;
	--remote=*)
		__gitcomp_nl "$(__git_remotes)" "" "${cur##--remote=}"
		return
		;;
	--*)
		__gitcomp "
			--format= --list --verbose
			--prefix= --remote= --exec=
			"
		return
		;;
	esac
	__git_complete_file
}

_git_bisect ()
{
	__git_has_doubledash && return

	local subcommands="start bad good skip reset visualize replay log run"
	local subcommand="$(__git_find_on_cmdline "$subcommands")"
	if [ -z "$subcommand" ]; then
		if [ -f "$(__gitdir)"/BISECT_START ]; then
			__gitcomp "$subcommands"
		else
			__gitcomp "replay start"
		fi
		return
	fi

	case "$subcommand" in
	bad|good|reset|skip|start)
		__gitcomp_nl "$(__git_refs)"
		;;
	*)
		COMPREPLY=()
		;;
	esac
}

_git_branch ()
{
	local i c=1 only_local_ref="n" has_r="n"

	while [ $c -lt $cword ]; do
		i="${words[c]}"
		case "$i" in
		-d|-m)	only_local_ref="y" ;;
		-r)	has_r="y" ;;
		esac
		((c++))
	done

	case "$cur" in
	--set-upstream-to=*)
		__gitcomp "$(__git_refs)" "" "${cur##--set-upstream-to=}"
		;;
	--*)
		__gitcomp "
			--color --no-color --verbose --abbrev= --no-abbrev
			--track --no-track --contains --merged --no-merged
			--set-upstream-to= --edit-description --list
			--unset-upstream
			"
		;;
	*)
		if [ $only_local_ref = "y" -a $has_r = "n" ]; then
			__gitcomp_nl "$(__git_heads)"
		else
			__gitcomp_nl "$(__git_refs)"
		fi
		;;
	esac
}

_git_bundle ()
{
	local cmd="${words[2]}"
	case "$cword" in
	2)
		__gitcomp "create list-heads verify unbundle"
		;;
	3)
		# looking for a file
		;;
	*)
		case "$cmd" in
			create)
				__git_complete_revlist
			;;
		esac
		;;
	esac
}

_git_checkout ()
{
	__git_has_doubledash && return

	case "$cur" in
	--conflict=*)
		__gitcomp "diff3 merge" "" "${cur##--conflict=}"
		;;
	--*)
		__gitcomp "
			--quiet --ours --theirs --track --no-track --merge
			--conflict= --orphan --patch
			"
		;;
	*)
		# check if --track, --no-track, or --no-guess was specified
		# if so, disable DWIM mode
		local flags="--track --no-track --no-guess" track=1
		if [ -n "$(__git_find_on_cmdline "$flags")" ]; then
			track=''
		fi
		__gitcomp_nl "$(__git_refs '' $track)"
		;;
	esac
}

_git_cherry ()
{
	__gitcomp "$(__git_refs)"
}

_git_cherry_pick ()
{
	case "$cur" in
	--*)
		__gitcomp "--edit --no-commit"
		;;
	*)
		__gitcomp_nl "$(__git_refs)"
		;;
	esac
}

_git_clean ()
{
	__git_has_doubledash && return

	case "$cur" in
	--*)
		__gitcomp "--dry-run --quiet"
		return
		;;
	esac
	COMPREPLY=()
}

_git_clone ()
{
	case "$cur" in
	--*)
		__gitcomp "
			--local
			--no-hardlinks
			--shared
			--reference
			--quiet
			--no-checkout
			--bare
			--mirror
			--origin
			--upload-pack
			--template=
			--depth
			"
		return
		;;
	esac
	COMPREPLY=()
}

_git_commit ()
{
	__git_has_doubledash && return

	case "$cur" in
	--cleanup=*)
		__gitcomp "default strip verbatim whitespace
			" "" "${cur##--cleanup=}"
		return
		;;
	--reuse-message=*|--reedit-message=*|\
	--fixup=*|--squash=*)
		__gitcomp_nl "$(__git_refs)" "" "${cur#*=}"
		return
		;;
	--untracked-files=*)
		__gitcomp "all no normal" "" "${cur##--untracked-files=}"
		return
		;;
	--*)
		__gitcomp "
			--all --author= --signoff --verify --no-verify
			--edit --no-edit
			--amend --include --only --interactive
			--dry-run --reuse-message= --reedit-message=
			--reset-author --file= --message= --template=
			--cleanup= --untracked-files --untracked-files=
			--verbose --quiet --fixup= --squash=
			"
		return
	esac
	COMPREPLY=()
}

_git_describe ()
{
	case "$cur" in
	--*)
		__gitcomp "
			--all --tags --contains --abbrev= --candidates=
			--exact-match --debug --long --match --always
			"
		return
	esac
	__gitcomp_nl "$(__git_refs)"
}

__git_diff_common_options="--stat --numstat --shortstat --summary
			--patch-with-stat --name-only --name-status --color
			--no-color --color-words --no-renames --check
			--full-index --binary --abbrev --diff-filter=
			--find-copies-harder
			--text --ignore-space-at-eol --ignore-space-change
			--ignore-all-space --exit-code --quiet --ext-diff
			--no-ext-diff
			--no-prefix --src-prefix= --dst-prefix=
			--inter-hunk-context=
			--patience
			--raw
			--dirstat --dirstat= --dirstat-by-file
			--dirstat-by-file= --cumulative
"

_git_diff ()
{
	__git_has_doubledash && return

	case "$cur" in
	--*)
		__gitcomp "--cached --staged --pickaxe-all --pickaxe-regex
			--base --ours --theirs --no-index
			$__git_diff_common_options
			"
		return
		;;
	esac
	__git_complete_revlist_file
}

__git_mergetools_common="diffuse ecmerge emerge kdiff3 meld opendiff
			tkdiff vimdiff gvimdiff xxdiff araxis p4merge bc3 codecompare
"

_git_difftool ()
{
	__git_has_doubledash && return

	case "$cur" in
	--tool=*)
		__gitcomp "$__git_mergetools_common kompare" "" "${cur##--tool=}"
		return
		;;
	--*)
		__gitcomp "--cached --staged --pickaxe-all --pickaxe-regex
			--base --ours --theirs
			--no-renames --diff-filter= --find-copies-harder
			--relative --ignore-submodules
			--tool="
		return
		;;
	esac
	__git_complete_file
}

__git_fetch_options="
	--quiet --verbose --append --upload-pack --force --keep --depth=
	--tags --no-tags --all --prune --dry-run
"

_git_fetch ()
{
	case "$cur" in
	--*)
		__gitcomp "$__git_fetch_options"
		return
		;;
	esac
	__git_complete_remote_or_refspec
}

_git_format_patch ()
{
	case "$cur" in
	--thread=*)
		__gitcomp "
			deep shallow
			" "" "${cur##--thread=}"
		return
		;;
	--*)
		__gitcomp "
			--stdout --attach --no-attach --thread --thread=
			--output-directory
			--numbered --start-number
			--numbered-files
			--keep-subject
			--signoff --signature --no-signature
			--in-reply-to= --cc=
			--full-index --binary
			--not --all
			--cover-letter
			--no-prefix --src-prefix= --dst-prefix=
			--inline --suffix= --ignore-if-in-upstream
			--subject-prefix=
			"
		return
		;;
	esac
	__git_complete_revlist
}

_git_fsck ()
{
	case "$cur" in
	--*)
		__gitcomp "
			--tags --root --unreachable --cache --no-reflogs --full
			--strict --verbose --lost-found
			"
		return
		;;
	esac
	COMPREPLY=()
}

_git_gc ()
{
	case "$cur" in
	--*)
		__gitcomp "--prune --aggressive"
		return
		;;
	esac
	COMPREPLY=()
}

_git_gitk ()
{
	_gitk
}

__git_match_ctag() {
	awk "/^${1////\\/}/ { print \$1 }" "$2"
}

_git_grep ()
{
	__git_has_doubledash && return

	case "$cur" in
	--*)
		__gitcomp "
			--cached
			--text --ignore-case --word-regexp --invert-match
			--full-name --line-number
			--extended-regexp --basic-regexp --fixed-strings
			--perl-regexp
			--files-with-matches --name-only
			--files-without-match
			--max-depth
			--count
			--and --or --not --all-match
			"
		return
		;;
	esac

	case "$cword,$prev" in
	2,*|*,-*)
		if test -r tags; then
			__gitcomp_nl "$(__git_match_ctag "$cur" tags)"
			return
		fi
		;;
	esac

	__gitcomp_nl "$(__git_refs)"
}

_git_help ()
{
	case "$cur" in
	--*)
		__gitcomp "--all --info --man --web"
		return
		;;
	esac
	__git_compute_all_commands
	__gitcomp "$__git_all_commands $(__git_aliases)
		attributes cli core-tutorial cvs-migration
		diffcore gitk glossary hooks ignore modules
		namespaces repository-layout tutorial tutorial-2
		workflows
		"
}

_git_init ()
{
	case "$cur" in
	--shared=*)
		__gitcomp "
			false true umask group all world everybody
			" "" "${cur##--shared=}"
		return
		;;
	--*)
		__gitcomp "--quiet --bare --template= --shared --shared="
		return
		;;
	esac
	COMPREPLY=()
}

_git_ls_files ()
{
	__git_has_doubledash && return

	case "$cur" in
	--*)
		__gitcomp "--cached --deleted --modified --others --ignored
			--stage --directory --no-empty-directory --unmerged
			--killed --exclude= --exclude-from=
			--exclude-per-directory= --exclude-standard
			--error-unmatch --with-tree= --full-name
			--abbrev --ignored --exclude-per-directory
			"
		return
		;;
	esac
	COMPREPLY=()
}

_git_ls_remote ()
{
	__gitcomp_nl "$(__git_remotes)"
}

_git_ls_tree ()
{
	__git_complete_file
}

# Options that go well for log, shortlog and gitk
__git_log_common_options="
	--not --all
	--branches --tags --remotes
	--first-parent --merges --no-merges
	--max-count=
	--max-age= --since= --after=
	--min-age= --until= --before=
	--min-parents= --max-parents=
	--no-min-parents --no-max-parents
"
# Options that go well for log and gitk (not shortlog)
__git_log_gitk_options="
	--dense --sparse --full-history
	--simplify-merges --simplify-by-decoration
	--left-right --notes --no-notes
"
# Options that go well for log and shortlog (not gitk)
__git_log_shortlog_options="
	--author= --committer= --grep=
	--all-match
"

__git_log_pretty_formats="oneline short medium full fuller email raw format:"
__git_log_date_formats="relative iso8601 rfc2822 short local default raw"

_git_log ()
{
	__git_has_doubledash && return

	local g="$(git rev-parse --git-dir 2>/dev/null)"
	local merge=""
	if [ -f "$g/MERGE_HEAD" ]; then
		merge="--merge"
	fi
	case "$cur" in
	--pretty=*|--format=*)
		__gitcomp "$__git_log_pretty_formats $(__git_pretty_aliases)
			" "" "${cur#*=}"
		return
		;;
	--date=*)
		__gitcomp "$__git_log_date_formats" "" "${cur##--date=}"
		return
		;;
	--decorate=*)
		__gitcomp "long short" "" "${cur##--decorate=}"
		return
		;;
	--*)
		__gitcomp "
			$__git_log_common_options
			$__git_log_shortlog_options
			$__git_log_gitk_options
			--root --topo-order --date-order --reverse
			--follow --full-diff
			--abbrev-commit --abbrev=
			--relative-date --date=
			--pretty= --format= --oneline
			--cherry-pick
			--graph
			--decorate --decorate=
			--walk-reflogs
			--parents --children
			$merge
			$__git_diff_common_options
			--pickaxe-all --pickaxe-regex
			"
		return
		;;
	esac
	__git_complete_revlist
}

__git_merge_options="
	--no-commit --no-stat --log --no-log --squash --strategy
	--commit --stat --no-squash --ff --no-ff --ff-only --edit --no-edit
"

_git_merge ()
{
	__git_complete_strategy && return

	case "$cur" in
	--*)
		__gitcomp "$__git_merge_options"
		return
	esac
	__gitcomp_nl "$(__git_refs)"
}

_git_mergetool ()
{
	case "$cur" in
	--tool=*)
		__gitcomp "$__git_mergetools_common tortoisemerge" "" "${cur##--tool=}"
		return
		;;
	--*)
		__gitcomp "--tool="
		return
		;;
	esac
	COMPREPLY=()
}

_git_merge_base ()
{
	__gitcomp_nl "$(__git_refs)"
}

_git_mv ()
{
	case "$cur" in
	--*)
		__gitcomp "--dry-run"
		return
		;;
	esac
	COMPREPLY=()
}

_git_name_rev ()
{
	__gitcomp "--tags --all --stdin"
}

_git_notes ()
{
	local subcommands='add append copy edit list prune remove show'
	local subcommand="$(__git_find_on_cmdline "$subcommands")"

	case "$subcommand,$cur" in
	,--*)
		__gitcomp '--ref'
		;;
	,*)
		case "$prev" in
		--ref)
			__gitcomp_nl "$(__git_refs)"
			;;
		*)
			__gitcomp "$subcommands --ref"
			;;
		esac
		;;
	add,--reuse-message=*|append,--reuse-message=*|\
	add,--reedit-message=*|append,--reedit-message=*)
		__gitcomp_nl "$(__git_refs)" "" "${cur#*=}"
		;;
	add,--*|append,--*)
		__gitcomp '--file= --message= --reedit-message=
				--reuse-message='
		;;
	copy,--*)
		__gitcomp '--stdin'
		;;
	prune,--*)
		__gitcomp '--dry-run --verbose'
		;;
	prune,*)
		;;
	*)
		case "$prev" in
		-m|-F)
			;;
		*)
			__gitcomp_nl "$(__git_refs)"
			;;
		esac
		;;
	esac
}

_git_pull ()
{
	__git_complete_strategy && return

	case "$cur" in
	--*)
		__gitcomp "
			--rebase --no-rebase
			$__git_merge_options
			$__git_fetch_options
		"
		return
		;;
	esac
	__git_complete_remote_or_refspec
}

_git_push ()
{
	case "$prev" in
	--repo)
		__gitcomp_nl "$(__git_remotes)"
		return
	esac
	case "$cur" in
	--repo=*)
		__gitcomp_nl "$(__git_remotes)" "" "${cur##--repo=}"
		return
		;;
	--*)
		__gitcomp "
			--all --mirror --tags --dry-run --force --verbose
			--receive-pack= --repo= --set-upstream
		"
		return
		;;
	esac
	__git_complete_remote_or_refspec
}

_git_rebase ()
{
	local dir="$(__gitdir)"
	if [ -d "$dir"/rebase-apply ] || [ -d "$dir"/rebase-merge ]; then
		__gitcomp "--continue --skip --abort"
		return
	fi
	__git_complete_strategy && return
	case "$cur" in
	--whitespace=*)
		__gitcomp "$__git_whitespacelist" "" "${cur##--whitespace=}"
		return
		;;
	--*)
		__gitcomp "
			--onto --merge --strategy --interactive
			--preserve-merges --stat --no-stat
			--committer-date-is-author-date --ignore-date
			--ignore-whitespace --whitespace=
			--autosquash
			"

		return
	esac
	__gitcomp_nl "$(__git_refs)"
}

_git_reflog ()
{
	local subcommands="show delete expire"
	local subcommand="$(__git_find_on_cmdline "$subcommands")"

	if [ -z "$subcommand" ]; then
		__gitcomp "$subcommands"
	else
		__gitcomp_nl "$(__git_refs)"
	fi
}

__git_send_email_confirm_options="always never auto cc compose"
__git_send_email_suppresscc_options="author self cc bodycc sob cccmd body all"

_git_send_email ()
{
	case "$cur" in
	--confirm=*)
		__gitcomp "
			$__git_send_email_confirm_options
			" "" "${cur##--confirm=}"
		return
		;;
	--suppress-cc=*)
		__gitcomp "
			$__git_send_email_suppresscc_options
			" "" "${cur##--suppress-cc=}"

		return
		;;
	--smtp-encryption=*)
		__gitcomp "ssl tls" "" "${cur##--smtp-encryption=}"
		return
		;;
	--*)
		__gitcomp "--annotate --bcc --cc --cc-cmd --chain-reply-to
			--compose --confirm= --dry-run --envelope-sender
			--from --identity
			--in-reply-to --no-chain-reply-to --no-signed-off-by-cc
			--no-suppress-from --no-thread --quiet
			--signed-off-by-cc --smtp-pass --smtp-server
			--smtp-server-port --smtp-encryption= --smtp-user
			--subject --suppress-cc= --suppress-from --thread --to
			--validate --no-validate"
		return
		;;
	esac
	COMPREPLY=()
}

_git_stage ()
{
	_git_add
}

__git_config_get_set_variables ()
{
	local prevword word config_file= c=$cword
	while [ $c -gt 1 ]; do
		word="${words[c]}"
		case "$word" in
		--global|--system|--file=*)
			config_file="$word"
			break
			;;
		-f|--file)
			config_file="$word $prevword"
			break
			;;
		esac
		prevword=$word
		c=$((--c))
	done

	git --git-dir="$(__gitdir)" config $config_file --list 2>/dev/null |
	while read -r line
	do
		case "$line" in
		*.*=*)
			echo "${line/=*/}"
			;;
		esac
	done
}

_git_config ()
{
	case "$prev" in
	branch.*.remote)
		__gitcomp_nl "$(__git_remotes)"
		return
		;;
	branch.*.merge)
		__gitcomp_nl "$(__git_refs)"
		return
		;;
	remote.*.fetch)
		local remote="${prev#remote.}"
		remote="${remote%.fetch}"
		if [ -z "$cur" ]; then
			COMPREPLY=("refs/heads/")
			return
		fi
		__gitcomp_nl "$(__git_refs_remotes "$remote")"
		return
		;;
	remote.*.push)
		local remote="${prev#remote.}"
		remote="${remote%.push}"
		__gitcomp_nl "$(git --git-dir="$(__gitdir)" \
			for-each-ref --format='%(refname):%(refname)' \
			refs/heads)"
		return
		;;
	pull.twohead|pull.octopus)
		__git_compute_merge_strategies
		__gitcomp "$__git_merge_strategies"
		return
		;;
	color.branch|color.diff|color.interactive|\
	color.showbranch|color.status|color.ui)
		__gitcomp "always never auto"
		return
		;;
	color.pager)
		__gitcomp "false true"
		return
		;;
	color.*.*)
		__gitcomp "
			normal black red green yellow blue magenta cyan white
			bold dim ul blink reverse
			"
		return
		;;
	help.format)
		__gitcomp "man info web html"
		return
		;;
	log.date)
		__gitcomp "$__git_log_date_formats"
		return
		;;
	sendemail.aliasesfiletype)
		__gitcomp "mutt mailrc pine elm gnus"
		return
		;;
	sendemail.confirm)
		__gitcomp "$__git_send_email_confirm_options"
		return
		;;
	sendemail.suppresscc)
		__gitcomp "$__git_send_email_suppresscc_options"
		return
		;;
	--get|--get-all|--unset|--unset-all)
		__gitcomp_nl "$(__git_config_get_set_variables)"
		return
		;;
	*.*)
		COMPREPLY=()
		return
		;;
	esac
	case "$cur" in
	--*)
		__gitcomp "
			--global --system --file=
			--list --replace-all
			--get --get-all --get-regexp
			--add --unset --unset-all
			--remove-section --rename-section
			"
		return
		;;
	branch.*.*)
		local pfx="${cur%.*}." cur_="${cur##*.}"
		__gitcomp "remote merge mergeoptions rebase" "$pfx" "$cur_"
		return
		;;
	branch.*)
		local pfx="${cur%.*}." cur_="${cur#*.}"
		__gitcomp_nl "$(__git_heads)" "$pfx" "$cur_" "."
		return
		;;
	guitool.*.*)
		local pfx="${cur%.*}." cur_="${cur##*.}"
		__gitcomp "
			argprompt cmd confirm needsfile noconsole norescan
			prompt revprompt revunmerged title
			" "$pfx" "$cur_"
		return
		;;
	difftool.*.*)
		local pfx="${cur%.*}." cur_="${cur##*.}"
		__gitcomp "cmd path" "$pfx" "$cur_"
		return
		;;
	man.*.*)
		local pfx="${cur%.*}." cur_="${cur##*.}"
		__gitcomp "cmd path" "$pfx" "$cur_"
		return
		;;
	mergetool.*.*)
		local pfx="${cur%.*}." cur_="${cur##*.}"
		__gitcomp "cmd path trustExitCode" "$pfx" "$cur_"
		return
		;;
	pager.*)
		local pfx="${cur%.*}." cur_="${cur#*.}"
		__git_compute_all_commands
		__gitcomp_nl "$__git_all_commands" "$pfx" "$cur_"
		return
		;;
	remote.*.*)
		local pfx="${cur%.*}." cur_="${cur##*.}"
		__gitcomp "
			url proxy fetch push mirror skipDefaultUpdate
			receivepack uploadpack tagopt pushurl
			" "$pfx" "$cur_"
		return
		;;
	remote.*)
		local pfx="${cur%.*}." cur_="${cur#*.}"
		__gitcomp_nl "$(__git_remotes)" "$pfx" "$cur_" "."
		return
		;;
	url.*.*)
		local pfx="${cur%.*}." cur_="${cur##*.}"
		__gitcomp "insteadOf pushInsteadOf" "$pfx" "$cur_"
		return
		;;
	esac
	__gitcomp "
		add.ignoreErrors
		advice.commitBeforeMerge
		advice.detachedHead
		advice.implicitIdentity
		advice.pushNonFastForward
		advice.resolveConflict
		advice.statusHints
		alias.
		am.keepcr
		apply.ignorewhitespace
		apply.whitespace
		branch.autosetupmerge
		branch.autosetuprebase
		browser.
		clean.requireForce
		color.branch
		color.branch.current
		color.branch.local
		color.branch.plain
		color.branch.remote
		color.decorate.HEAD
		color.decorate.branch
		color.decorate.remoteBranch
		color.decorate.stash
		color.decorate.tag
		color.diff
		color.diff.commit
		color.diff.frag
		color.diff.func
		color.diff.meta
		color.diff.new
		color.diff.old
		color.diff.plain
		color.diff.whitespace
		color.grep
		color.grep.context
		color.grep.filename
		color.grep.function
		color.grep.linenumber
		color.grep.match
		color.grep.selected
		color.grep.separator
		color.interactive
		color.interactive.error
		color.interactive.header
		color.interactive.help
		color.interactive.prompt
		color.pager
		color.showbranch
		color.status
		color.status.added
		color.status.changed
		color.status.header
		color.status.nobranch
		color.status.untracked
		color.status.updated
		color.ui
		commit.status
		commit.template
		core.abbrev
		core.askpass
		core.attributesfile
		core.autocrlf
		core.bare
		core.bigFileThreshold
		core.compression
		core.createObject
		core.deltaBaseCacheLimit
		core.editor
		core.eol
		core.excludesfile
		core.fileMode
		core.fsyncobjectfiles
		core.gitProxy
		core.ignoreCygwinFSTricks
		core.ignoreStat
		core.ignorecase
		core.logAllRefUpdates
		core.loosecompression
		core.notesRef
		core.packedGitLimit
		core.packedGitWindowSize
		core.pager
		core.preferSymlinkRefs
		core.preloadindex
		core.quotepath
		core.repositoryFormatVersion
		core.safecrlf
		core.sharedRepository
		core.sparseCheckout
		core.symlinks
		core.trustctime
		core.warnAmbiguousRefs
		core.whitespace
		core.worktree
		diff.autorefreshindex
		diff.statGraphWidth
		diff.external
		diff.ignoreSubmodules
		diff.mnemonicprefix
		diff.noprefix
		diff.renameLimit
		diff.renames
		diff.suppressBlankEmpty
		diff.tool
		diff.wordRegex
		difftool.
		difftool.prompt
		fetch.recurseSubmodules
		fetch.unpackLimit
		format.attach
		format.cc
		format.headers
		format.numbered
		format.pretty
		format.signature
		format.signoff
		format.subjectprefix
		format.suffix
		format.thread
		format.to
		gc.
		gc.aggressiveWindow
		gc.auto
		gc.autopacklimit
		gc.packrefs
		gc.pruneexpire
		gc.reflogexpire
		gc.reflogexpireunreachable
		gc.rerereresolved
		gc.rerereunresolved
		gitcvs.allbinary
		gitcvs.commitmsgannotation
		gitcvs.dbTableNamePrefix
		gitcvs.dbdriver
		gitcvs.dbname
		gitcvs.dbpass
		gitcvs.dbuser
		gitcvs.enabled
		gitcvs.logfile
		gitcvs.usecrlfattr
		guitool.
		gui.blamehistoryctx
		gui.commitmsgwidth
		gui.copyblamethreshold
		gui.diffcontext
		gui.encoding
		gui.fastcopyblame
		gui.matchtrackingbranch
		gui.newbranchtemplate
		gui.pruneduringfetch
		gui.spellingdictionary
		gui.trustmtime
		help.autocorrect
		help.browser
		help.format
		http.lowSpeedLimit
		http.lowSpeedTime
		http.maxRequests
		http.minSessions
		http.noEPSV
		http.postBuffer
		http.proxy
		http.sslCAInfo
		http.sslCAPath
		http.sslCert
		http.sslCertPasswordProtected
		http.sslKey
		http.sslVerify
		http.useragent
		i18n.commitEncoding
		i18n.logOutputEncoding
		imap.authMethod
		imap.folder
		imap.host
		imap.pass
		imap.port
		imap.preformattedHTML
		imap.sslverify
		imap.tunnel
		imap.user
		init.templatedir
		instaweb.browser
		instaweb.httpd
		instaweb.local
		instaweb.modulepath
		instaweb.port
		interactive.singlekey
		log.date
		log.decorate
		log.showroot
		mailmap.file
		man.
		man.viewer
		merge.
		merge.conflictstyle
		merge.log
		merge.renameLimit
		merge.renormalize
		merge.stat
		merge.tool
		merge.verbosity
		mergetool.
		mergetool.keepBackup
		mergetool.keepTemporaries
		mergetool.prompt
		notes.displayRef
		notes.rewrite.
		notes.rewrite.amend
		notes.rewrite.rebase
		notes.rewriteMode
		notes.rewriteRef
		pack.compression
		pack.deltaCacheLimit
		pack.deltaCacheSize
		pack.depth
		pack.indexVersion
		pack.packSizeLimit
		pack.threads
		pack.window
		pack.windowMemory
		pager.
		pretty.
		pull.octopus
		pull.twohead
		push.default
		rebase.autosquash
		rebase.stat
		receive.autogc
		receive.denyCurrentBranch
		receive.denyDeleteCurrent
		receive.denyDeletes
		receive.denyNonFastForwards
		receive.fsckObjects
		receive.unpackLimit
		receive.updateserverinfo
		remotes.
		repack.usedeltabaseoffset
		rerere.autoupdate
		rerere.enabled
		sendemail.
		sendemail.aliasesfile
		sendemail.aliasfiletype
		sendemail.bcc
		sendemail.cc
		sendemail.cccmd
		sendemail.chainreplyto
		sendemail.confirm
		sendemail.envelopesender
		sendemail.from
		sendemail.identity
		sendemail.multiedit
		sendemail.signedoffbycc
		sendemail.smtpdomain
		sendemail.smtpencryption
		sendemail.smtppass
		sendemail.smtpserver
		sendemail.smtpserveroption
		sendemail.smtpserverport
		sendemail.smtpuser
		sendemail.suppresscc
		sendemail.suppressfrom
		sendemail.thread
		sendemail.to
		sendemail.validate
		showbranch.default
		status.relativePaths
		status.showUntrackedFiles
		status.submodulesummary
		submodule.
		tar.umask
		transfer.unpackLimit
		url.
		user.email
		user.name
		user.signingkey
		web.browser
		branch. remote.
	"
}

_git_remote ()
{
	local subcommands="add rename remove set-head set-branches set-url show prune update"
	local subcommand="$(__git_find_on_cmdline "$subcommands")"
	if [ -z "$subcommand" ]; then
		__gitcomp "$subcommands"
		return
	fi

	case "$subcommand" in
	rename|remove|set-url|show|prune)
		__gitcomp_nl "$(__git_remotes)"
		;;
	set-head|set-branches)
		__git_complete_remote_or_refspec
		;;
	update)
		local i c='' IFS=$'\n'
		for i in $(git --git-dir="$(__gitdir)" config --get-regexp "remotes\..*" 2>/dev/null); do
			i="${i#remotes.}"
			c="$c ${i/ */}"
		done
		__gitcomp "$c"
		;;
	*)
		COMPREPLY=()
		;;
	esac
}

_git_replace ()
{
	__gitcomp_nl "$(__git_refs)"
}

_git_reset ()
{
	__git_has_doubledash && return

	case "$cur" in
	--*)
		__gitcomp "--merge --mixed --hard --soft --patch"
		return
		;;
	esac
	__gitcomp_nl "$(__git_refs)"
}

_git_revert ()
{
	case "$cur" in
	--*)
		__gitcomp "--edit --mainline --no-edit --no-commit --signoff"
		return
		;;
	esac
	__gitcomp_nl "$(__git_refs)"
}

_git_rm ()
{
	__git_has_doubledash && return

	case "$cur" in
	--*)
		__gitcomp "--cached --dry-run --ignore-unmatch --quiet"
		return
		;;
	esac
	COMPREPLY=()
}

_git_shortlog ()
{
	__git_has_doubledash && return

	case "$cur" in
	--*)
		__gitcomp "
			$__git_log_common_options
			$__git_log_shortlog_options
			--numbered --summary
			"
		return
		;;
	esac
	__git_complete_revlist
}

_git_show ()
{
	__git_has_doubledash && return

	case "$cur" in
	--pretty=*|--format=*)
		__gitcomp "$__git_log_pretty_formats $(__git_pretty_aliases)
			" "" "${cur#*=}"
		return
		;;
	--*)
		__gitcomp "--pretty= --format= --abbrev-commit --oneline
			$__git_diff_common_options
			"
		return
		;;
	esac
	__git_complete_file
}

_git_show_branch ()
{
	case "$cur" in
	--*)
		__gitcomp "
			--all --remotes --topo-order --current --more=
			--list --independent --merge-base --no-name
			--color --no-color
			--sha1-name --sparse --topics --reflog
			"
		return
		;;
	esac
	__git_complete_revlist
}

_git_stash ()
{
	local save_opts='--keep-index --no-keep-index --quiet --patch'
	local subcommands='save list show apply clear drop pop create branch'
	local subcommand="$(__git_find_on_cmdline "$subcommands")"
	if [ -z "$subcommand" ]; then
		case "$cur" in
		--*)
			__gitcomp "$save_opts"
			;;
		*)
			if [ -z "$(__git_find_on_cmdline "$save_opts")" ]; then
				__gitcomp "$subcommands"
			else
				COMPREPLY=()
			fi
			;;
		esac
	else
		case "$subcommand,$cur" in
		save,--*)
			__gitcomp "$save_opts"
			;;
		apply,--*|pop,--*)
			__gitcomp "--index --quiet"
			;;
		show,--*|drop,--*|branch,--*)
			COMPREPLY=()
			;;
		show,*|apply,*|drop,*|pop,*|branch,*)
			__gitcomp_nl "$(git --git-dir="$(__gitdir)" stash list \
					| sed -n -e 's/:.*//p')"
			;;
		*)
			COMPREPLY=()
			;;
		esac
	fi
}

_git_submodule ()
{
	__git_has_doubledash && return

	local subcommands="add status init update summary foreach sync"
	if [ -z "$(__git_find_on_cmdline "$subcommands")" ]; then
		case "$cur" in
		--*)
			__gitcomp "--quiet --cached"
			;;
		*)
			__gitcomp "$subcommands"
			;;
		esac
		return
	fi
}

_git_svn ()
{
	local subcommands="
		init fetch clone rebase dcommit log find-rev
		set-tree commit-diff info create-ignore propget
		proplist show-ignore show-externals branch tag blame
		migrate mkdirs reset gc
		"
	local subcommand="$(__git_find_on_cmdline "$subcommands")"
	if [ -z "$subcommand" ]; then
		__gitcomp "$subcommands"
	else
		local remote_opts="--username= --config-dir= --no-auth-cache"
		local fc_opts="
			--follow-parent --authors-file= --repack=
			--no-metadata --use-svm-props --use-svnsync-props
			--log-window-size= --no-checkout --quiet
			--repack-flags --use-log-author --localtime
			--ignore-paths= $remote_opts
			"
		local init_opts="
			--template= --shared= --trunk= --tags=
			--branches= --stdlayout --minimize-url
			--no-metadata --use-svm-props --use-svnsync-props
			--rewrite-root= --prefix= --use-log-author
			--add-author-from $remote_opts
			"
		local cmt_opts="
			--edit --rmdir --find-copies-harder --copy-similarity=
			"

		case "$subcommand,$cur" in
		fetch,--*)
			__gitcomp "--revision= --fetch-all $fc_opts"
			;;
		clone,--*)
			__gitcomp "--revision= $fc_opts $init_opts"
			;;
		init,--*)
			__gitcomp "$init_opts"
			;;
		dcommit,--*)
			__gitcomp "
				--merge --strategy= --verbose --dry-run
				--fetch-all --no-rebase --commit-url
				--revision --interactive $cmt_opts $fc_opts
				"
			;;
		set-tree,--*)
			__gitcomp "--stdin $cmt_opts $fc_opts"
			;;
		create-ignore,--*|propget,--*|proplist,--*|show-ignore,--*|\
		show-externals,--*|mkdirs,--*)
			__gitcomp "--revision="
			;;
		log,--*)
			__gitcomp "
				--limit= --revision= --verbose --incremental
				--oneline --show-commit --non-recursive
				--authors-file= --color
				"
			;;
		rebase,--*)
			__gitcomp "
				--merge --verbose --strategy= --local
				--fetch-all --dry-run $fc_opts
				"
			;;
		commit-diff,--*)
			__gitcomp "--message= --file= --revision= $cmt_opts"
			;;
		info,--*)
			__gitcomp "--url"
			;;
		branch,--*)
			__gitcomp "--dry-run --message --tag"
			;;
		tag,--*)
			__gitcomp "--dry-run --message"
			;;
		blame,--*)
			__gitcomp "--git-format"
			;;
		migrate,--*)
			__gitcomp "
				--config-dir= --ignore-paths= --minimize
				--no-auth-cache --username=
				"
			;;
		reset,--*)
			__gitcomp "--revision= --parent"
			;;
		*)
			COMPREPLY=()
			;;
		esac
	fi
}

_git_tag ()
{
	local i c=1 f=0
	while [ $c -lt $cword ]; do
		i="${words[c]}"
		case "$i" in
		-d|-v)
			__gitcomp_nl "$(__git_tags)"
			return
			;;
		-f)
			f=1
			;;
		esac
		((c++))
	done

	case "$prev" in
	-m|-F)
		COMPREPLY=()
		;;
	-*|tag)
		if [ $f = 1 ]; then
			__gitcomp_nl "$(__git_tags)"
		else
			COMPREPLY=()
		fi
		;;
	*)
		__gitcomp_nl "$(__git_refs)"
		;;
	esac
}

_git_whatchanged ()
{
	_git_log
}

__git_main ()
{
	local i c=1 command __git_dir

	while [ $c -lt $cword ]; do
		i="${words[c]}"
		case "$i" in
		--git-dir=*) __git_dir="${i#--git-dir=}" ;;
		--bare)      __git_dir="." ;;
		--help) command="help"; break ;;
		-c) c=$((++c)) ;;
		-*) ;;
		*) command="$i"; break ;;
		esac
		((c++))
	done

	if [ -z "$command" ]; then
		case "$cur" in
		--*)   __gitcomp "
			--paginate
			--no-pager
			--git-dir=
			--bare
			--version
			--exec-path
			--exec-path=
			--html-path
			--info-path
			--work-tree=
			--namespace=
			--no-replace-objects
			--help
			"
			;;
		*)     __git_compute_porcelain_commands
		       __gitcomp "$__git_porcelain_commands $(__git_aliases)" ;;
		esac
		return
	fi

	local completion_func="_git_${command//-/_}"
	declare -f $completion_func >/dev/null && $completion_func && return

	local expansion=$(__git_aliased_command "$command")
	if [ -n "$expansion" ]; then
		completion_func="_git_${expansion//-/_}"
		declare -f $completion_func >/dev/null && $completion_func
	fi
}

__gitk_main ()
{
	__git_has_doubledash && return

	local g="$(__gitdir)"
	local merge=""
	if [ -f "$g/MERGE_HEAD" ]; then
		merge="--merge"
	fi
	case "$cur" in
	--*)
		__gitcomp "
			$__git_log_common_options
			$__git_log_gitk_options
			$merge
			"
		return
		;;
	esac
	__git_complete_revlist
}

__git_func_wrap ()
{
	if [[ -n ${ZSH_VERSION-} ]]; then
		emulate -L bash
		setopt KSH_TYPESET

		# workaround zsh's bug that leaves 'words' as a special
		# variable in versions < 4.3.12
		typeset -h words

		# workaround zsh's bug that quotes spaces in the COMPREPLY
		# array if IFS doesn't contain spaces.
		typeset -h IFS
	fi
	local cur words cword prev
	_get_comp_words_by_ref -n =: cur words cword prev
	$1
}

# Setup completion for certain functions defined above by setting common
# variables and workarounds.
# This is NOT a public function; use at your own risk.
__git_complete ()
{
	local wrapper="__git_wrap${2}"
	eval "$wrapper () { __git_func_wrap $2 ; }"
	complete -o bashdefault -o default -o nospace -F $wrapper $1 2>/dev/null \
		|| complete -o default -o nospace -F $wrapper $1
}

# wrapper for backwards compatibility
_git ()
{
	__git_wrap__git_main
}

# wrapper for backwards compatibility
_gitk ()
{
	__git_wrap__gitk_main
}

__git_complete git __git_main
__git_complete gitk __gitk_main

# The following are necessary only for Cygwin, and only are needed
# when the user has tab-completed the executable name and consequently
# included the '.exe' suffix.
#
if [ Cygwin = "$(uname -o 2>/dev/null)" ]; then
__git_complete git.exe __git_main
fi

#compdef git gitk

# zsh completion wrapper for git
#
# Copyright (c) 2012-2020 Felipe Contreras <felipe.contreras@gmail.com>
#
# The recommended way to install this script is to make a copy of it as a
# file named '_git' inside any directory in your fpath.
#
# For example, create a directory '~/.zsh/', copy this file to '~/.zsh/_git',
# and then add the following to your ~/.zshrc file:
#
#  fpath=(~/.zsh $fpath)
#
# You need git's bash completion script installed. By default bash-completion's
# location will be used (e.g. pkg-config --variable=completionsdir bash-completion).
#
# If your bash completion script is somewhere else, you can specify the
# location in your ~/.zshrc:
#
#  zstyle ':completion:*:*:git:*' script ~/.git-completion.bash
#

zstyle -T ':completion:*:*:git:*' tag-order && \
	zstyle ':completion:*:*:git:*' tag-order 'common-commands'

zstyle -s ":completion:*:*:git:*" script script
if [ -z "$script" ]; then
	local -a locations
	local e
	locations=(
		"$(dirname ${funcsourcetrace[1]%:*})"/git-completion.bash
		"$HOME/.local/share/bash-completion/completions/git"
		"$(pkg-config --variable=completionsdir bash-completion)"/git
		'/usr/share/bash-completion/completions/git'
		'/etc/bash_completion.d/git' # old debian
		)
	for e in $locations; do
		test -f $e && script="$e" && break
	done
fi
GIT_SOURCING_ZSH_COMPLETION=y . "$script"

__gitcomp ()
{
	emulate -L zsh

	local cur_="${3-$cur}"

	case "$cur_" in
	--*=)
		;;
	--no-*)
		local c IFS=$' \t\n'
		local -a array
		for c in ${=1}; do
			if [[ $c == "--" ]]; then
				continue
			fi
			c="$c${4-}"
			case $c in
			--*=|*.) ;;
			*) c="$c " ;;
			esac
			array+=("$c")
		done
		compset -P '*[=:]'
		compadd -Q -S '' -p "${2-}" -a -- array && _ret=0
		;;
	*)
		local c IFS=$' \t\n'
		local -a array
		for c in ${=1}; do
			if [[ $c == "--" ]]; then
				c="--no-...${4-}"
				array+=("$c ")
				break
			fi
			c="$c${4-}"
			case $c in
			--*=|*.) ;;
			*) c="$c " ;;
			esac
			array+=("$c")
		done
		compset -P '*[=:]'
		compadd -Q -S '' -p "${2-}" -a -- array && _ret=0
		;;
	esac
}

__gitcomp_direct ()
{
	emulate -L zsh

	compset -P '*[=:]'
	compadd -Q -S '' -- ${(f)1} && _ret=0
}

__gitcomp_nl ()
{
	emulate -L zsh

	compset -P '*[=:]'
	compadd -Q -S "${4- }" -p "${2-}" -- ${(f)1} && _ret=0
}

__gitcomp_nl_append ()
{
	emulate -L zsh

	compset -P '*[=:]'
	compadd -Q -S "${4- }" -p "${2-}" -- ${(f)1} && _ret=0
}

__gitcomp_file_direct ()
{
	emulate -L zsh

	compadd -f -- ${(f)1} && _ret=0
}

__gitcomp_file ()
{
	emulate -L zsh

	compadd -f -p "${2-}" -- ${(f)1} && _ret=0
}

_git_zsh ()
{
	__gitcomp "v1.0"
}

__git_complete_command ()
{
	emulate -L zsh

	local command="$1"
	local completion_func="_git_${command//-/_}"
	if (( $+functions[$completion_func] )); then
		emulate ksh -c $completion_func
		return 0
	else
		return 1
	fi
}

__git_zsh_bash_func ()
{
	emulate -L ksh

	local command=$1

	__git_complete_command "$command" && return

	local expansion=$(__git_aliased_command "$command")
	if [ -n "$expansion" ]; then
		words[1]=$expansion
		__git_complete_command "$expansion"
	fi
}

__git_zsh_cmd_common ()
{
	local -a list
	list=(
	add:'add file contents to the index'
	bisect:'find by binary search the change that introduced a bug'
	branch:'list, create, or delete branches'
	checkout:'checkout a branch or paths to the working tree'
	clone:'clone a repository into a new directory'
	commit:'record changes to the repository'
	diff:'show changes between commits, commit and working tree, etc'
	fetch:'download objects and refs from another repository'
	grep:'print lines matching a pattern'
	init:'create an empty Git repository or reinitialize an existing one'
	log:'show commit logs'
	merge:'join two or more development histories together'
	mv:'move or rename a file, a directory, or a symlink'
	pull:'fetch from and merge with another repository or a local branch'
	push:'update remote refs along with associated objects'
	rebase:'forward-port local commits to the updated upstream head'
	reset:'reset current HEAD to the specified state'
	restore:'restore working tree files'
	rm:'remove files from the working tree and from the index'
	show:'show various types of objects'
	status:'show the working tree status'
	switch:'switch branches'
	tag:'create, list, delete or verify a tag object signed with GPG')
	_describe -t common-commands 'common commands' list && _ret=0
}

__git_zsh_cmd_alias ()
{
	local -a list
	list=(${${(0)"$(git config -z --get-regexp '^alias\.*')"}#alias.})
	list=(${(f)"$(printf "%s:alias for '%s'\n" ${(f@)list})"})
	_describe -t alias-commands 'aliases' list && _ret=0
}

__git_zsh_cmd_all ()
{
	local -a list
	emulate ksh -c __git_compute_all_commands
	list=( ${=__git_all_commands} )
	_describe -t all-commands 'all commands' list && _ret=0
}

__git_zsh_main ()
{
	local curcontext="$curcontext" state state_descr line
	typeset -A opt_args
	local -a orig_words

	orig_words=( ${words[@]} )

	_arguments -C \
		'(-p --paginate --no-pager)'{-p,--paginate}'[pipe all output into ''less'']' \
		'(-p --paginate)--no-pager[do not pipe git output into a pager]' \
		'--git-dir=-[set the path to the repository]: :_directories' \
		'--bare[treat the repository as a bare repository]' \
		'(- :)--version[prints the git suite version]' \
		'--exec-path=-[path to where your core git programs are installed]:: :_directories' \
		'--html-path[print the path where git''s HTML documentation is installed]' \
		'--info-path[print the path where the Info files are installed]' \
		'--man-path[print the manpath (see `man(1)`) for the man pages]' \
		'--work-tree=-[set the path to the working tree]: :_directories' \
		'--namespace=-[set the git namespace]' \
		'--no-replace-objects[do not use replacement refs to replace git objects]' \
		'(- :)--help[prints the synopsis and a list of the most commonly used commands]: :->arg' \
		'(-): :->command' \
		'(-)*:: :->arg' && return

	case $state in
	(command)
		_tags common-commands alias-commands all-commands
		while _tags; do
			_requested common-commands && __git_zsh_cmd_common
			_requested alias-commands && __git_zsh_cmd_alias
			_requested all-commands && __git_zsh_cmd_all
			let _ret || break
		done
		;;
	(arg)
		local command="${words[1]}" __git_dir

		if (( $+opt_args[--bare] )); then
			__git_dir='.'
		else
			__git_dir=${opt_args[--git-dir]}
		fi

		(( $+opt_args[--help] )) && command='help'

		words=( ${orig_words[@]} )

		__git_zsh_bash_func $command
		;;
	esac
}

_git ()
{
	local _ret=1
	local cur cword prev

	cur=${words[CURRENT]}
	prev=${words[CURRENT-1]}
	let cword=CURRENT-1

	if (( $+functions[__${service}_zsh_main] )); then
		__${service}_zsh_main
	elif (( $+functions[__${service}_main] )); then
		emulate ksh -c __${service}_main
	elif (( $+functions[_${service}] )); then
		emulate ksh -c _${service}
	elif ((	$+functions[_${service//-/_}] )); then
		emulate ksh -c _${service//-/_}
	fi

	let _ret && _default && _ret=0
	return _ret
}

_git

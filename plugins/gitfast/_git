#compdef git gitk

# zsh completion wrapper for git
#
# Copyright (c) 2012-2013 Felipe Contreras <felipe.contreras@gmail.com>
#
# You need git's bash completion script installed somewhere, by default it
# would be the location bash-completion uses.
#
# If your script is somewhere else, you can configure it on your ~/.zshrc:
#
#  zstyle ':completion:*:*:git:*' script ~/.git-completion.sh
#
# The recommended way to install this script is to copy to '~/.zsh/_git', and
# then add the following to your ~/.zshrc file:
#
#  fpath=(~/.zsh $fpath)

complete ()
{
	# do nothing
	return 0
}

zstyle -T ':completion:*:*:git:*' tag-order && \
	zstyle ':completion:*:*:git:*' tag-order 'common-commands'

zstyle -s ":completion:*:*:git:*" script script
if [ -z "$script" ]; then
	local -a locations
	local e
	locations=(
		$(dirname ${funcsourcetrace[1]%:*})/git-completion.bash
		'/etc/bash_completion.d/git' # fedora, old debian
		'/usr/share/bash-completion/completions/git' # arch, ubuntu, new debian
		'/usr/share/bash-completion/git' # gentoo
		)
	for e in $locations; do
		test -f $e && script="$e" && break
	done
fi
ZSH_VERSION='' . "$script"

__gitcomp ()
{
	emulate -L zsh

	local cur_="${3-$cur}"

	case "$cur_" in
	--*=)
		;;
	*)
		local c IFS=$' \t\n'
		local -a array
		for c in ${=1}; do
			c="$c${4-}"
			case $c in
			--*=*|*.) ;;
			*) c="$c " ;;
			esac
			array+=("$c")
		done
		compset -P '*[=:]'
		compadd -Q -S '' -p "${2-}" -a -- array && _ret=0
		;;
	esac
}

__gitcomp_nl ()
{
	emulate -L zsh

	local IFS=$'\n'
	compset -P '*[=:]'
	compadd -Q -S "${4- }" -p "${2-}" -- ${=1} && _ret=0
}

__gitcomp_nl_append ()
{
	emulate -L zsh

	local IFS=$'\n'
	compadd -Q -S "${4- }" -p "${2-}" -- ${=1} && _ret=0
}

__gitcomp_file ()
{
	emulate -L zsh

	local IFS=$'\n'
	compset -P '*[=:]'
	compadd -Q -p "${2-}" -f -- ${=1} && _ret=0
}

__git_zsh_bash_func ()
{
	emulate -L ksh

	local command=$1

	local completion_func="_git_${command//-/_}"
	declare -f $completion_func >/dev/null && $completion_func && return

	local expansion=$(__git_aliased_command "$command")
	if [ -n "$expansion" ]; then
		completion_func="_git_${expansion//-/_}"
		declare -f $completion_func >/dev/null && $completion_func
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
	rm:'remove files from the working tree and from the index'
	show:'show various types of objects'
	status:'show the working tree status'
	tag:'create, list, delete or verify a tag object signed with GPG')
	_describe -t common-commands 'common commands' list && _ret=0
}

__git_zsh_cmd_alias ()
{
	local -a list
	list=(${${${(0)"$(git config -z --get-regexp '^alias\.')"}#alias.}%$'\n'*})
	_describe -t alias-commands 'aliases' list $* && _ret=0
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
		_alternative \
                         'alias-commands:alias:__git_zsh_cmd_alias' \
                         'common-commands:common:__git_zsh_cmd_common' \
                         'all-commands:all:__git_zsh_cmd_all' && _ret=0
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
	else
		emulate ksh -c __${service}_main
	fi

	let _ret && _default && _ret=0
	return _ret
}

_git

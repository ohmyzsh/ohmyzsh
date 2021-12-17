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
#    *) git email aliases for git-send-email
#    *) tree paths within 'ref:path/to/file' expressions
#    *) file paths within current working directory and index
#    *) common --long-options
#
# To use these routines:
#
#    1) Copy this file to somewhere (e.g. ~/.git-completion.bash).
#    2) Add the following line to your .bashrc/.zshrc:
#        source ~/.git-completion.bash
#    3) Consider changing your PS1 to also show the current branch,
#       see git-prompt.sh for details.
#
# If you use complex aliases of form '!f() { ... }; f', you can use the null
# command ':' as the first command in the function body to declare the desired
# completion style.  For example '!f() { : git commit ; ... }; f' will
# tell the completion to use commit completion.  This also works with aliases
# of form "!sh -c '...'".  For example, "!sh -c ': git commit ; ... '".
#
# Compatible with bash 3.2.57.
#
# You can set the following environment variables to influence the behavior of
# the completion routines:
#
#   GIT_COMPLETION_CHECKOUT_NO_GUESS
#
#     When set to "1", do not include "DWIM" suggestions in git-checkout
#     and git-switch completion (e.g., completing "foo" when "origin/foo"
#     exists).
#
#   GIT_COMPLETION_SHOW_ALL
#
#     When set to "1" suggest all options, including options which are
#     typically hidden (e.g. '--allow-empty' for 'git commit').

# Discovers the path to the git repository taking any '--git-dir=<path>' and
# '-C <path>' options into account and stores it in the $__git_repo_path
# variable.
__git_find_repo_path ()
{
	if [ -n "${__git_repo_path-}" ]; then
		# we already know where it is
		return
	fi

	if [ -n "${__git_C_args-}" ]; then
		__git_repo_path="$(git "${__git_C_args[@]}" \
			${__git_dir:+--git-dir="$__git_dir"} \
			rev-parse --absolute-git-dir 2>/dev/null)"
	elif [ -n "${__git_dir-}" ]; then
		test -d "$__git_dir" &&
		__git_repo_path="$__git_dir"
	elif [ -n "${GIT_DIR-}" ]; then
		test -d "${GIT_DIR-}" &&
		__git_repo_path="$GIT_DIR"
	elif [ -d .git ]; then
		__git_repo_path=.git
	else
		__git_repo_path="$(git rev-parse --git-dir 2>/dev/null)"
	fi
}

# Deprecated: use __git_find_repo_path() and $__git_repo_path instead
# __gitdir accepts 0 or 1 arguments (i.e., location)
# returns location of .git repo
__gitdir ()
{
	if [ -z "${1-}" ]; then
		__git_find_repo_path || return 1
		echo "$__git_repo_path"
	elif [ -d "$1/.git" ]; then
		echo "$1/.git"
	else
		echo "$1"
	fi
}

# Runs git with all the options given as argument, respecting any
# '--git-dir=<path>' and '-C <path>' options present on the command line
__git ()
{
	git ${__git_C_args:+"${__git_C_args[@]}"} \
		${__git_dir:+--git-dir="$__git_dir"} "$@" 2>/dev/null
}

# Removes backslash escaping, single quotes and double quotes from a word,
# stores the result in the variable $dequoted_word.
# 1: The word to dequote.
__git_dequote ()
{
	local rest="$1" len ch

	dequoted_word=""

	while test -n "$rest"; do
		len=${#dequoted_word}
		dequoted_word="$dequoted_word${rest%%[\\\'\"]*}"
		rest="${rest:$((${#dequoted_word}-$len))}"

		case "${rest:0:1}" in
		\\)
			ch="${rest:1:1}"
			case "$ch" in
			$'\n')
				;;
			*)
				dequoted_word="$dequoted_word$ch"
				;;
			esac
			rest="${rest:2}"
			;;
		\')
			rest="${rest:1}"
			len=${#dequoted_word}
			dequoted_word="$dequoted_word${rest%%\'*}"
			rest="${rest:$((${#dequoted_word}-$len+1))}"
			;;
		\")
			rest="${rest:1}"
			while test -n "$rest" ; do
				len=${#dequoted_word}
				dequoted_word="$dequoted_word${rest%%[\\\"]*}"
				rest="${rest:$((${#dequoted_word}-$len))}"
				case "${rest:0:1}" in
				\\)
					ch="${rest:1:1}"
					case "$ch" in
					\"|\\|\$|\`)
						dequoted_word="$dequoted_word$ch"
						;;
					$'\n')
						;;
					*)
						dequoted_word="$dequoted_word\\$ch"
						;;
					esac
					rest="${rest:2}"
					;;
				\")
					rest="${rest:1}"
					break
					;;
				esac
			done
			;;
		esac
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
#   along with this program; if not, see <http://www.gnu.org/licenses/>.
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
fi

# Fills the COMPREPLY array with prefiltered words without any additional
# processing.
# Callers must take care of providing only words that match the current word
# to be completed and adding any prefix and/or suffix (trailing space!), if
# necessary.
# 1: List of newline-separated matching completion words, complete with
#    prefix and suffix.
__gitcomp_direct ()
{
	local IFS=$'\n'

	COMPREPLY=($1)
}

# Similar to __gitcomp_direct, but appends to COMPREPLY instead.
# Callers must take care of providing only words that match the current word
# to be completed and adding any prefix and/or suffix (trailing space!), if
# necessary.
# 1: List of newline-separated matching completion words, complete with
#    prefix and suffix.
__gitcomp_direct_append ()
{
	local IFS=$'\n'

	COMPREPLY+=($1)
}

__gitcompappend ()
{
	local x i=${#COMPREPLY[@]}
	for x in $1; do
		if [[ "$x" == "$3"* ]]; then
			COMPREPLY[i++]="$2$x$4"
		fi
	done
}

__gitcompadd ()
{
	COMPREPLY=()
	__gitcompappend "$@"
}

# Generates completion reply, appending a space to possible completion words,
# if necessary.
# It accepts 1 to 4 arguments:
# 1: List of possible completion words.
# 2: A prefix to be added to each possible completion word (optional).
# 3: Generate possible completion matches for this word (optional).
# 4: A suffix to be appended to each possible completion word (optional).
__gitcomp ()
{
	local cur_="${3-$cur}"

	case "$cur_" in
	*=)
		;;
	--no-*)
		local c i=0 IFS=$' \t\n'
		for c in $1; do
			if [[ $c == "--" ]]; then
				continue
			fi
			c="$c${4-}"
			if [[ $c == "$cur_"* ]]; then
				case $c in
				--*=|*.) ;;
				*) c="$c " ;;
				esac
				COMPREPLY[i++]="${2-}$c"
			fi
		done
		;;
	*)
		local c i=0 IFS=$' \t\n'
		for c in $1; do
			if [[ $c == "--" ]]; then
				c="--no-...${4-}"
				if [[ $c == "$cur_"* ]]; then
					COMPREPLY[i++]="${2-}$c "
				fi
				break
			fi
			c="$c${4-}"
			if [[ $c == "$cur_"* ]]; then
				case $c in
				*=|*.) ;;
				*) c="$c " ;;
				esac
				COMPREPLY[i++]="${2-}$c"
			fi
		done
		;;
	esac
}

# Clear the variables caching builtins' options when (re-)sourcing
# the completion script.
if [[ -n ${ZSH_VERSION-} ]]; then
	unset ${(M)${(k)parameters[@]}:#__gitcomp_builtin_*} 2>/dev/null
else
	unset $(compgen -v __gitcomp_builtin_)
fi

__gitcomp_builtin_add_default=" --dry-run --verbose --interactive --patch --edit --force --update --renormalize --intent-to-add --all --ignore-removal --refresh --ignore-errors --ignore-missing --chmod= --pathspec-from-file= --pathspec-file-nul --no-dry-run -- --no-verbose --no-interactive --no-patch --no-edit --no-force --no-update --no-renormalize --no-intent-to-add --no-all --no-ignore-removal --no-refresh --no-ignore-errors --no-ignore-missing --no-chmod --no-pathspec-from-file --no-pathspec-file-nul"
__gitcomp_builtin_am_default=" --interactive --3way --quiet --signoff --utf8 --keep --keep-non-patch --message-id --keep-cr --no-keep-cr --scissors --whitespace= --ignore-space-change --ignore-whitespace --directory= --exclude= --include= --patch-format= --reject --resolvemsg= --continue --resolved --skip --abort --quit --show-current-patch --committer-date-is-author-date --ignore-date --rerere-autoupdate --gpg-sign -- --no-interactive --no-3way --no-quiet --no-signoff --no-utf8 --no-keep --no-keep-non-patch --no-message-id --no-scissors --no-whitespace --no-ignore-space-change --no-ignore-whitespace --no-directory --no-exclude --no-include --no-patch-format --no-reject --no-resolvemsg --no-committer-date-is-author-date --no-ignore-date --no-rerere-autoupdate --no-gpg-sign"
__gitcomp_builtin_apply_default=" --exclude= --include= --no-add --stat --numstat --summary --check --index --intent-to-add --cached --apply --3way --build-fake-ancestor= --whitespace= --ignore-space-change --ignore-whitespace --reverse --unidiff-zero --reject --allow-overlap --verbose --inaccurate-eof --recount --directory= --add -- --no-stat --no-numstat --no-summary --no-check --no-index --no-intent-to-add --no-cached --no-apply --no-3way --no-build-fake-ancestor --no-whitespace --no-ignore-space-change --no-ignore-whitespace --no-reverse --no-unidiff-zero --no-reject --no-allow-overlap --no-verbose --no-inaccurate-eof --no-recount --no-directory"
__gitcomp_builtin_archive_default=" --output= --remote= --exec= --no-output -- --no-remote --no-exec"
__gitcomp_builtin_bisect__helper_default=" --next-all --write-terms --bisect-clean-state --check-expected-revs --bisect-reset --bisect-write --check-and-set-terms --bisect-next-check --bisect-terms --bisect-start --bisect-next --bisect-auto-next --bisect-autostart --no-log --log"
__gitcomp_builtin_blame_default=" --incremental --root --show-stats --progress --score-debug --show-name --show-number --porcelain --line-porcelain --show-email --ignore-rev= --ignore-revs-file= --color-lines --color-by-age --minimal --contents= --abbrev --no-incremental -- --no-root --no-show-stats --no-progress --no-score-debug --no-show-name --no-show-number --no-porcelain --no-line-porcelain --no-show-email --no-ignore-rev --no-ignore-revs-file --no-color-lines --no-color-by-age --no-minimal --no-contents --no-abbrev"
__gitcomp_builtin_branch_default=" --verbose --quiet --track --set-upstream-to= --unset-upstream --color --remotes --contains --no-contains --abbrev --all --delete --move --copy --list --show-current --create-reflog --edit-description --merged --no-merged --column --sort= --points-at= --ignore-case --format= -- --no-verbose --no-quiet --no-track --no-set-upstream-to --no-unset-upstream --no-color --no-remotes --no-abbrev --no-all --no-delete --no-move --no-copy --no-list --no-show-current --no-create-reflog --no-edit-description --no-column --no-points-at --no-ignore-case --no-format"
__gitcomp_builtin_bugreport_default=" --output-directory= --suffix= --no-output-directory -- --no-suffix"
__gitcomp_builtin_cat_file_default=" --textconv --filters --path= --allow-unknown-type --buffer --batch --batch-check --follow-symlinks --batch-all-objects --unordered --no-path -- --no-allow-unknown-type --no-buffer --no-follow-symlinks --no-batch-all-objects --no-unordered"
__gitcomp_builtin_check_attr_default=" --all --cached --stdin --no-all -- --no-cached --no-stdin"
__gitcomp_builtin_check_ignore_default=" --quiet --verbose --stdin --non-matching --no-index --index -- --no-quiet --no-verbose --no-stdin --no-non-matching"
__gitcomp_builtin_check_mailmap_default=" --stdin --no-stdin"
__gitcomp_builtin_checkout_default=" --guess --overlay --quiet --recurse-submodules --progress --merge --conflict= --detach --track --orphan= --ignore-other-worktrees --ours --theirs --patch --ignore-skip-worktree-bits --pathspec-from-file= --pathspec-file-nul --no-guess -- --no-overlay --no-quiet --no-recurse-submodules --no-progress --no-merge --no-conflict --no-detach --no-track --no-orphan --no-ignore-other-worktrees --no-patch --no-ignore-skip-worktree-bits --no-pathspec-from-file --no-pathspec-file-nul"
__gitcomp_builtin_checkout_index_default=" --all --force --quiet --no-create --index --stdin --temp --prefix= --stage= --create -- --no-all --no-force --no-quiet --no-index --no-stdin --no-temp --no-prefix"
__gitcomp_builtin_cherry_default=" --abbrev --verbose --no-abbrev -- --no-verbose"
__gitcomp_builtin_cherry_pick_default=" --quit --continue --abort --skip --cleanup= --no-commit --edit --signoff --mainline= --rerere-autoupdate --strategy= --strategy-option= --gpg-sign --ff --allow-empty --allow-empty-message --keep-redundant-commits --commit -- --no-cleanup --no-edit --no-signoff --no-mainline --no-rerere-autoupdate --no-strategy --no-strategy-option --no-gpg-sign --no-ff --no-allow-empty --no-allow-empty-message --no-keep-redundant-commits"
__gitcomp_builtin_clean_default=" --quiet --dry-run --interactive --exclude= --no-quiet -- --no-dry-run --no-interactive"
__gitcomp_builtin_clone_default=" --verbose --quiet --progress --no-checkout --bare --mirror --local --no-hardlinks --shared --recurse-submodules --recursive --jobs= --template= --reference= --reference-if-able= --dissociate --origin= --branch= --upload-pack= --depth= --shallow-since= --shallow-exclude= --single-branch --no-tags --shallow-submodules --separate-git-dir= --config= --server-option= --ipv4 --ipv6 --filter= --remote-submodules --sparse --checkout --hardlinks --tags -- --no-verbose --no-quiet --no-progress --no-bare --no-mirror --no-local --no-shared --no-recurse-submodules --no-recursive --no-jobs --no-template --no-reference --no-reference-if-able --no-dissociate --no-origin --no-branch --no-upload-pack --no-depth --no-shallow-since --no-shallow-exclude --no-single-branch --no-shallow-submodules --no-separate-git-dir --no-config --no-server-option --no-ipv4 --no-ipv6 --no-filter --no-remote-submodules --no-sparse"
__gitcomp_builtin_column_default=" --command= --mode --raw-mode= --width= --indent= --nl= --padding= --no-command -- --no-mode --no-raw-mode --no-width --no-indent --no-nl --no-padding"
__gitcomp_builtin_commit_default=" --quiet --verbose --file= --author= --date= --message= --reedit-message= --reuse-message= --fixup= --squash= --reset-author --signoff --template= --edit --cleanup= --status --gpg-sign --all --include --interactive --patch --only --no-verify --dry-run --short --branch --ahead-behind --porcelain --long --null --amend --no-post-rewrite --untracked-files --pathspec-from-file= --pathspec-file-nul --verify --post-rewrite -- --no-quiet --no-verbose --no-file --no-author --no-date --no-message --no-reedit-message --no-reuse-message --no-fixup --no-squash --no-reset-author --no-signoff --no-template --no-edit --no-cleanup --no-status --no-gpg-sign --no-all --no-include --no-interactive --no-patch --no-only --no-dry-run --no-short --no-branch --no-ahead-behind --no-porcelain --no-long --no-null --no-amend --no-untracked-files --no-pathspec-from-file --no-pathspec-file-nul"
__gitcomp_builtin_commit_graph_default=" --object-dir= --no-object-dir"
__gitcomp_builtin_config_default=" --global --system --local --worktree --file= --blob= --get --get-all --get-regexp --get-urlmatch --replace-all --add --unset --unset-all --rename-section --remove-section --list --edit --get-color --get-colorbool --type= --bool --int --bool-or-int --bool-or-str --path --expiry-date --null --name-only --includes --show-origin --show-scope --default= --no-global -- --no-system --no-local --no-worktree --no-file --no-blob --no-get --no-get-all --no-get-regexp --no-get-urlmatch --no-replace-all --no-add --no-unset --no-unset-all --no-rename-section --no-remove-section --no-list --no-edit --no-get-color --no-get-colorbool --no-type --no-null --no-name-only --no-includes --no-show-origin --no-show-scope --no-default"
__gitcomp_builtin_count_objects_default=" --verbose --human-readable --no-verbose -- --no-human-readable"
__gitcomp_builtin_credential_cache_default=" --timeout= --socket= --no-timeout -- --no-socket"
__gitcomp_builtin_credential_cache__daemon_default=" --debug --no-debug"
__gitcomp_builtin_credential_store_default=" --file= --no-file"
__gitcomp_builtin_describe_default=" --contains --debug --all --tags --long --first-parent --abbrev --exact-match --candidates= --match= --exclude= --always --dirty --broken --no-contains -- --no-debug --no-all --no-tags --no-long --no-first-parent --no-abbrev --no-exact-match --no-candidates --no-match --no-exclude --no-always --no-dirty --no-broken"
__gitcomp_builtin_difftool_default=" --gui --dir-diff --no-prompt --symlinks --tool= --tool-help --trust-exit-code --extcmd= --no-index -- --no-gui --no-dir-diff --no-symlinks --no-tool --no-tool-help --no-trust-exit-code --no-extcmd"
__gitcomp_builtin_env__helper_default=" --type= --default= --exit-code --no-default -- --no-exit-code"
__gitcomp_builtin_fast_export_default=" --progress= --signed-tags= --tag-of-filtered-object= --reencode= --export-marks= --import-marks= --import-marks-if-exists= --fake-missing-tagger --full-tree --use-done-feature --no-data --refspec= --anonymize --anonymize-map= --reference-excluded-parents --show-original-ids --mark-tags --data -- --no-progress --no-signed-tags --no-tag-of-filtered-object --no-reencode --no-export-marks --no-import-marks --no-import-marks-if-exists --no-fake-missing-tagger --no-full-tree --no-use-done-feature --no-refspec --no-anonymize --no-reference-excluded-parents --no-show-original-ids --no-mark-tags"
__gitcomp_builtin_fetch_default=" --verbose --quiet --all --set-upstream --append --upload-pack= --force --multiple --tags --jobs= --prune --prune-tags --recurse-submodules --dry-run --write-fetch-head --keep --update-head-ok --progress --depth= --shallow-since= --shallow-exclude= --deepen= --unshallow --update-shallow --refmap= --server-option= --ipv4 --ipv6 --negotiation-tip= --filter= --auto-maintenance --auto-gc --show-forced-updates --write-commit-graph --stdin --no-verbose -- --no-quiet --no-all --no-set-upstream --no-append --no-upload-pack --no-force --no-multiple --no-tags --no-jobs --no-prune --no-prune-tags --no-recurse-submodules --no-dry-run --no-write-fetch-head --no-keep --no-update-head-ok --no-progress --no-depth --no-shallow-since --no-shallow-exclude --no-deepen --no-update-shallow --no-server-option --no-ipv4 --no-ipv6 --no-negotiation-tip --no-filter --no-auto-maintenance --no-auto-gc --no-show-forced-updates --no-write-commit-graph --no-stdin"
__gitcomp_builtin_fmt_merge_msg_default=" --log --message= --file= --no-log -- --no-message --no-file"
__gitcomp_builtin_for_each_ref_default=" --shell --perl --python --tcl --count= --format= --color --sort= --points-at= --merged --no-merged --contains --no-contains --ignore-case -- --no-shell --no-perl --no-python --no-tcl --no-count --no-format --no-color --no-points-at --no-ignore-case"
__gitcomp_builtin_format_patch_default=" --numbered --no-numbered --signoff --stdout --cover-letter --numbered-files --suffix= --start-number= --reroll-count= --rfc --cover-from-description= --subject-prefix= --output-directory= --keep-subject --no-binary --zero-commit --ignore-if-in-upstream --no-stat --add-header= --to= --cc= --from --in-reply-to= --attach --inline --thread --signature= --base= --signature-file= --quiet --progress --interdiff= --range-diff= --creation-factor= --binary -- --no-numbered --no-signoff --no-stdout --no-cover-letter --no-numbered-files --no-suffix --no-start-number --no-reroll-count --no-cover-from-description --no-zero-commit --no-ignore-if-in-upstream --no-add-header --no-to --no-cc --no-from --no-in-reply-to --no-attach --no-thread --no-signature --no-base --no-signature-file --no-quiet --no-progress --no-interdiff --no-range-diff --no-creation-factor"
__gitcomp_builtin_fsck_default=" --verbose --unreachable --dangling --tags --root --cache --reflogs --full --connectivity-only --strict --lost-found --progress --name-objects --no-verbose -- --no-unreachable --no-dangling --no-tags --no-root --no-cache --no-reflogs --no-full --no-connectivity-only --no-strict --no-lost-found --no-progress --no-name-objects"
__gitcomp_builtin_fsck_objects_default=" --verbose --unreachable --dangling --tags --root --cache --reflogs --full --connectivity-only --strict --lost-found --progress --name-objects --no-verbose -- --no-unreachable --no-dangling --no-tags --no-root --no-cache --no-reflogs --no-full --no-connectivity-only --no-strict --no-lost-found --no-progress --no-name-objects"
__gitcomp_builtin_gc_default=" --quiet --prune --aggressive --keep-largest-pack --no-quiet -- --no-prune --no-aggressive --no-keep-largest-pack"
__gitcomp_builtin_grep_default=" --cached --no-index --untracked --exclude-standard --recurse-submodules --invert-match --ignore-case --word-regexp --text --textconv --recursive --max-depth= --extended-regexp --basic-regexp --fixed-strings --perl-regexp --line-number --column --full-name --files-with-matches --name-only --files-without-match --only-matching --count --color --break --heading --context= --before-context= --after-context= --threads= --show-function --function-context --and --or --not --quiet --all-match --index -- --no-cached --no-untracked --no-exclude-standard --no-recurse-submodules --no-invert-match --no-ignore-case --no-word-regexp --no-text --no-textconv --no-recursive --no-extended-regexp --no-basic-regexp --no-fixed-strings --no-perl-regexp --no-line-number --no-column --no-full-name --no-files-with-matches --no-name-only --no-files-without-match --no-only-matching --no-count --no-color --no-break --no-heading --no-context --no-before-context --no-after-context --no-threads --no-show-function --no-function-context --no-or --no-quiet --no-all-match"
__gitcomp_builtin_hash_object_default=" --stdin --stdin-paths --no-filters --literally --path= --filters -- --no-stdin --no-stdin-paths --no-literally --no-path"
__gitcomp_builtin_help_default=" --all --guides --config --man --web --info --verbose --no-all -- --no-guides --no-config --no-man --no-web --no-info --no-verbose"
__gitcomp_builtin_init_default=" --template= --bare --shared --quiet --separate-git-dir= --initial-branch= --object-format= --no-template -- --no-bare --no-quiet --no-separate-git-dir --no-initial-branch --no-object-format"
__gitcomp_builtin_init_db_default=" --template= --bare --shared --quiet --separate-git-dir= --initial-branch= --object-format= --no-template -- --no-bare --no-quiet --no-separate-git-dir --no-initial-branch --no-object-format"
__gitcomp_builtin_interpret_trailers_default=" --in-place --trim-empty --where= --if-exists= --if-missing= --only-trailers --only-input --unfold --parse --no-divider --trailer= --divider -- --no-in-place --no-trim-empty --no-where --no-if-exists --no-if-missing --no-only-trailers --no-only-input --no-unfold --no-trailer"
__gitcomp_builtin_log_default=" --quiet --source --use-mailmap --mailmap --decorate-refs= --decorate-refs-exclude= --decorate --no-quiet -- --no-source --no-use-mailmap --no-mailmap --no-decorate-refs --no-decorate-refs-exclude --no-decorate"
__gitcomp_builtin_ls_files_default=" --cached --deleted --modified --others --ignored --stage --killed --directory --eol --empty-directory --unmerged --resolve-undo --exclude= --exclude-from= --exclude-per-directory= --exclude-standard --full-name --recurse-submodules --error-unmatch --with-tree= --abbrev --debug --no-cached -- --no-deleted --no-modified --no-others --no-ignored --no-stage --no-killed --no-directory --no-eol --no-empty-directory --no-unmerged --no-resolve-undo --no-exclude-per-directory --no-recurse-submodules --no-error-unmatch --no-with-tree --no-abbrev --no-debug"
__gitcomp_builtin_ls_remote_default=" --quiet --upload-pack= --tags --heads --refs --get-url --sort= --symref --server-option= --no-quiet -- --no-upload-pack --no-tags --no-heads --no-refs --no-get-url --no-symref --no-server-option"
__gitcomp_builtin_ls_tree_default=" --long --name-only --name-status --full-name --full-tree --abbrev --no-long -- --no-name-only --no-name-status --no-full-name --no-full-tree --no-abbrev"
__gitcomp_builtin_merge_default=" --stat --summary --log --squash --commit --edit --cleanup= --ff --ff-only --rerere-autoupdate --verify-signatures --strategy= --strategy-option= --message= --file --verbose --quiet --abort --quit --continue --allow-unrelated-histories --progress --gpg-sign --autostash --overwrite-ignore --signoff --no-verify --verify -- --no-stat --no-summary --no-log --no-squash --no-commit --no-edit --no-cleanup --no-ff --no-rerere-autoupdate --no-verify-signatures --no-strategy --no-strategy-option --no-message --no-verbose --no-quiet --no-abort --no-quit --no-continue --no-allow-unrelated-histories --no-progress --no-gpg-sign --no-autostash --no-overwrite-ignore --no-signoff"
__gitcomp_builtin_merge_base_default=" --all --octopus --independent --is-ancestor --fork-point --no-all"
__gitcomp_builtin_merge_file_default=" --stdout --diff3 --ours --theirs --union --marker-size= --quiet --no-stdout -- --no-diff3 --no-ours --no-theirs --no-union --no-marker-size --no-quiet"
__gitcomp_builtin_mktree_default=" --missing --batch --no-missing -- --no-batch"
__gitcomp_builtin_multi_pack_index_default=" --object-dir= --progress --batch-size= --no-object-dir -- --no-progress"
__gitcomp_builtin_mv_default=" --verbose --dry-run --no-verbose -- --no-dry-run"
__gitcomp_builtin_name_rev_default=" --name-only --tags --refs= --exclude= --all --stdin --undefined --always --no-name-only -- --no-tags --no-refs --no-exclude --no-all --no-stdin --no-undefined --no-always"
__gitcomp_builtin_notes_default=" --ref= --no-ref"
__gitcomp_builtin_pack_objects_default=" --quiet --progress --all-progress --all-progress-implied --index-version= --max-pack-size= --local --incremental --window= --window-memory= --depth= --reuse-delta --reuse-object --delta-base-offset --threads= --non-empty --revs --unpacked --all --reflog --indexed-objects --stdout --include-tag --keep-unreachable --pack-loose-unreachable --unpack-unreachable --sparse --thin --shallow --honor-pack-keep --keep-pack= --compression= --keep-true-parents --use-bitmap-index --write-bitmap-index --filter= --missing= --exclude-promisor-objects --delta-islands --uri-protocol= --no-quiet -- --no-progress --no-all-progress --no-all-progress-implied --no-local --no-incremental --no-window --no-depth --no-reuse-delta --no-reuse-object --no-delta-base-offset --no-threads --no-non-empty --no-revs --no-stdout --no-include-tag --no-keep-unreachable --no-pack-loose-unreachable --no-unpack-unreachable --no-sparse --no-thin --no-shallow --no-honor-pack-keep --no-keep-pack --no-compression --no-keep-true-parents --no-use-bitmap-index --no-write-bitmap-index --no-filter --no-exclude-promisor-objects --no-delta-islands --no-uri-protocol"
__gitcomp_builtin_pack_refs_default=" --all --prune --no-all -- --no-prune"
__gitcomp_builtin_pickaxe_default=" --incremental --root --show-stats --progress --score-debug --show-name --show-number --porcelain --line-porcelain --show-email --ignore-rev= --ignore-revs-file= --color-lines --color-by-age --minimal --contents= --abbrev --no-incremental -- --no-root --no-show-stats --no-progress --no-score-debug --no-show-name --no-show-number --no-porcelain --no-line-porcelain --no-show-email --no-ignore-rev --no-ignore-revs-file --no-color-lines --no-color-by-age --no-minimal --no-contents --no-abbrev"
__gitcomp_builtin_prune_default=" --dry-run --verbose --progress --expire= --exclude-promisor-objects --no-dry-run -- --no-verbose --no-progress --no-expire --no-exclude-promisor-objects"
__gitcomp_builtin_prune_packed_default=" --dry-run --quiet --no-dry-run -- --no-quiet"
__gitcomp_builtin_pull_default=" --verbose --quiet --progress --recurse-submodules --rebase --stat --log --signoff --squash --commit --edit --cleanup= --ff --ff-only --verify-signatures --autostash --strategy= --strategy-option= --gpg-sign --allow-unrelated-histories --all --append --upload-pack= --force --tags --prune --jobs --dry-run --keep --depth= --shallow-since= --shallow-exclude= --deepen= --unshallow --update-shallow --refmap= --server-option= --ipv4 --ipv6 --negotiation-tip= --show-forced-updates --set-upstream --no-verbose -- --no-quiet --no-progress --no-recurse-submodules --no-rebase --no-stat --no-log --no-signoff --no-squash --no-commit --no-edit --no-cleanup --no-ff --no-verify-signatures --no-autostash --no-strategy --no-strategy-option --no-gpg-sign --no-allow-unrelated-histories --no-all --no-append --no-upload-pack --no-force --no-tags --no-prune --no-jobs --no-dry-run --no-keep --no-depth --no-shallow-since --no-shallow-exclude --no-deepen --no-update-shallow --no-server-option --no-ipv4 --no-ipv6 --no-negotiation-tip --no-show-forced-updates --no-set-upstream"
__gitcomp_builtin_push_default=" --verbose --quiet --repo= --all --mirror --delete --tags --dry-run --porcelain --force --force-with-lease --recurse-submodules= --receive-pack= --exec= --set-upstream --progress --prune --no-verify --follow-tags --signed --atomic --push-option= --ipv4 --ipv6 --verify -- --no-verbose --no-quiet --no-repo --no-all --no-mirror --no-delete --no-tags --no-dry-run --no-porcelain --no-force --no-force-with-lease --no-recurse-submodules --no-receive-pack --no-exec --no-set-upstream --no-progress --no-prune --no-follow-tags --no-signed --no-atomic --no-push-option --no-ipv4 --no-ipv6"
__gitcomp_builtin_range_diff_default=" --creation-factor= --no-dual-color --notes --patch --no-patch --unified --function-context --raw --patch-with-raw --patch-with-stat --numstat --shortstat --dirstat --cumulative --dirstat-by-file --check --summary --name-only --name-status --stat --stat-width= --stat-name-width= --stat-graph-width= --stat-count= --compact-summary --binary --full-index --color --ws-error-highlight= --abbrev --src-prefix= --dst-prefix= --line-prefix= --no-prefix --inter-hunk-context= --output-indicator-new= --output-indicator-old= --output-indicator-context= --break-rewrites --find-renames --irreversible-delete --find-copies --find-copies-harder --no-renames --rename-empty --follow --minimal --ignore-all-space --ignore-space-change --ignore-space-at-eol --ignore-cr-at-eol --ignore-blank-lines --indent-heuristic --patience --histogram --diff-algorithm= --anchored= --word-diff --word-diff-regex= --color-words --color-moved --color-moved-ws= --relative --text --exit-code --quiet --ext-diff --textconv --ignore-submodules --submodule --ita-invisible-in-index --ita-visible-in-index --pickaxe-all --pickaxe-regex --find-object= --diff-filter= --output= --dual-color -- --no-creation-factor --no-notes --no-function-context --no-compact-summary --no-full-index --no-color --no-abbrev --no-find-copies-harder --no-rename-empty --no-follow --no-minimal --no-indent-heuristic --no-color-moved --no-color-moved-ws --no-relative --no-text --no-exit-code --no-quiet --no-ext-diff --no-textconv"
__gitcomp_builtin_read_tree_default=" --index-output= --empty --verbose --trivial --aggressive --reset --prefix= --exclude-per-directory= --dry-run --no-sparse-checkout --debug-unpack --recurse-submodules --quiet --sparse-checkout -- --no-empty --no-verbose --no-trivial --no-aggressive --no-reset --no-dry-run --no-debug-unpack --no-recurse-submodules --no-quiet"
__gitcomp_builtin_rebase_default=" --onto= --keep-base --no-verify --quiet --verbose --no-stat --signoff --committer-date-is-author-date --reset-author-date --ignore-whitespace --whitespace= --force-rebase --no-ff --continue --skip --abort --quit --edit-todo --show-current-patch --apply --merge --interactive --rerere-autoupdate --empty= --autosquash --gpg-sign --autostash --exec= --rebase-merges --fork-point --strategy= --strategy-option= --root --reschedule-failed-exec --reapply-cherry-picks --verify --stat --ff -- --no-onto --no-keep-base --no-quiet --no-verbose --no-signoff --no-committer-date-is-author-date --no-reset-author-date --no-ignore-whitespace --no-whitespace --no-force-rebase --no-rerere-autoupdate --no-autosquash --no-gpg-sign --no-autostash --no-exec --no-rebase-merges --no-fork-point --no-strategy --no-strategy-option --no-root --no-reschedule-failed-exec --no-reapply-cherry-picks"
__gitcomp_builtin_rebase__interactive_default=" --ff --rebase-merges --rebase-cousins --autosquash --signoff --verbose --continue --skip --edit-todo --show-current-patch --shorten-ids --expand-ids --check-todo-list --rearrange-squash --add-exec-commands --onto= --restrict-revision= --squash-onto= --upstream= --head-name= --gpg-sign --strategy= --strategy-opts= --switch-to= --onto-name= --cmd= --rerere-autoupdate --reschedule-failed-exec --no-ff -- --no-rebase-merges --no-rebase-cousins --no-autosquash --no-signoff --no-verbose --no-head-name --no-gpg-sign --no-strategy --no-strategy-opts --no-switch-to --no-onto-name --no-cmd --no-rerere-autoupdate --no-reschedule-failed-exec"
__gitcomp_builtin_receive_pack_default=" --quiet --no-quiet"
__gitcomp_builtin_reflog_default=" --quiet --source --use-mailmap --mailmap --decorate-refs= --decorate-refs-exclude= --decorate --no-quiet -- --no-source --no-use-mailmap --no-mailmap --no-decorate-refs --no-decorate-refs-exclude --no-decorate"
__gitcomp_builtin_remote_default=" --verbose --no-verbose"
__gitcomp_builtin_repack_default=" --quiet --local --write-bitmap-index --delta-islands --unpack-unreachable= --keep-unreachable --window= --window-memory= --depth= --threads= --max-pack-size= --pack-kept-objects --keep-pack= --no-quiet -- --no-local --no-write-bitmap-index --no-delta-islands --no-unpack-unreachable --no-keep-unreachable --no-window --no-window-memory --no-depth --no-threads --no-max-pack-size --no-pack-kept-objects --no-keep-pack"
__gitcomp_builtin_replace_default=" --list --delete --edit --graft --convert-graft-file --raw --format= --no-raw -- --no-format"
__gitcomp_builtin_rerere_default=" --rerere-autoupdate --no-rerere-autoupdate"
__gitcomp_builtin_reset_default=" --quiet --mixed --soft --hard --merge --keep --recurse-submodules --patch --intent-to-add --pathspec-from-file= --pathspec-file-nul --no-quiet -- --no-mixed --no-soft --no-hard --no-merge --no-keep --no-recurse-submodules --no-patch --no-intent-to-add --no-pathspec-from-file --no-pathspec-file-nul"
__gitcomp_builtin_restore_default=" --source= --staged --worktree --ignore-unmerged --overlay --quiet --recurse-submodules --progress --merge --conflict= --ours --theirs --patch --ignore-skip-worktree-bits --pathspec-from-file= --pathspec-file-nul --no-source -- --no-staged --no-worktree --no-ignore-unmerged --no-overlay --no-quiet --no-recurse-submodules --no-progress --no-merge --no-conflict --no-patch --no-ignore-skip-worktree-bits --no-pathspec-from-file --no-pathspec-file-nul"
__gitcomp_builtin_revert_default=" --quit --continue --abort --skip --cleanup= --no-commit --edit --signoff --mainline= --rerere-autoupdate --strategy= --strategy-option= --gpg-sign --commit -- --no-cleanup --no-edit --no-signoff --no-mainline --no-rerere-autoupdate --no-strategy --no-strategy-option --no-gpg-sign"
__gitcomp_builtin_rm_default=" --dry-run --quiet --cached --ignore-unmatch --pathspec-from-file= --pathspec-file-nul --no-dry-run -- --no-quiet --no-cached --no-ignore-unmatch --no-pathspec-from-file --no-pathspec-file-nul"
__gitcomp_builtin_send_pack_default=" --verbose --quiet --receive-pack= --exec= --remote= --all --dry-run --mirror --force --signed --push-option= --progress --thin --atomic --stateless-rpc --stdin --helper-status --force-with-lease --no-verbose -- --no-quiet --no-receive-pack --no-exec --no-remote --no-all --no-dry-run --no-mirror --no-force --no-signed --no-push-option --no-progress --no-thin --no-atomic --no-stateless-rpc --no-stdin --no-helper-status --no-force-with-lease"
__gitcomp_builtin_shortlog_default=" --committer --numbered --summary --email --group= --no-committer -- --no-numbered --no-summary --no-email --no-group"
__gitcomp_builtin_show_default=" --quiet --source --use-mailmap --mailmap --decorate-refs= --decorate-refs-exclude= --decorate --no-quiet -- --no-source --no-use-mailmap --no-mailmap --no-decorate-refs --no-decorate-refs-exclude --no-decorate"
__gitcomp_builtin_show_branch_default=" --all --remotes --color --more --list --no-name --current --sha1-name --merge-base --independent --topo-order --topics --sparse --date-order --reflog --name -- --no-all --no-remotes --no-color --no-more --no-list --no-current --no-sha1-name --no-merge-base --no-independent --no-topo-order --no-topics --no-sparse --no-date-order"
__gitcomp_builtin_show_index_default=" --object-format= --no-object-format"
__gitcomp_builtin_show_ref_default=" --tags --heads --verify --head --dereference --hash --abbrev --quiet --exclude-existing --no-tags -- --no-heads --no-verify --no-head --no-dereference --no-hash --no-abbrev --no-quiet"
__gitcomp_builtin_sparse_checkout_default=""
__gitcomp_builtin_stage_default=" --dry-run --verbose --interactive --patch --edit --force --update --renormalize --intent-to-add --all --ignore-removal --refresh --ignore-errors --ignore-missing --chmod= --pathspec-from-file= --pathspec-file-nul --no-dry-run -- --no-verbose --no-interactive --no-patch --no-edit --no-force --no-update --no-renormalize --no-intent-to-add --no-all --no-ignore-removal --no-refresh --no-ignore-errors --no-ignore-missing --no-chmod --no-pathspec-from-file --no-pathspec-file-nul"
__gitcomp_builtin_stash_default=""
__gitcomp_builtin_status_default=" --verbose --short --branch --show-stash --ahead-behind --porcelain --long --null --untracked-files --ignored --ignore-submodules --column --no-renames --find-renames --renames -- --no-verbose --no-short --no-branch --no-show-stash --no-ahead-behind --no-porcelain --no-long --no-null --no-untracked-files --no-ignored --no-ignore-submodules --no-column"
__gitcomp_builtin_stripspace_default=" --strip-comments --comment-lines"
__gitcomp_builtin_switch_default=" --create= --force-create= --guess --discard-changes --quiet --recurse-submodules --progress --merge --conflict= --detach --track --orphan= --ignore-other-worktrees --no-create -- --no-force-create --no-guess --no-discard-changes --no-quiet --no-recurse-submodules --no-progress --no-merge --no-conflict --no-detach --no-track --no-orphan --no-ignore-other-worktrees"
__gitcomp_builtin_symbolic_ref_default=" --quiet --delete --short --no-quiet -- --no-delete --no-short"
__gitcomp_builtin_tag_default=" --list --delete --verify --annotate --message= --file= --edit --sign --cleanup= --local-user= --force --create-reflog --column --contains --no-contains --merged --no-merged --sort= --points-at --format= --color --ignore-case -- --no-annotate --no-file --no-edit --no-sign --no-cleanup --no-local-user --no-force --no-create-reflog --no-column --no-points-at --no-format --no-color --no-ignore-case"
__gitcomp_builtin_update_index_default=" --ignore-submodules --add --replace --remove --unmerged --refresh --really-refresh --cacheinfo --chmod= --assume-unchanged --no-assume-unchanged --skip-worktree --no-skip-worktree --ignore-skip-worktree-entries --info-only --force-remove --stdin --index-info --unresolve --again --ignore-missing --verbose --clear-resolve-undo --index-version= --split-index --untracked-cache --test-untracked-cache --force-untracked-cache --force-write-index --fsmonitor --fsmonitor-valid --no-fsmonitor-valid -- --no-ignore-submodules --no-add --no-replace --no-remove --no-unmerged --no-ignore-skip-worktree-entries --no-info-only --no-force-remove --no-ignore-missing --no-verbose --no-index-version --no-split-index --no-untracked-cache --no-test-untracked-cache --no-force-untracked-cache --no-force-write-index --no-fsmonitor"
__gitcomp_builtin_update_ref_default=" --no-deref --stdin --create-reflog --deref -- --no-stdin --no-create-reflog"
__gitcomp_builtin_update_server_info_default=" --force --no-force"
__gitcomp_builtin_upload_pack_default=" --stateless-rpc --advertise-refs --strict --timeout= --no-stateless-rpc -- --no-advertise-refs --no-strict --no-timeout"
__gitcomp_builtin_verify_commit_default=" --verbose --raw --no-verbose -- --no-raw"
__gitcomp_builtin_verify_pack_default=" --verbose --stat-only --object-format= --no-verbose -- --no-stat-only --no-object-format"
__gitcomp_builtin_verify_tag_default=" --verbose --raw --format= --no-verbose -- --no-raw --no-format"
__gitcomp_builtin_version_default=" --build-options --no-build-options"
__gitcomp_builtin_whatchanged_default=" --quiet --source --use-mailmap --mailmap --decorate-refs= --decorate-refs-exclude= --decorate --no-quiet -- --no-source --no-use-mailmap --no-mailmap --no-decorate-refs --no-decorate-refs-exclude --no-decorate"
__gitcomp_builtin_write_tree_default=" --missing-ok --prefix= --no-missing-ok -- --no-prefix"
__gitcomp_builtin_send_email_default=" --numbered --no-numbered --signoff --stdout --cover-letter --numbered-files --suffix= --start-number= --reroll-count= --rfc --cover-from-description= --subject-prefix= --output-directory= --keep-subject --no-binary --zero-commit --ignore-if-in-upstream --no-stat --add-header= --to= --cc= --from --in-reply-to= --attach --inline --thread --signature= --base= --signature-file= --quiet --progress --interdiff= --range-diff= --creation-factor= --binary -- --no-numbered --no-signoff --no-stdout --no-cover-letter --no-numbered-files --no-suffix --no-start-number --no-reroll-count --no-cover-from-description --no-zero-commit --no-ignore-if-in-upstream --no-add-header --no-to --no-cc --no-from --no-in-reply-to --no-attach --no-thread --no-signature --no-base --no-signature-file --no-quiet --no-progress --no-interdiff --no-range-diff --no-creation-factor"

__gitcomp_builtin_get_default ()
{
	eval "test -n \"\$${1}_default\" && echo \"\$${1}_default\""
}

# This function is equivalent to
#
#    __gitcomp "$(git xxx --git-completion-helper) ..."
#
# except that the output is cached. Accept 1-3 arguments:
# 1: the git command to execute, this is also the cache key
# 2: extra options to be added on top (e.g. negative forms)
# 3: options to be excluded
__gitcomp_builtin ()
{
	# spaces must be replaced with underscore for multi-word
	# commands, e.g. "git remote add" becomes remote_add.
	local cmd="$1"
	local incl="${2-}"
	local excl="${3-}"

	local var=__gitcomp_builtin_"${cmd//-/_}"
	local options
	eval "options=\${$var-}"

	if [ -z "$options" ]; then
		local completion_helper
		if [ "$GIT_COMPLETION_SHOW_ALL" = "1" ]; then
			completion_helper="--git-completion-helper-all"
		else
			completion_helper="--git-completion-helper"
		fi
		completion="$(__git ${cmd/_/ } $completion_helper ||
			__gitcomp_builtin_get_default $var)" || return
		# leading and trailing spaces are significant to make
		# option removal work correctly.
		options=" $incl $completion "

		for i in $excl; do
			options="${options/ $i / }"
		done
		eval "$var=\"$options\""
	fi

	__gitcomp "$options"
}

# Variation of __gitcomp_nl () that appends to the existing list of
# completion candidates, COMPREPLY.
__gitcomp_nl_append ()
{
	local IFS=$'\n'
	__gitcompappend "$1" "${2-}" "${3-$cur}" "${4- }"
}

# Generates completion reply from newline-separated possible completion words
# by appending a space to all of them.
# It accepts 1 to 4 arguments:
# 1: List of possible completion words, separated by a single newline.
# 2: A prefix to be added to each possible completion word (optional).
# 3: Generate possible completion matches for this word (optional).
# 4: A suffix to be appended to each possible completion word instead of
#    the default space (optional).  If specified but empty, nothing is
#    appended.
__gitcomp_nl ()
{
	COMPREPLY=()
	__gitcomp_nl_append "$@"
}

# Fills the COMPREPLY array with prefiltered paths without any additional
# processing.
# Callers must take care of providing only paths that match the current path
# to be completed and adding any prefix path components, if necessary.
# 1: List of newline-separated matching paths, complete with all prefix
#    path components.
__gitcomp_file_direct ()
{
	local IFS=$'\n'

	COMPREPLY=($1)

	# use a hack to enable file mode in bash < 4
	compopt -o filenames +o nospace 2>/dev/null ||
	compgen -f /non-existing-dir/ >/dev/null ||
	true
}

# Generates completion reply with compgen from newline-separated possible
# completion filenames.
# It accepts 1 to 3 arguments:
# 1: List of possible completion filenames, separated by a single newline.
# 2: A directory prefix to be added to each possible completion filename
#    (optional).
# 3: Generate possible completion matches for this word (optional).
__gitcomp_file ()
{
	local IFS=$'\n'

	# XXX does not work when the directory prefix contains a tilde,
	# since tilde expansion is not applied.
	# This means that COMPREPLY will be empty and Bash default
	# completion will be used.
	__gitcompadd "$1" "${2-}" "${3-$cur}" ""

	# use a hack to enable file mode in bash < 4
	compopt -o filenames +o nospace 2>/dev/null ||
	compgen -f /non-existing-dir/ >/dev/null ||
	true
}

# Execute 'git ls-files', unless the --committable option is specified, in
# which case it runs 'git diff-index' to find out the files that can be
# committed.  It return paths relative to the directory specified in the first
# argument, and using the options specified in the second argument.
__git_ls_files_helper ()
{
	if [ "$2" == "--committable" ]; then
		__git -C "$1" -c core.quotePath=false diff-index \
			--name-only --relative HEAD -- "${3//\\/\\\\}*"
	else
		# NOTE: $2 is not quoted in order to support multiple options
		__git -C "$1" -c core.quotePath=false ls-files \
			--exclude-standard $2 -- "${3//\\/\\\\}*"
	fi
}


# __git_index_files accepts 1 or 2 arguments:
# 1: Options to pass to ls-files (required).
# 2: A directory path (optional).
#    If provided, only files within the specified directory are listed.
#    Sub directories are never recursed.  Path must have a trailing
#    slash.
# 3: List only paths matching this path component (optional).
__git_index_files ()
{
	local root="$2" match="$3"

	__git_ls_files_helper "$root" "$1" "${match:-?}" |
	awk -F / -v pfx="${2//\\/\\\\}" '{
		paths[$1] = 1
	}
	END {
		for (p in paths) {
			if (substr(p, 1, 1) != "\"") {
				# No special characters, easy!
				print pfx p
				continue
			}

			# The path is quoted.
			p = dequote(p)
			if (p == "")
				continue

			# Even when a directory name itself does not contain
			# any special characters, it will still be quoted if
			# any of its (stripped) trailing path components do.
			# Because of this we may have seen the same directory
			# both quoted and unquoted.
			if (p in paths)
				# We have seen the same directory unquoted,
				# skip it.
				continue
			else
				print pfx p
		}
	}
	function dequote(p,    bs_idx, out, esc, esc_idx, dec) {
		# Skip opening double quote.
		p = substr(p, 2)

		# Interpret backslash escape sequences.
		while ((bs_idx = index(p, "\\")) != 0) {
			out = out substr(p, 1, bs_idx - 1)
			esc = substr(p, bs_idx + 1, 1)
			p = substr(p, bs_idx + 2)

			if ((esc_idx = index("abtvfr\"\\", esc)) != 0) {
				# C-style one-character escape sequence.
				out = out substr("\a\b\t\v\f\r\"\\",
						 esc_idx, 1)
			} else if (esc == "n") {
				# Uh-oh, a newline character.
				# We cannot reliably put a pathname
				# containing a newline into COMPREPLY,
				# and the newline would create a mess.
				# Skip this path.
				return ""
			} else {
				# Must be a \nnn octal value, then.
				dec = esc             * 64 + \
				      substr(p, 1, 1) * 8  + \
				      substr(p, 2, 1)
				out = out sprintf("%c", dec)
				p = substr(p, 3)
			}
		}
		# Drop closing double quote, if there is one.
		# (There is not any if this is a directory, as it was
		# already stripped with the trailing path components.)
		if (substr(p, length(p), 1) == "\"")
			out = out substr(p, 1, length(p) - 1)
		else
			out = out p

		return out
	}'
}

# __git_complete_index_file requires 1 argument:
# 1: the options to pass to ls-file
#
# The exception is --committable, which finds the files appropriate commit.
__git_complete_index_file ()
{
	local dequoted_word pfx="" cur_

	__git_dequote "$cur"

	case "$dequoted_word" in
	?*/*)
		pfx="${dequoted_word%/*}/"
		cur_="${dequoted_word##*/}"
		;;
	*)
		cur_="$dequoted_word"
	esac

	__gitcomp_file_direct "$(__git_index_files "$1" "$pfx" "$cur_")"
}

# Lists branches from the local repository.
# 1: A prefix to be added to each listed branch (optional).
# 2: List only branches matching this word (optional; list all branches if
#    unset or empty).
# 3: A suffix to be appended to each listed branch (optional).
__git_heads ()
{
	local pfx="${1-}" cur_="${2-}" sfx="${3-}"

	__git for-each-ref --format="${pfx//\%/%%}%(refname:strip=2)$sfx" \
			"refs/heads/$cur_*" "refs/heads/$cur_*/**"
}

# Lists branches from remote repositories.
# 1: A prefix to be added to each listed branch (optional).
# 2: List only branches matching this word (optional; list all branches if
#    unset or empty).
# 3: A suffix to be appended to each listed branch (optional).
__git_remote_heads ()
{
	local pfx="${1-}" cur_="${2-}" sfx="${3-}"

	__git for-each-ref --format="${pfx//\%/%%}%(refname:strip=2)$sfx" \
			"refs/remotes/$cur_*" "refs/remotes/$cur_*/**"
}

# Lists tags from the local repository.
# Accepts the same positional parameters as __git_heads() above.
__git_tags ()
{
	local pfx="${1-}" cur_="${2-}" sfx="${3-}"

	__git for-each-ref --format="${pfx//\%/%%}%(refname:strip=2)$sfx" \
			"refs/tags/$cur_*" "refs/tags/$cur_*/**"
}

# List unique branches from refs/remotes used for 'git checkout' and 'git
# switch' tracking DWIMery.
# 1: A prefix to be added to each listed branch (optional)
# 2: List only branches matching this word (optional; list all branches if
#    unset or empty).
# 3: A suffix to be appended to each listed branch (optional).
__git_dwim_remote_heads ()
{
	local pfx="${1-}" cur_="${2-}" sfx="${3-}"
	local fer_pfx="${pfx//\%/%%}" # "escape" for-each-ref format specifiers

	# employ the heuristic used by git checkout and git switch
	# Try to find a remote branch that cur_es the completion word
	# but only output if the branch name is unique
	__git for-each-ref --format="$fer_pfx%(refname:strip=3)$sfx" \
		--sort="refname:strip=3" \
		"refs/remotes/*/$cur_*" "refs/remotes/*/$cur_*/**" | \
	uniq -u
}

# Lists refs from the local (by default) or from a remote repository.
# It accepts 0, 1 or 2 arguments:
# 1: The remote to list refs from (optional; ignored, if set but empty).
#    Can be the name of a configured remote, a path, or a URL.
# 2: In addition to local refs, list unique branches from refs/remotes/ for
#    'git checkout's tracking DWIMery (optional; ignored, if set but empty).
# 3: A prefix to be added to each listed ref (optional).
# 4: List only refs matching this word (optional; list all refs if unset or
#    empty).
# 5: A suffix to be appended to each listed ref (optional; ignored, if set
#    but empty).
#
# Use __git_complete_refs() instead.
__git_refs ()
{
	local i hash dir track="${2-}"
	local list_refs_from=path remote="${1-}"
	local format refs
	local pfx="${3-}" cur_="${4-$cur}" sfx="${5-}"
	local match="${4-}"
	local fer_pfx="${pfx//\%/%%}" # "escape" for-each-ref format specifiers

	__git_find_repo_path
	dir="$__git_repo_path"

	if [ -z "$remote" ]; then
		if [ -z "$dir" ]; then
			return
		fi
	else
		if __git_is_configured_remote "$remote"; then
			# configured remote takes precedence over a
			# local directory with the same name
			list_refs_from=remote
		elif [ -d "$remote/.git" ]; then
			dir="$remote/.git"
		elif [ -d "$remote" ]; then
			dir="$remote"
		else
			list_refs_from=url
		fi
	fi

	if [ "$list_refs_from" = path ]; then
		if [[ "$cur_" == ^* ]]; then
			pfx="$pfx^"
			fer_pfx="$fer_pfx^"
			cur_=${cur_#^}
			match=${match#^}
		fi
		case "$cur_" in
		refs|refs/*)
			format="refname"
			refs=("$match*" "$match*/**")
			track=""
			;;
		*)
			for i in HEAD FETCH_HEAD ORIG_HEAD MERGE_HEAD REBASE_HEAD; do
				case "$i" in
				$match*)
					if [ -e "$dir/$i" ]; then
						echo "$pfx$i$sfx"
					fi
					;;
				esac
			done
			format="refname:strip=2"
			refs=("refs/tags/$match*" "refs/tags/$match*/**"
				"refs/heads/$match*" "refs/heads/$match*/**"
				"refs/remotes/$match*" "refs/remotes/$match*/**")
			;;
		esac
		__git_dir="$dir" __git for-each-ref --format="$fer_pfx%($format)$sfx" \
			"${refs[@]}"
		if [ -n "$track" ]; then
			__git_dwim_remote_heads "$pfx" "$match" "$sfx"
		fi
		return
	fi
	case "$cur_" in
	refs|refs/*)
		__git ls-remote "$remote" "$match*" | \
		while read -r hash i; do
			case "$i" in
			*^{}) ;;
			*) echo "$pfx$i$sfx" ;;
			esac
		done
		;;
	*)
		if [ "$list_refs_from" = remote ]; then
			case "HEAD" in
			$match*)	echo "${pfx}HEAD$sfx" ;;
			esac
			__git for-each-ref --format="$fer_pfx%(refname:strip=3)$sfx" \
				"refs/remotes/$remote/$match*" \
				"refs/remotes/$remote/$match*/**"
		else
			local query_symref
			case "HEAD" in
			$match*)	query_symref="HEAD" ;;
			esac
			__git ls-remote "$remote" $query_symref \
				"refs/tags/$match*" "refs/heads/$match*" \
				"refs/remotes/$match*" |
			while read -r hash i; do
				case "$i" in
				*^{})	;;
				refs/*)	echo "$pfx${i#refs/*/}$sfx" ;;
				*)	echo "$pfx$i$sfx" ;;  # symbolic refs
				esac
			done
		fi
		;;
	esac
}

# Completes refs, short and long, local and remote, symbolic and pseudo.
#
# Usage: __git_complete_refs [<option>]...
# --remote=<remote>: The remote to list refs from, can be the name of a
#                    configured remote, a path, or a URL.
# --dwim: List unique remote branches for 'git switch's tracking DWIMery.
# --pfx=<prefix>: A prefix to be added to each ref.
# --cur=<word>: The current ref to be completed.  Defaults to the current
#               word to be completed.
# --sfx=<suffix>: A suffix to be appended to each ref instead of the default
#                 space.
# --mode=<mode>: What set of refs to complete, one of 'refs' (the default) to
#                complete all refs, 'heads' to complete only branches, or
#                'remote-heads' to complete only remote branches. Note that
#                --remote is only compatible with --mode=refs.
__git_complete_refs ()
{
	local remote= dwim= pfx= cur_="$cur" sfx=" " mode="refs"

	while test $# != 0; do
		case "$1" in
		--remote=*)	remote="${1##--remote=}" ;;
		--dwim)		dwim="yes" ;;
		# --track is an old spelling of --dwim
		--track)	dwim="yes" ;;
		--pfx=*)	pfx="${1##--pfx=}" ;;
		--cur=*)	cur_="${1##--cur=}" ;;
		--sfx=*)	sfx="${1##--sfx=}" ;;
		--mode=*)	mode="${1##--mode=}" ;;
		*)		return 1 ;;
		esac
		shift
	done

	# complete references based on the specified mode
	case "$mode" in
		refs)
			__gitcomp_direct "$(__git_refs "$remote" "" "$pfx" "$cur_" "$sfx")" ;;
		heads)
			__gitcomp_direct "$(__git_heads "$pfx" "$cur_" "$sfx")" ;;
		remote-heads)
			__gitcomp_direct "$(__git_remote_heads "$pfx" "$cur_" "$sfx")" ;;
		*)
			return 1 ;;
	esac

	# Append DWIM remote branch names if requested
	if [ "$dwim" = "yes" ]; then
		__gitcomp_direct_append "$(__git_dwim_remote_heads "$pfx" "$cur_" "$sfx")"
	fi
}

# __git_refs2 requires 1 argument (to pass to __git_refs)
# Deprecated: use __git_complete_fetch_refspecs() instead.
__git_refs2 ()
{
	local i
	for i in $(__git_refs "$1"); do
		echo "$i:$i"
	done
}

# Completes refspecs for fetching from a remote repository.
# 1: The remote repository.
# 2: A prefix to be added to each listed refspec (optional).
# 3: The ref to be completed as a refspec instead of the current word to be
#    completed (optional)
# 4: A suffix to be appended to each listed refspec instead of the default
#    space (optional).
__git_complete_fetch_refspecs ()
{
	local i remote="$1" pfx="${2-}" cur_="${3-$cur}" sfx="${4- }"

	__gitcomp_direct "$(
		for i in $(__git_refs "$remote" "" "" "$cur_") ; do
			echo "$pfx$i:$i$sfx"
		done
		)"
}

# __git_refs_remotes requires 1 argument (to pass to ls-remote)
__git_refs_remotes ()
{
	local i hash
	__git ls-remote "$1" 'refs/heads/*' | \
	while read -r hash i; do
		echo "$i:refs/remotes/$1/${i#refs/heads/}"
	done
}

__git_remotes ()
{
	__git_find_repo_path
	test -d "$__git_repo_path/remotes" && ls -1 "$__git_repo_path/remotes"
	__git remote
}

# Returns true if $1 matches the name of a configured remote, false otherwise.
__git_is_configured_remote ()
{
	local remote
	for remote in $(__git_remotes); do
		if [ "$remote" = "$1" ]; then
			return 0
		fi
	done
	return 1
}

__git_list_merge_strategies ()
{
	LANG=C LC_ALL=C git merge -s help 2>&1 |
	sed -n -e '/[Aa]vailable strategies are: /,/^$/{
		s/\.$//
		s/.*://
		s/^[ 	]*//
		s/[ 	]*$//
		p
	}'
}

__git_merge_strategies_default='octopus ours recursive resolve subtree'
__git_merge_strategies=
# 'git merge -s help' (and thus detection of the merge strategy
# list) fails, unfortunately, if run outside of any git working
# tree.  __git_merge_strategies is set to the empty string in
# that case, and the detection will be repeated the next time it
# is needed.
__git_compute_merge_strategies ()
{
	test -n "$__git_merge_strategies" ||
	{ __git_merge_strategies=$(__git_list_merge_strategies);
		__git_merge_strategies="${__git_merge_strategies:-__git_merge_strategies_default}"; }
}

__git_merge_strategy_options="ours theirs subtree subtree= patience
	histogram diff-algorithm= ignore-space-change ignore-all-space
	ignore-space-at-eol renormalize no-renormalize no-renames
	find-renames find-renames= rename-threshold="

__git_complete_revlist_file ()
{
	local dequoted_word pfx ls ref cur_="$cur"
	case "$cur_" in
	*..?*:*)
		return
		;;
	?*:*)
		ref="${cur_%%:*}"
		cur_="${cur_#*:}"

		__git_dequote "$cur_"

		case "$dequoted_word" in
		?*/*)
			pfx="${dequoted_word%/*}"
			cur_="${dequoted_word##*/}"
			ls="$ref:$pfx"
			pfx="$pfx/"
			;;
		*)
			cur_="$dequoted_word"
			ls="$ref"
			;;
		esac

		case "$COMP_WORDBREAKS" in
		*:*) : great ;;
		*)   pfx="$ref:$pfx" ;;
		esac

		__gitcomp_file "$(__git ls-tree "$ls" \
				| sed 's/^.*	//
				       s/$//')" \
			"$pfx" "$cur_"
		;;
	*...*)
		pfx="${cur_%...*}..."
		cur_="${cur_#*...}"
		__git_complete_refs --pfx="$pfx" --cur="$cur_"
		;;
	*..*)
		pfx="${cur_%..*}.."
		cur_="${cur_#*..}"
		__git_complete_refs --pfx="$pfx" --cur="$cur_"
		;;
	*)
		__git_complete_refs
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
		-d|--delete) [ "$cmd" = "push" ] && lhs=0 ;;
		--all)
			case "$cmd" in
			push) no_complete_refspec=1 ;;
			fetch)
				return
				;;
			*) ;;
			esac
			;;
		--multiple) no_complete_refspec=1; break ;;
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
			__git_complete_fetch_refspecs "$remote" "$pfx" "$cur_"
		else
			__git_complete_refs --pfx="$pfx" --cur="$cur_"
		fi
		;;
	pull|remote)
		if [ $lhs = 1 ]; then
			__git_complete_refs --remote="$remote" --pfx="$pfx" --cur="$cur_"
		else
			__git_complete_refs --pfx="$pfx" --cur="$cur_"
		fi
		;;
	push)
		if [ $lhs = 1 ]; then
			__git_complete_refs --pfx="$pfx" --cur="$cur_"
		else
			__git_complete_refs --remote="$remote" --pfx="$pfx" --cur="$cur_"
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
		;;
	-X)
		__gitcomp "$__git_merge_strategy_options"
		return 0
		;;
	esac
	case "$cur" in
	--strategy=*)
		__gitcomp "$__git_merge_strategies" "" "${cur##--strategy=}"
		return 0
		;;
	--strategy-option=*)
		__gitcomp "$__git_merge_strategy_options" "" "${cur##--strategy-option=}"
		return 0
		;;
	esac
	return 1
}

__git_all_commands=
__git_compute_all_commands ()
{
	test -n "$__git_all_commands" ||
	__git_all_commands=$(__git --list-cmds=main,others,alias,nohelpers)
}

# Lists all set config variables starting with the given section prefix,
# with the prefix removed.
__git_get_config_variables ()
{
	local section="$1" i IFS=$'\n'
	for i in $(__git config --name-only --get-regexp "^$section\..*"); do
		echo "${i#$section.}"
	done
}

__git_pretty_aliases ()
{
	__git_get_config_variables "pretty"
}

# __git_aliased_command requires 1 argument
__git_aliased_command ()
{
	local cur=$1 last list word cmdline

	while [[ -n "$cur" ]]; do
		if [[ "$list" == *" $cur "* ]]; then
			# loop detected
			return
		fi

		cmdline=$(__git config --get "alias.$cur")
		list=" $cur $list"
		last=$cur
		cur=

		for word in $cmdline; do
			case "$word" in
			\!gitk|gitk)
				cur="gitk"
				break
				;;
			\!*)	: shell command alias ;;
			-*)	: option ;;
			*=*)	: setting env ;;
			git)	: git itself ;;
			\(\))   : skip parens of shell function definition ;;
			{)	: skip start of shell helper function ;;
			:)	: skip null command ;;
			\'*)	: skip opening quote after sh -c ;;
			*)
				cur="$word"
				break
			esac
		done
	done

	cur=$last
	if [[ "$cur" != "$1" ]]; then
		echo "$cur"
	fi
}

# Check whether one of the given words is present on the command line,
# and print the first word found.
#
# Usage: __git_find_on_cmdline [<option>]... "<wordlist>"
# --show-idx: Optionally show the index of the found word in the $words array.
__git_find_on_cmdline ()
{
	local word c=1 show_idx

	while test $# -gt 1; do
		case "$1" in
		--show-idx)	show_idx=y ;;
		*)		return 1 ;;
		esac
		shift
	done
	local wordlist="$1"

	while [ $c -lt $cword ]; do
		for word in $wordlist; do
			if [ "$word" = "${words[c]}" ]; then
				if [ -n "${show_idx-}" ]; then
					echo "$c $word"
				else
					echo "$word"
				fi
				return
			fi
		done
		((c++))
	done
}

# Similar to __git_find_on_cmdline, except that it loops backwards and thus
# prints the *last* word found. Useful for finding which of two options that
# supersede each other came last, such as "--guess" and "--no-guess".
#
# Usage: __git_find_last_on_cmdline [<option>]... "<wordlist>"
# --show-idx: Optionally show the index of the found word in the $words array.
__git_find_last_on_cmdline ()
{
	local word c=$cword show_idx

	while test $# -gt 1; do
		case "$1" in
		--show-idx)	show_idx=y ;;
		*)		return 1 ;;
		esac
		shift
	done
	local wordlist="$1"

	while [ $c -gt 1 ]; do
		((c--))
		for word in $wordlist; do
			if [ "$word" = "${words[c]}" ]; then
				if [ -n "$show_idx" ]; then
					echo "$c $word"
				else
					echo "$word"
				fi
				return
			fi
		done
	done
}

# Echo the value of an option set on the command line or config
#
# $1: short option name
# $2: long option name including =
# $3: list of possible values
# $4: config string (optional)
#
# example:
# result="$(__git_get_option_value "-d" "--do-something=" \
#     "yes no" "core.doSomething")"
#
# result is then either empty (no option set) or "yes" or "no"
#
# __git_get_option_value requires 3 arguments
__git_get_option_value ()
{
	local c short_opt long_opt val
	local result= values config_key word

	short_opt="$1"
	long_opt="$2"
	values="$3"
	config_key="$4"

	((c = $cword - 1))
	while [ $c -ge 0 ]; do
		word="${words[c]}"
		for val in $values; do
			if [ "$short_opt$val" = "$word" ] ||
			   [ "$long_opt$val"  = "$word" ]; then
				result="$val"
				break 2
			fi
		done
		((c--))
	done

	if [ -n "$config_key" ] && [ -z "$result" ]; then
		result="$(__git config "$config_key")"
	fi

	echo "$result"
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

# Try to count non option arguments passed on the command line for the
# specified git command.
# When options are used, it is necessary to use the special -- option to
# tell the implementation were non option arguments begin.
# XXX this can not be improved, since options can appear everywhere, as
# an example:
#	git mv x -n y
#
# __git_count_arguments requires 1 argument: the git command executed.
__git_count_arguments ()
{
	local word i c=0

	# Skip "git" (first argument)
	for ((i=1; i < ${#words[@]}; i++)); do
		word="${words[i]}"

		case "$word" in
			--)
				# Good; we can assume that the following are only non
				# option arguments.
				((c = 0))
				;;
			"$1")
				# Skip the specified git command and discard git
				# main options
				((c = 0))
				;;
			?*)
				((c++))
				;;
		esac
	done

	printf "%d" $c
}

__git_whitespacelist="nowarn warn error error-all fix"
__git_patchformat="mbox stgit stgit-series hg mboxrd"
__git_showcurrentpatch="diff raw"
__git_am_inprogress_options="--skip --continue --resolved --abort --quit --show-current-patch"

_git_am ()
{
	__git_find_repo_path
	if [ -d "$__git_repo_path"/rebase-apply ]; then
		__gitcomp "$__git_am_inprogress_options"
		return
	fi
	case "$cur" in
	--whitespace=*)
		__gitcomp "$__git_whitespacelist" "" "${cur##--whitespace=}"
		return
		;;
	--patch-format=*)
		__gitcomp "$__git_patchformat" "" "${cur##--patch-format=}"
		return
		;;
	--show-current-patch=*)
		__gitcomp "$__git_showcurrentpatch" "" "${cur##--show-current-patch=}"
		return
		;;
	--*)
		__gitcomp_builtin am "" \
			"$__git_am_inprogress_options"
		return
	esac
}

_git_apply ()
{
	case "$cur" in
	--whitespace=*)
		__gitcomp "$__git_whitespacelist" "" "${cur##--whitespace=}"
		return
		;;
	--*)
		__gitcomp_builtin apply
		return
	esac
}

_git_add ()
{
	case "$cur" in
	--chmod=*)
		__gitcomp "+x -x" "" "${cur##--chmod=}"
		return
		;;
	--*)
		__gitcomp_builtin add
		return
	esac

	local complete_opt="--others --modified --directory --no-empty-directory"
	if test -n "$(__git_find_on_cmdline "-u --update")"
	then
		complete_opt="--modified"
	fi
	__git_complete_index_file "$complete_opt"
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
		__gitcomp_builtin archive "--format= --list --verbose --prefix= --worktree-attributes"
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
		__git_find_repo_path
		if [ -f "$__git_repo_path"/BISECT_START ]; then
			__gitcomp "$subcommands"
		else
			__gitcomp "replay start"
		fi
		return
	fi

	case "$subcommand" in
	bad|good|reset|skip|start)
		__git_complete_refs
		;;
	*)
		;;
	esac
}

__git_ref_fieldlist="refname objecttype objectsize objectname upstream push HEAD symref"

_git_branch ()
{
	local i c=1 only_local_ref="n" has_r="n"

	while [ $c -lt $cword ]; do
		i="${words[c]}"
		case "$i" in
		-d|--delete|-m|--move)	only_local_ref="y" ;;
		-r|--remotes)		has_r="y" ;;
		esac
		((c++))
	done

	case "$cur" in
	--set-upstream-to=*)
		__git_complete_refs --cur="${cur##--set-upstream-to=}"
		;;
	--*)
		__gitcomp_builtin branch
		;;
	*)
		if [ $only_local_ref = "y" -a $has_r = "n" ]; then
			__gitcomp_direct "$(__git_heads "" "$cur" " ")"
		else
			__git_complete_refs
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

# Helper function to decide whether or not we should enable DWIM logic for
# git-switch and git-checkout.
#
# To decide between the following rules in priority order
# 1) the last provided of "--guess" or "--no-guess" explicitly enable or
#    disable completion of DWIM logic respectively.
# 2) If the --no-track option is provided, take this as a hint to disable the
#    DWIM completion logic
# 3) If GIT_COMPLETION_CHECKOUT_NO_GUESS is set, disable the DWIM completion
#    logic, as requested by the user.
# 4) Enable DWIM logic otherwise.
#
__git_checkout_default_dwim_mode ()
{
	local last_option dwim_opt="--dwim"

	if [ "${GIT_COMPLETION_CHECKOUT_NO_GUESS-}" = "1" ]; then
		dwim_opt=""
	fi

	# --no-track disables DWIM, but with lower priority than
	# --guess/--no-guess
	if [ -n "$(__git_find_on_cmdline "--no-track")" ]; then
		dwim_opt=""
	fi

	# Find the last provided --guess or --no-guess
	last_option="$(__git_find_last_on_cmdline "--guess --no-guess")"
	case "$last_option" in
		--guess)
			dwim_opt="--dwim"
			;;
		--no-guess)
			dwim_opt=""
			;;
	esac

	echo "$dwim_opt"
}

_git_checkout ()
{
	__git_has_doubledash && return

	local dwim_opt="$(__git_checkout_default_dwim_mode)"

	case "$prev" in
	-b|-B|--orphan)
		# Complete local branches (and DWIM branch
		# remote branch names) for an option argument
		# specifying a new branch name. This is for
		# convenience, assuming new branches are
		# possibly based on pre-existing branch names.
		__git_complete_refs $dwim_opt --mode="heads"
		return
		;;
	*)
		;;
	esac

	case "$cur" in
	--conflict=*)
		__gitcomp "diff3 merge" "" "${cur##--conflict=}"
		;;
	--*)
		__gitcomp_builtin checkout
		;;
	*)
		# At this point, we've already handled special completion for
		# the arguments to -b/-B, and --orphan. There are 3 main
		# things left we can possibly complete:
		# 1) a start-point for -b/-B, -d/--detach, or --orphan
		# 2) a remote head, for --track
		# 3) an arbitrary reference, possibly including DWIM names
		#

		if [ -n "$(__git_find_on_cmdline "-b -B -d --detach --orphan")" ]; then
			__git_complete_refs --mode="refs"
		elif [ -n "$(__git_find_on_cmdline "--track")" ]; then
			__git_complete_refs --mode="remote-heads"
		else
			__git_complete_refs $dwim_opt --mode="refs"
		fi
		;;
	esac
}

__git_sequencer_inprogress_options="--continue --quit --abort --skip"

__git_cherry_pick_inprogress_options=$__git_sequencer_inprogress_options

_git_cherry_pick ()
{
	__git_find_repo_path
	if [ -f "$__git_repo_path"/CHERRY_PICK_HEAD ]; then
		__gitcomp "$__git_cherry_pick_inprogress_options"
		return
	fi

	__git_complete_strategy && return

	case "$cur" in
	--*)
		__gitcomp_builtin cherry-pick "" \
			"$__git_cherry_pick_inprogress_options"
		;;
	*)
		__git_complete_refs
		;;
	esac
}

_git_clean ()
{
	case "$cur" in
	--*)
		__gitcomp_builtin clean
		return
		;;
	esac

	# XXX should we check for -x option ?
	__git_complete_index_file "--others --directory"
}

_git_clone ()
{
	case "$prev" in
	-c|--config)
		__git_complete_config_variable_name_and_value
		return
		;;
	esac
	case "$cur" in
	--config=*)
		__git_complete_config_variable_name_and_value \
			--cur="${cur##--config=}"
		return
		;;
	--*)
		__gitcomp_builtin clone
		return
		;;
	esac
}

__git_untracked_file_modes="all no normal"

_git_commit ()
{
	case "$prev" in
	-c|-C)
		__git_complete_refs
		return
		;;
	esac

	case "$cur" in
	--cleanup=*)
		__gitcomp "default scissors strip verbatim whitespace
			" "" "${cur##--cleanup=}"
		return
		;;
	--reuse-message=*|--reedit-message=*|\
	--fixup=*|--squash=*)
		__git_complete_refs --cur="${cur#*=}"
		return
		;;
	--untracked-files=*)
		__gitcomp "$__git_untracked_file_modes" "" "${cur##--untracked-files=}"
		return
		;;
	--*)
		__gitcomp_builtin commit
		return
	esac

	if __git rev-parse --verify --quiet HEAD >/dev/null; then
		__git_complete_index_file "--committable"
	else
		# This is the first commit
		__git_complete_index_file "--cached"
	fi
}

_git_describe ()
{
	case "$cur" in
	--*)
		__gitcomp_builtin describe
		return
	esac
	__git_complete_refs
}

__git_diff_algorithms="myers minimal patience histogram"

__git_diff_submodule_formats="diff log short"

__git_color_moved_opts="no default plain blocks zebra dimmed-zebra"

__git_color_moved_ws_opts="no ignore-space-at-eol ignore-space-change
			ignore-all-space allow-indentation-change"

__git_diff_common_options="--stat --numstat --shortstat --summary
			--patch-with-stat --name-only --name-status --color
			--no-color --color-words --no-renames --check
			--color-moved --color-moved= --no-color-moved
			--color-moved-ws= --no-color-moved-ws
			--full-index --binary --abbrev --diff-filter=
			--find-copies-harder --ignore-cr-at-eol
			--text --ignore-space-at-eol --ignore-space-change
			--ignore-all-space --ignore-blank-lines --exit-code
			--quiet --ext-diff --no-ext-diff
			--no-prefix --src-prefix= --dst-prefix=
			--inter-hunk-context=
			--patience --histogram --minimal
			--raw --word-diff --word-diff-regex=
			--dirstat --dirstat= --dirstat-by-file
			--dirstat-by-file= --cumulative
			--diff-algorithm=
			--submodule --submodule= --ignore-submodules
			--indent-heuristic --no-indent-heuristic
			--textconv --no-textconv
"

_git_diff ()
{
	__git_has_doubledash && return

	case "$cur" in
	--diff-algorithm=*)
		__gitcomp "$__git_diff_algorithms" "" "${cur##--diff-algorithm=}"
		return
		;;
	--submodule=*)
		__gitcomp "$__git_diff_submodule_formats" "" "${cur##--submodule=}"
		return
		;;
	--color-moved=*)
		__gitcomp "$__git_color_moved_opts" "" "${cur##--color-moved=}"
		return
		;;
	--color-moved-ws=*)
		__gitcomp "$__git_color_moved_ws_opts" "" "${cur##--color-moved-ws=}"
		return
		;;
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

__git_mergetools_common="diffuse diffmerge ecmerge emerge kdiff3 meld opendiff
			tkdiff vimdiff nvimdiff gvimdiff xxdiff araxis p4merge
			bc codecompare smerge
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
		__gitcomp_builtin difftool "$__git_diff_common_options
					--base --cached --ours --theirs
					--pickaxe-all --pickaxe-regex
					--relative --staged
					"
		return
		;;
	esac
	__git_complete_revlist_file
}

__git_fetch_recurse_submodules="yes on-demand no"

_git_fetch ()
{
	case "$cur" in
	--recurse-submodules=*)
		__gitcomp "$__git_fetch_recurse_submodules" "" "${cur##--recurse-submodules=}"
		return
		;;
	--filter=*)
		__gitcomp "blob:none blob:limit= sparse:oid=" "" "${cur##--filter=}"
		return
		;;
	--*)
		__gitcomp_builtin fetch
		return
		;;
	esac
	__git_complete_remote_or_refspec
}

__git_format_patch_extra_options="
	--full-index --not --all --no-prefix --src-prefix=
	--dst-prefix= --notes
"

_git_format_patch ()
{
	case "$cur" in
	--thread=*)
		__gitcomp "
			deep shallow
			" "" "${cur##--thread=}"
		return
		;;
	--base=*|--interdiff=*|--range-diff=*)
		__git_complete_refs --cur="${cur#--*=}"
		return
		;;
	--*)
		__gitcomp_builtin format-patch "$__git_format_patch_extra_options"
		return
		;;
	esac
	__git_complete_revlist
}

_git_fsck ()
{
	case "$cur" in
	--*)
		__gitcomp_builtin fsck
		return
		;;
	esac
}

_git_gitk ()
{
	_gitk
}

# Lists matching symbol names from a tag (as in ctags) file.
# 1: List symbol names matching this word.
# 2: The tag file to list symbol names from.
# 3: A prefix to be added to each listed symbol name (optional).
# 4: A suffix to be appended to each listed symbol name (optional).
__git_match_ctag () {
	awk -v pfx="${3-}" -v sfx="${4-}" "
		/^${1//\//\\/}/ { print pfx \$1 sfx }
		" "$2"
}

# Complete symbol names from a tag file.
# Usage: __git_complete_symbol [<option>]...
# --tags=<file>: The tag file to list symbol names from instead of the
#                default "tags".
# --pfx=<prefix>: A prefix to be added to each symbol name.
# --cur=<word>: The current symbol name to be completed.  Defaults to
#               the current word to be completed.
# --sfx=<suffix>: A suffix to be appended to each symbol name instead
#                 of the default space.
__git_complete_symbol () {
	local tags=tags pfx="" cur_="${cur-}" sfx=" "

	while test $# != 0; do
		case "$1" in
		--tags=*)	tags="${1##--tags=}" ;;
		--pfx=*)	pfx="${1##--pfx=}" ;;
		--cur=*)	cur_="${1##--cur=}" ;;
		--sfx=*)	sfx="${1##--sfx=}" ;;
		*)		return 1 ;;
		esac
		shift
	done

	if test -r "$tags"; then
		__gitcomp_direct "$(__git_match_ctag "$cur_" "$tags" "$pfx" "$sfx")"
	fi
}

_git_grep ()
{
	__git_has_doubledash && return

	case "$cur" in
	--*)
		__gitcomp_builtin grep
		return
		;;
	esac

	case "$cword,$prev" in
	2,*|*,-*)
		__git_complete_symbol && return
		;;
	esac

	__git_complete_refs
}

_git_help ()
{
	case "$cur" in
	--*)
		__gitcomp_builtin help
		return
		;;
	esac
	if test -n "$GIT_TESTING_ALL_COMMAND_LIST"
	then
		__gitcomp "$GIT_TESTING_ALL_COMMAND_LIST $(__git --list-cmds=alias,list-guide) gitk"
	else
		__gitcomp "$(__git --list-cmds=main,nohelpers,alias,list-guide) gitk"
	fi
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
		__gitcomp_builtin init
		return
		;;
	esac
}

_git_ls_files ()
{
	case "$cur" in
	--*)
		__gitcomp_builtin ls-files
		return
		;;
	esac

	# XXX ignore options like --modified and always suggest all cached
	# files.
	__git_complete_index_file "--cached"
}

_git_ls_remote ()
{
	case "$cur" in
	--*)
		__gitcomp_builtin ls-remote
		return
		;;
	esac
	__gitcomp_nl "$(__git_remotes)"
}

_git_ls_tree ()
{
	case "$cur" in
	--*)
		__gitcomp_builtin ls-tree
		return
		;;
	esac

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
	--all-match --invert-grep
"

__git_log_pretty_formats="oneline short medium full fuller reference email raw format: tformat: mboxrd"
__git_log_date_formats="relative iso8601 iso8601-strict rfc2822 short local default raw unix format:"

_git_log ()
{
	__git_has_doubledash && return
	__git_find_repo_path

	local merge=""
	if [ -f "$__git_repo_path/MERGE_HEAD" ]; then
		merge="--merge"
	fi
	case "$prev,$cur" in
	-L,:*:*)
		return	# fall back to Bash filename completion
		;;
	-L,:*)
		__git_complete_symbol --cur="${cur#:}" --sfx=":"
		return
		;;
	-G,*|-S,*)
		__git_complete_symbol
		return
		;;
	esac
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
		__gitcomp "full short no" "" "${cur##--decorate=}"
		return
		;;
	--diff-algorithm=*)
		__gitcomp "$__git_diff_algorithms" "" "${cur##--diff-algorithm=}"
		return
		;;
	--submodule=*)
		__gitcomp "$__git_diff_submodule_formats" "" "${cur##--submodule=}"
		return
		;;
	--no-walk=*)
		__gitcomp "sorted unsorted" "" "${cur##--no-walk=}"
		return
		;;
	--*)
		__gitcomp "
			$__git_log_common_options
			$__git_log_shortlog_options
			$__git_log_gitk_options
			--root --topo-order --date-order --reverse
			--follow --full-diff
			--abbrev-commit --no-abbrev-commit --abbrev=
			--relative-date --date=
			--pretty= --format= --oneline
			--show-signature
			--cherry-mark
			--cherry-pick
			--graph
			--decorate --decorate= --no-decorate
			--walk-reflogs
			--no-walk --no-walk= --do-walk
			--parents --children
			--expand-tabs --expand-tabs= --no-expand-tabs
			--patch
			$merge
			$__git_diff_common_options
			--pickaxe-all --pickaxe-regex
			--patch --no-patch
			"
		return
		;;
	-L:*:*)
		return	# fall back to Bash filename completion
		;;
	-L:*)
		__git_complete_symbol --cur="${cur#-L:}" --sfx=":"
		return
		;;
	-G*)
		__git_complete_symbol --pfx="-G" --cur="${cur#-G}"
		return
		;;
	-S*)
		__git_complete_symbol --pfx="-S" --cur="${cur#-S}"
		return
		;;
	esac
	__git_complete_revlist
}

_git_merge ()
{
	__git_complete_strategy && return

	case "$cur" in
	--*)
		__gitcomp_builtin merge
		return
	esac
	__git_complete_refs
}

_git_mergetool ()
{
	case "$cur" in
	--tool=*)
		__gitcomp "$__git_mergetools_common tortoisemerge" "" "${cur##--tool=}"
		return
		;;
	--*)
		__gitcomp "--tool= --prompt --no-prompt --gui --no-gui"
		return
		;;
	esac
}

_git_merge_base ()
{
	case "$cur" in
	--*)
		__gitcomp_builtin merge-base
		return
		;;
	esac
	__git_complete_refs
}

_git_mv ()
{
	case "$cur" in
	--*)
		__gitcomp_builtin mv
		return
		;;
	esac

	if [ $(__git_count_arguments "mv") -gt 0 ]; then
		# We need to show both cached and untracked files (including
		# empty directories) since this may not be the last argument.
		__git_complete_index_file "--cached --others --directory"
	else
		__git_complete_index_file "--cached"
	fi
}

_git_notes ()
{
	local subcommands='add append copy edit get-ref list merge prune remove show'
	local subcommand="$(__git_find_on_cmdline "$subcommands")"

	case "$subcommand,$cur" in
	,--*)
		__gitcomp_builtin notes
		;;
	,*)
		case "$prev" in
		--ref)
			__git_complete_refs
			;;
		*)
			__gitcomp "$subcommands --ref"
			;;
		esac
		;;
	*,--reuse-message=*|*,--reedit-message=*)
		__git_complete_refs --cur="${cur#*=}"
		;;
	*,--*)
		__gitcomp_builtin notes_$subcommand
		;;
	prune,*|get-ref,*)
		# this command does not take a ref, do not complete it
		;;
	*)
		case "$prev" in
		-m|-F)
			;;
		*)
			__git_complete_refs
			;;
		esac
		;;
	esac
}

_git_pull ()
{
	__git_complete_strategy && return

	case "$cur" in
	--recurse-submodules=*)
		__gitcomp "$__git_fetch_recurse_submodules" "" "${cur##--recurse-submodules=}"
		return
		;;
	--*)
		__gitcomp_builtin pull

		return
		;;
	esac
	__git_complete_remote_or_refspec
}

__git_push_recurse_submodules="check on-demand only"

__git_complete_force_with_lease ()
{
	local cur_=$1

	case "$cur_" in
	--*=)
		;;
	*:*)
		__git_complete_refs --cur="${cur_#*:}"
		;;
	*)
		__git_complete_refs --cur="$cur_"
		;;
	esac
}

_git_push ()
{
	case "$prev" in
	--repo)
		__gitcomp_nl "$(__git_remotes)"
		return
		;;
	--recurse-submodules)
		__gitcomp "$__git_push_recurse_submodules"
		return
		;;
	esac
	case "$cur" in
	--repo=*)
		__gitcomp_nl "$(__git_remotes)" "" "${cur##--repo=}"
		return
		;;
	--recurse-submodules=*)
		__gitcomp "$__git_push_recurse_submodules" "" "${cur##--recurse-submodules=}"
		return
		;;
	--force-with-lease=*)
		__git_complete_force_with_lease "${cur##--force-with-lease=}"
		return
		;;
	--*)
		__gitcomp_builtin push
		return
		;;
	esac
	__git_complete_remote_or_refspec
}

_git_range_diff ()
{
	case "$cur" in
	--*)
		__gitcomp "
			--creation-factor= --no-dual-color
			$__git_diff_common_options
		"
		return
		;;
	esac
	__git_complete_revlist
}

__git_rebase_inprogress_options="--continue --skip --abort --quit --show-current-patch"
__git_rebase_interactive_inprogress_options="$__git_rebase_inprogress_options --edit-todo"

_git_rebase ()
{
	__git_find_repo_path
	if [ -f "$__git_repo_path"/rebase-merge/interactive ]; then
		__gitcomp "$__git_rebase_interactive_inprogress_options"
		return
	elif [ -d "$__git_repo_path"/rebase-apply ] || \
	     [ -d "$__git_repo_path"/rebase-merge ]; then
		__gitcomp "$__git_rebase_inprogress_options"
		return
	fi
	__git_complete_strategy && return
	case "$cur" in
	--whitespace=*)
		__gitcomp "$__git_whitespacelist" "" "${cur##--whitespace=}"
		return
		;;
	--onto=*)
		__git_complete_refs --cur="${cur##--onto=}"
		return
		;;
	--*)
		__gitcomp_builtin rebase "" \
			"$__git_rebase_interactive_inprogress_options"

		return
	esac
	__git_complete_refs
}

_git_reflog ()
{
	local subcommands="show delete expire"
	local subcommand="$(__git_find_on_cmdline "$subcommands")"

	if [ -z "$subcommand" ]; then
		__gitcomp "$subcommands"
	else
		__git_complete_refs
	fi
}

__git_send_email_confirm_options="always never auto cc compose"
__git_send_email_suppresscc_options="author self cc bodycc sob cccmd body all"

_git_send_email ()
{
	case "$prev" in
	--to|--cc|--bcc|--from)
		__gitcomp "$(__git send-email --dump-aliases)"
		return
		;;
	esac

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
	--thread=*)
		__gitcomp "
			deep shallow
			" "" "${cur##--thread=}"
		return
		;;
	--to=*|--cc=*|--bcc=*|--from=*)
		__gitcomp "$(__git send-email --dump-aliases)" "" "${cur#--*=}"
		return
		;;
	--*)
		__gitcomp_builtin send-email "--annotate --bcc --cc --cc-cmd --chain-reply-to
			--compose --confirm= --dry-run --envelope-sender
			--from --identity
			--in-reply-to --no-chain-reply-to --no-signed-off-by-cc
			--no-suppress-from --no-thread --quiet --reply-to
			--signed-off-by-cc --smtp-pass --smtp-server
			--smtp-server-port --smtp-encryption= --smtp-user
			--subject --suppress-cc= --suppress-from --thread --to
			--validate --no-validate
			$__git_format_patch_extra_options"
		return
		;;
	esac
	__git_complete_revlist
}

_git_stage ()
{
	_git_add
}

_git_status ()
{
	local complete_opt
	local untracked_state

	case "$cur" in
	--ignore-submodules=*)
		__gitcomp "none untracked dirty all" "" "${cur##--ignore-submodules=}"
		return
		;;
	--untracked-files=*)
		__gitcomp "$__git_untracked_file_modes" "" "${cur##--untracked-files=}"
		return
		;;
	--column=*)
		__gitcomp "
			always never auto column row plain dense nodense
			" "" "${cur##--column=}"
		return
		;;
	--*)
		__gitcomp_builtin status
		return
		;;
	esac

	untracked_state="$(__git_get_option_value "-u" "--untracked-files=" \
		"$__git_untracked_file_modes" "status.showUntrackedFiles")"

	case "$untracked_state" in
	no)
		# --ignored option does not matter
		complete_opt=
		;;
	all|normal|*)
		complete_opt="--cached --directory --no-empty-directory --others"

		if [ -n "$(__git_find_on_cmdline "--ignored")" ]; then
			complete_opt="$complete_opt --ignored --exclude=*"
		fi
		;;
	esac

	__git_complete_index_file "$complete_opt"
}

_git_switch ()
{
	local dwim_opt="$(__git_checkout_default_dwim_mode)"

	case "$prev" in
	-c|-C|--orphan)
		# Complete local branches (and DWIM branch
		# remote branch names) for an option argument
		# specifying a new branch name. This is for
		# convenience, assuming new branches are
		# possibly based on pre-existing branch names.
		__git_complete_refs $dwim_opt --mode="heads"
		return
		;;
	*)
		;;
	esac

	case "$cur" in
	--conflict=*)
		__gitcomp "diff3 merge" "" "${cur##--conflict=}"
		;;
	--*)
		__gitcomp_builtin switch
		;;
	*)
		# Unlike in git checkout, git switch --orphan does not take
		# a start point. Thus we really have nothing to complete after
		# the branch name.
		if [ -n "$(__git_find_on_cmdline "--orphan")" ]; then
			return
		fi

		# At this point, we've already handled special completion for
		# -c/-C, and --orphan. There are 3 main things left to
		# complete:
		# 1) a start-point for -c/-C or -d/--detach
		# 2) a remote head, for --track
		# 3) a branch name, possibly including DWIM remote branches

		if [ -n "$(__git_find_on_cmdline "-c -C -d --detach")" ]; then
			__git_complete_refs --mode="refs"
		elif [ -n "$(__git_find_on_cmdline "--track")" ]; then
			__git_complete_refs --mode="remote-heads"
		else
			__git_complete_refs $dwim_opt --mode="heads"
		fi
		;;
	esac
}

__git_config_get_set_variables ()
{
	local prevword word config_file= c=$cword
	while [ $c -gt 1 ]; do
		word="${words[c]}"
		case "$word" in
		--system|--global|--local|--file=*)
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

	__git config $config_file --name-only --list
}

__git_config_vars=
__git_compute_config_vars ()
{
	test -n "$__git_config_vars" ||
	__git_config_vars="$(git help --config-for-completion | sort -u)"
}

# Completes possible values of various configuration variables.
#
# Usage: __git_complete_config_variable_value [<option>]...
# --varname=<word>: The name of the configuration variable whose value is
#                   to be completed.  Defaults to the previous word on the
#                   command line.
# --cur=<word>: The current value to be completed.  Defaults to the current
#               word to be completed.
__git_complete_config_variable_value ()
{
	local varname="$prev" cur_="$cur"

	while test $# != 0; do
		case "$1" in
		--varname=*)	varname="${1##--varname=}" ;;
		--cur=*)	cur_="${1##--cur=}" ;;
		*)		return 1 ;;
		esac
		shift
	done

	if [ "${BASH_VERSINFO[0]:-0}" -ge 4 ]; then
		varname="${varname,,}"
	else
		varname="$(echo "$varname" |tr A-Z a-z)"
	fi

	case "$varname" in
	branch.*.remote|branch.*.pushremote)
		__gitcomp_nl "$(__git_remotes)" "" "$cur_"
		return
		;;
	branch.*.merge)
		__git_complete_refs --cur="$cur_"
		return
		;;
	branch.*.rebase)
		__gitcomp "false true merges preserve interactive" "" "$cur_"
		return
		;;
	remote.pushdefault)
		__gitcomp_nl "$(__git_remotes)" "" "$cur_"
		return
		;;
	remote.*.fetch)
		local remote="${varname#remote.}"
		remote="${remote%.fetch}"
		if [ -z "$cur_" ]; then
			__gitcomp_nl "refs/heads/" "" "" ""
			return
		fi
		__gitcomp_nl "$(__git_refs_remotes "$remote")" "" "$cur_"
		return
		;;
	remote.*.push)
		local remote="${varname#remote.}"
		remote="${remote%.push}"
		__gitcomp_nl "$(__git for-each-ref \
			--format='%(refname):%(refname)' refs/heads)" "" "$cur_"
		return
		;;
	pull.twohead|pull.octopus)
		__git_compute_merge_strategies
		__gitcomp "$__git_merge_strategies" "" "$cur_"
		return
		;;
	color.pager)
		__gitcomp "false true" "" "$cur_"
		return
		;;
	color.*.*)
		__gitcomp "
			normal black red green yellow blue magenta cyan white
			bold dim ul blink reverse
			" "" "$cur_"
		return
		;;
	color.*)
		__gitcomp "false true always never auto" "" "$cur_"
		return
		;;
	diff.submodule)
		__gitcomp "$__git_diff_submodule_formats" "" "$cur_"
		return
		;;
	help.format)
		__gitcomp "man info web html" "" "$cur_"
		return
		;;
	log.date)
		__gitcomp "$__git_log_date_formats" "" "$cur_"
		return
		;;
	sendemail.aliasfiletype)
		__gitcomp "mutt mailrc pine elm gnus" "" "$cur_"
		return
		;;
	sendemail.confirm)
		__gitcomp "$__git_send_email_confirm_options" "" "$cur_"
		return
		;;
	sendemail.suppresscc)
		__gitcomp "$__git_send_email_suppresscc_options" "" "$cur_"
		return
		;;
	sendemail.transferencoding)
		__gitcomp "7bit 8bit quoted-printable base64" "" "$cur_"
		return
		;;
	*.*)
		return
		;;
	esac
}

# Completes configuration sections, subsections, variable names.
#
# Usage: __git_complete_config_variable_name [<option>]...
# --cur=<word>: The current configuration section/variable name to be
#               completed.  Defaults to the current word to be completed.
# --sfx=<suffix>: A suffix to be appended to each fully completed
#                 configuration variable name (but not to sections or
#                 subsections) instead of the default space.
__git_complete_config_variable_name ()
{
	local cur_="$cur" sfx

	while test $# != 0; do
		case "$1" in
		--cur=*)	cur_="${1##--cur=}" ;;
		--sfx=*)	sfx="${1##--sfx=}" ;;
		*)		return 1 ;;
		esac
		shift
	done

	case "$cur_" in
	branch.*.*)
		local pfx="${cur_%.*}."
		cur_="${cur_##*.}"
		__gitcomp "remote pushRemote merge mergeOptions rebase" "$pfx" "$cur_" "$sfx"
		return
		;;
	branch.*)
		local pfx="${cur_%.*}."
		cur_="${cur_#*.}"
		__gitcomp_direct "$(__git_heads "$pfx" "$cur_" ".")"
		__gitcomp_nl_append $'autoSetupMerge\nautoSetupRebase\n' "$pfx" "$cur_" "${sfx:- }"
		return
		;;
	guitool.*.*)
		local pfx="${cur_%.*}."
		cur_="${cur_##*.}"
		__gitcomp "
			argPrompt cmd confirm needsFile noConsole noRescan
			prompt revPrompt revUnmerged title
			" "$pfx" "$cur_" "$sfx"
		return
		;;
	difftool.*.*)
		local pfx="${cur_%.*}."
		cur_="${cur_##*.}"
		__gitcomp "cmd path" "$pfx" "$cur_" "$sfx"
		return
		;;
	man.*.*)
		local pfx="${cur_%.*}."
		cur_="${cur_##*.}"
		__gitcomp "cmd path" "$pfx" "$cur_" "$sfx"
		return
		;;
	mergetool.*.*)
		local pfx="${cur_%.*}."
		cur_="${cur_##*.}"
		__gitcomp "cmd path trustExitCode" "$pfx" "$cur_" "$sfx"
		return
		;;
	pager.*)
		local pfx="${cur_%.*}."
		cur_="${cur_#*.}"
		__git_compute_all_commands
		__gitcomp_nl "$__git_all_commands" "$pfx" "$cur_" "${sfx:- }"
		return
		;;
	remote.*.*)
		local pfx="${cur_%.*}."
		cur_="${cur_##*.}"
		__gitcomp "
			url proxy fetch push mirror skipDefaultUpdate
			receivepack uploadpack tagOpt pushurl
			" "$pfx" "$cur_" "$sfx"
		return
		;;
	remote.*)
		local pfx="${cur_%.*}."
		cur_="${cur_#*.}"
		__gitcomp_nl "$(__git_remotes)" "$pfx" "$cur_" "."
		__gitcomp_nl_append "pushDefault" "$pfx" "$cur_" "${sfx:- }"
		return
		;;
	url.*.*)
		local pfx="${cur_%.*}."
		cur_="${cur_##*.}"
		__gitcomp "insteadOf pushInsteadOf" "$pfx" "$cur_" "$sfx"
		return
		;;
	*.*)
		__git_compute_config_vars
		__gitcomp "$__git_config_vars" "" "$cur_" "$sfx"
		;;
	*)
		__git_compute_config_vars
		__gitcomp "$(echo "$__git_config_vars" |
				awk -F . '{
					sections[$1] = 1
				}
				END {
					for (s in sections)
						print s "."
				}
				')" "" "$cur_"
		;;
	esac
}

# Completes '='-separated configuration sections/variable names and values
# for 'git -c section.name=value'.
#
# Usage: __git_complete_config_variable_name_and_value [<option>]...
# --cur=<word>: The current configuration section/variable name/value to be
#               completed. Defaults to the current word to be completed.
__git_complete_config_variable_name_and_value ()
{
	local cur_="$cur"

	while test $# != 0; do
		case "$1" in
		--cur=*)	cur_="${1##--cur=}" ;;
		*)		return 1 ;;
		esac
		shift
	done

	case "$cur_" in
	*=*)
		__git_complete_config_variable_value \
			--varname="${cur_%%=*}" --cur="${cur_#*=}"
		;;
	*)
		__git_complete_config_variable_name --cur="$cur_" --sfx='='
		;;
	esac
}

_git_config ()
{
	case "$prev" in
	--get|--get-all|--unset|--unset-all)
		__gitcomp_nl "$(__git_config_get_set_variables)"
		return
		;;
	*.*)
		__git_complete_config_variable_value
		return
		;;
	esac
	case "$cur" in
	--*)
		__gitcomp_builtin config
		;;
	*)
		__git_complete_config_variable_name
		;;
	esac
}

_git_remote ()
{
	local subcommands="
		add rename remove set-head set-branches
		get-url set-url show prune update
		"
	local subcommand="$(__git_find_on_cmdline "$subcommands")"
	if [ -z "$subcommand" ]; then
		case "$cur" in
		--*)
			__gitcomp_builtin remote
			;;
		*)
			__gitcomp "$subcommands"
			;;
		esac
		return
	fi

	case "$subcommand,$cur" in
	add,--*)
		__gitcomp_builtin remote_add
		;;
	add,*)
		;;
	set-head,--*)
		__gitcomp_builtin remote_set-head
		;;
	set-branches,--*)
		__gitcomp_builtin remote_set-branches
		;;
	set-head,*|set-branches,*)
		__git_complete_remote_or_refspec
		;;
	update,--*)
		__gitcomp_builtin remote_update
		;;
	update,*)
		__gitcomp "$(__git_remotes) $(__git_get_config_variables "remotes")"
		;;
	set-url,--*)
		__gitcomp_builtin remote_set-url
		;;
	get-url,--*)
		__gitcomp_builtin remote_get-url
		;;
	prune,--*)
		__gitcomp_builtin remote_prune
		;;
	*)
		__gitcomp_nl "$(__git_remotes)"
		;;
	esac
}

_git_replace ()
{
	case "$cur" in
	--format=*)
		__gitcomp "short medium long" "" "${cur##--format=}"
		return
		;;
	--*)
		__gitcomp_builtin replace
		return
		;;
	esac
	__git_complete_refs
}

_git_rerere ()
{
	local subcommands="clear forget diff remaining status gc"
	local subcommand="$(__git_find_on_cmdline "$subcommands")"
	if test -z "$subcommand"
	then
		__gitcomp "$subcommands"
		return
	fi
}

_git_reset ()
{
	__git_has_doubledash && return

	case "$cur" in
	--*)
		__gitcomp_builtin reset
		return
		;;
	esac
	__git_complete_refs
}

_git_restore ()
{
	case "$prev" in
	-s)
		__git_complete_refs
		return
		;;
	esac

	case "$cur" in
	--conflict=*)
		__gitcomp "diff3 merge" "" "${cur##--conflict=}"
		;;
	--source=*)
		__git_complete_refs --cur="${cur##--source=}"
		;;
	--*)
		__gitcomp_builtin restore
		;;
	esac
}

__git_revert_inprogress_options=$__git_sequencer_inprogress_options

_git_revert ()
{
	__git_find_repo_path
	if [ -f "$__git_repo_path"/REVERT_HEAD ]; then
		__gitcomp "$__git_revert_inprogress_options"
		return
	fi
	__git_complete_strategy && return
	case "$cur" in
	--*)
		__gitcomp_builtin revert "" \
			"$__git_revert_inprogress_options"
		return
		;;
	esac
	__git_complete_refs
}

_git_rm ()
{
	case "$cur" in
	--*)
		__gitcomp_builtin rm
		return
		;;
	esac

	__git_complete_index_file "--cached"
}

_git_shortlog ()
{
	__git_has_doubledash && return

	case "$cur" in
	--*)
		__gitcomp "
			$__git_log_common_options
			$__git_log_shortlog_options
			--numbered --summary --email
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
	--diff-algorithm=*)
		__gitcomp "$__git_diff_algorithms" "" "${cur##--diff-algorithm=}"
		return
		;;
	--submodule=*)
		__gitcomp "$__git_diff_submodule_formats" "" "${cur##--submodule=}"
		return
		;;
	--color-moved=*)
		__gitcomp "$__git_color_moved_opts" "" "${cur##--color-moved=}"
		return
		;;
	--color-moved-ws=*)
		__gitcomp "$__git_color_moved_ws_opts" "" "${cur##--color-moved-ws=}"
		return
		;;
	--*)
		__gitcomp "--pretty= --format= --abbrev-commit --no-abbrev-commit
			--oneline --show-signature --patch
			--expand-tabs --expand-tabs= --no-expand-tabs
			$__git_diff_common_options
			"
		return
		;;
	esac
	__git_complete_revlist_file
}

_git_show_branch ()
{
	case "$cur" in
	--*)
		__gitcomp_builtin show-branch
		return
		;;
	esac
	__git_complete_revlist
}

_git_sparse_checkout ()
{
	local subcommands="list init set disable"
	local subcommand="$(__git_find_on_cmdline "$subcommands")"
	if [ -z "$subcommand" ]; then
		__gitcomp "$subcommands"
		return
	fi

	case "$subcommand,$cur" in
	init,--*)
		__gitcomp "--cone"
		;;
	set,--*)
		__gitcomp "--stdin"
		;;
	*)
		;;
	esac
}

_git_stash ()
{
	local save_opts='--all --keep-index --no-keep-index --quiet --patch --include-untracked'
	local subcommands='push list show apply clear drop pop create branch'
	local subcommand="$(__git_find_on_cmdline "$subcommands save")"
	if [ -z "$subcommand" -a -n "$(__git_find_on_cmdline "-p")" ]; then
		subcommand="push"
	fi
	if [ -z "$subcommand" ]; then
		case "$cur" in
		--*)
			__gitcomp "$save_opts"
			;;
		sa*)
			if [ -z "$(__git_find_on_cmdline "$save_opts")" ]; then
				__gitcomp "save"
			fi
			;;
		*)
			if [ -z "$(__git_find_on_cmdline "$save_opts")" ]; then
				__gitcomp "$subcommands"
			fi
			;;
		esac
	else
		case "$subcommand,$cur" in
		push,--*)
			__gitcomp "$save_opts --message"
			;;
		save,--*)
			__gitcomp "$save_opts"
			;;
		apply,--*|pop,--*)
			__gitcomp "--index --quiet"
			;;
		drop,--*)
			__gitcomp "--quiet"
			;;
		list,--*)
			__gitcomp "--name-status --oneline --patch-with-stat"
			;;
		show,--*|branch,--*)
			;;
		branch,*)
			if [ $cword -eq 3 ]; then
				__git_complete_refs
			else
				__gitcomp_nl "$(__git stash list \
						| sed -n -e 's/:.*//p')"
			fi
			;;
		show,*|apply,*|drop,*|pop,*)
			__gitcomp_nl "$(__git stash list \
					| sed -n -e 's/:.*//p')"
			;;
		*)
			;;
		esac
	fi
}

_git_submodule ()
{
	__git_has_doubledash && return

	local subcommands="add status init deinit update set-branch set-url summary foreach sync absorbgitdirs"
	local subcommand="$(__git_find_on_cmdline "$subcommands")"
	if [ -z "$subcommand" ]; then
		case "$cur" in
		--*)
			__gitcomp "--quiet"
			;;
		*)
			__gitcomp "$subcommands"
			;;
		esac
		return
	fi

	case "$subcommand,$cur" in
	add,--*)
		__gitcomp "--branch --force --name --reference --depth"
		;;
	status,--*)
		__gitcomp "--cached --recursive"
		;;
	deinit,--*)
		__gitcomp "--force --all"
		;;
	update,--*)
		__gitcomp "
			--init --remote --no-fetch
			--recommend-shallow --no-recommend-shallow
			--force --rebase --merge --reference --depth --recursive --jobs
		"
		;;
	set-branch,--*)
		__gitcomp "--default --branch"
		;;
	summary,--*)
		__gitcomp "--cached --files --summary-limit"
		;;
	foreach,--*|sync,--*)
		__gitcomp "--recursive"
		;;
	*)
		;;
	esac
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
			--add-author-from
			--recursive
			--ignore-paths= --include-paths= $remote_opts
			"
		local init_opts="
			--template= --shared= --trunk= --tags=
			--branches= --stdlayout --minimize-url
			--no-metadata --use-svm-props --use-svnsync-props
			--rewrite-root= --prefix= $remote_opts
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
		-d|--delete|-v|--verify)
			__gitcomp_direct "$(__git_tags "" "$cur" " ")"
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
		;;
	-*|tag)
		if [ $f = 1 ]; then
			__gitcomp_direct "$(__git_tags "" "$cur" " ")"
		fi
		;;
	*)
		__git_complete_refs
		;;
	esac

	case "$cur" in
	--*)
		__gitcomp_builtin tag
		;;
	esac
}

_git_whatchanged ()
{
	_git_log
}

__git_complete_worktree_paths ()
{
	local IFS=$'\n'
	__gitcomp_nl "$(git worktree list --porcelain |
		# Skip the first entry: it's the path of the main worktree,
		# which can't be moved, removed, locked, etc.
		sed -n -e '2,$ s/^worktree //p')"
}

_git_worktree ()
{
	local subcommands="add list lock move prune remove unlock"
	local subcommand subcommand_idx

	subcommand="$(__git_find_on_cmdline --show-idx "$subcommands")"
	subcommand_idx="${subcommand% *}"
	subcommand="${subcommand#* }"

	case "$subcommand,$cur" in
	,*)
		__gitcomp "$subcommands"
		;;
	*,--*)
		__gitcomp_builtin worktree_$subcommand
		;;
	add,*)	# usage: git worktree add [<options>] <path> [<commit-ish>]
		# Here we are not completing an --option, it's either the
		# path or a ref.
		case "$prev" in
		-b|-B)	# Complete refs for branch to be created/reset.
			__git_complete_refs
			;;
		-*)	# The previous word is an -o|--option without an
			# unstuck argument: have to complete the path for
			# the new worktree, so don't list anything, but let
			# Bash fall back to filename completion.
			;;
		*)	# The previous word is not an --option, so it must
			# be either the 'add' subcommand, the unstuck
			# argument of an option (e.g. branch for -b|-B), or
			# the path for the new worktree.
			if [ $cword -eq $((subcommand_idx+1)) ]; then
				# Right after the 'add' subcommand: have to
				# complete the path, so fall back to Bash
				# filename completion.
				:
			else
				case "${words[cword-2]}" in
				-b|-B)	# After '-b <branch>': have to
					# complete the path, so fall back
					# to Bash filename completion.
					;;
				*)	# After the path: have to complete
					# the ref to be checked out.
					__git_complete_refs
					;;
				esac
			fi
			;;
		esac
		;;
	lock,*|remove,*|unlock,*)
		__git_complete_worktree_paths
		;;
	move,*)
		if [ $cword -eq $((subcommand_idx+1)) ]; then
			# The first parameter must be an existing working
			# tree to be moved.
			__git_complete_worktree_paths
		else
			# The second parameter is the destination: it could
			# be any path, so don't list anything, but let Bash
			# fall back to filename completion.
			:
		fi
		;;
	esac
}

__git_complete_common () {
	local command="$1"

	case "$cur" in
	--*)
		__gitcomp_builtin "$command"
		;;
	esac
}

__git_cmds_with_parseopt_helper=
__git_support_parseopt_helper () {
	test -n "$__git_cmds_with_parseopt_helper" ||
		__git_cmds_with_parseopt_helper="$(__git --list-cmds=parseopt)"

	case " $__git_cmds_with_parseopt_helper " in
	*" $1 "*)
		return 0
		;;
	*)
		return 1
		;;
	esac
}

__git_complete_command () {
	local command="$1"
	local completion_func="_git_${command//-/_}"
	if ! declare -f $completion_func >/dev/null 2>/dev/null &&
		declare -f _completion_loader >/dev/null 2>/dev/null
	then
		_completion_loader "git-$command"
	fi
	if declare -f $completion_func >/dev/null 2>/dev/null
	then
		$completion_func
		return 0
	elif __git_support_parseopt_helper "$command"
	then
		__git_complete_common "$command"
		return 0
	else
		return 1
	fi
}

__git_main ()
{
	local i c=1 command __git_dir __git_repo_path
	local __git_C_args C_args_count=0

	while [ $c -lt $cword ]; do
		i="${words[c]}"
		case "$i" in
		--git-dir=*) __git_dir="${i#--git-dir=}" ;;
		--git-dir)   ((c++)) ; __git_dir="${words[c]}" ;;
		--bare)      __git_dir="." ;;
		--help) command="help"; break ;;
		-c|--work-tree|--namespace) ((c++)) ;;
		-C)	__git_C_args[C_args_count++]=-C
			((c++))
			__git_C_args[C_args_count++]="${words[c]}"
			;;
		-*) ;;
		*) command="$i"; break ;;
		esac
		((c++))
	done

	if [ -z "${command-}" ]; then
		case "$prev" in
		--git-dir|-C|--work-tree)
			# these need a path argument, let's fall back to
			# Bash filename completion
			return
			;;
		-c)
			__git_complete_config_variable_name_and_value
			return
			;;
		--namespace)
			# we don't support completing these options' arguments
			return
			;;
		esac
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
			--man-path
			--info-path
			--work-tree=
			--namespace=
			--no-replace-objects
			--help
			"
			;;
		*)
			if test -n "${GIT_TESTING_PORCELAIN_COMMAND_LIST-}"
			then
				__gitcomp "$GIT_TESTING_PORCELAIN_COMMAND_LIST"
			else
				__gitcomp "$(__git --list-cmds=list-mainporcelain,others,nohelpers,alias,list-complete,config)"
			fi
			;;
		esac
		return
	fi

	__git_complete_command "$command" && return

	local expansion=$(__git_aliased_command "$command")
	if [ -n "$expansion" ]; then
		words[1]=$expansion
		__git_complete_command "$expansion"
	fi
}

__gitk_main ()
{
	__git_has_doubledash && return

	local __git_repo_path
	__git_find_repo_path

	local merge=""
	if [ -f "$__git_repo_path/MERGE_HEAD" ]; then
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

if [[ -n ${ZSH_VERSION-} && -z ${GIT_SOURCING_ZSH_COMPLETION-} ]]; then
	echo "ERROR: this script is obsolete, please see git-completion.zsh" 1>&2
	return
fi

__git_func_wrap ()
{
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

if ! git --list-cmds=main >/dev/null 2>&1; then

	declare -A __git_cmds
	__git_cmds[list-complete]="apply blame cherry config difftool fsck help instaweb mergetool prune reflog remote repack replace request-pull send-email show-branch stage whatchanged"
	__git_cmds[list-guide]="attributes cli core-tutorial credentials cvs-migration diffcore everyday faq glossary hooks ignore modules namespaces remote-helpers repository-layout revisions submodules tutorial-2 tutorial workflows"
	__git_cmds[list-mainporcelain]="add am archive bisect branch bundle checkout cherry-pick citool clean clone commit describe diff fetch format-patch gc grep gui init gitk log maintenance merge mv notes pull push range-diff rebase reset restore revert rm shortlog show sparse-checkout stash status submodule switch tag worktree"
	__git_cmds[main]="add add--interactive am annotate apply archimport archive bisect bisect--helper blame branch bugreport bundle cat-file check-attr check-ignore check-mailmap check-ref-format checkout checkout-index cherry cherry-pick citool clean clone column commit commit-graph commit-tree config count-objects credential credential-cache credential-cache--daemon credential-gnome-keyring credential-libsecret credential-store cvsexportcommit cvsimport cvsserver daemon describe diff diff-files diff-index diff-tree difftool difftool--helper env--helper fast-export fast-import fetch fetch-pack filter-branch fmt-merge-msg for-each-ref format-patch fsck fsck-objects gc get-tar-commit-id grep gui gui--askpass hash-object help http-backend http-fetch http-push imap-send index-pack init init-db instaweb interpret-trailers log ls-files ls-remote ls-tree mailinfo mailsplit maintenance merge merge-base merge-file merge-index merge-octopus merge-one-file merge-ours merge-recursive merge-recursive-ours merge-recursive-theirs merge-resolve merge-subtree merge-tree mergetool mktag mktree multi-pack-index mv mw name-rev notes p4 pack-objects pack-redundant pack-refs patch-id pickaxe prune prune-packed pull push quiltimport range-diff read-tree rebase rebase--interactive receive-pack reflog remote remote-ext remote-fd remote-ftp remote-ftps remote-http remote-https remote-mediawiki repack replace request-pull rerere reset restore rev-list rev-parse revert rm send-email send-pack sh-i18n--envsubst shell shortlog show show-branch show-index show-ref sparse-checkout stage stash status stripspace submodule submodule--helper subtree svn switch symbolic-ref tag unpack-file unpack-objects update-index update-ref update-server-info upload-archive upload-archive--writer upload-pack var verify-commit verify-pack verify-tag version web--browse whatchanged worktree write-tree"
	__git_cmds[others]="compare reintegrate related remote-hg remote-sync send-series smartlist"
	__git_cmds[parseopt]="add am apply archive bisect--helper blame branch bugreport cat-file check-attr check-ignore check-mailmap checkout checkout-index cherry cherry-pick clean clone column commit commit-graph config count-objects credential-cache credential-cache--daemon credential-store describe difftool env--helper fast-export fetch fmt-merge-msg for-each-ref format-patch fsck fsck-objects gc grep hash-object help init init-db interpret-trailers log ls-files ls-remote ls-tree merge merge-base merge-file mktree multi-pack-index mv name-rev notes pack-objects pack-refs pickaxe prune prune-packed pull push range-diff read-tree rebase rebase--interactive receive-pack reflog remote repack replace rerere reset restore revert rm send-pack shortlog show show-branch show-index show-ref sparse-checkout stage stash status stripspace switch symbolic-ref tag update-index update-ref update-server-info upload-pack verify-commit verify-pack verify-tag version whatchanged write-tree "

	# Override __git
	__git ()
	{
		case "$1" in
		--list-cmds=*)
			while read -r -d ',' x; do
				case "$x" in
				nohelpers)
					;;
				alias)
					;;
				config)
					;;
				*)
					echo ${__git_cmds[$x]}
					;;
				esac
			done <<< "${1##--list-cmds=},"
			return
			;;
		esac
		git ${__git_C_args:+"${__git_C_args[@]}"} \
			${__git_dir:+--git-dir="$__git_dir"} "$@" 2>/dev/null
	}

fi

__git_complete git __git_main
__git_complete gitk __gitk_main

# The following are necessary only for Cygwin, and only are needed
# when the user has tab-completed the executable name and consequently
# included the '.exe' suffix.
#
if [ "$OSTYPE" = cygwin ]; then
	__git_complete git.exe __git_main
fi

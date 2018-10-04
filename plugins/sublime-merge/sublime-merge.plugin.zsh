# Sublime Merge Aliases

() {

	if [[ "$OSTYPE" == linux* ]]; then
		local _sublime_linux_paths
		_sublime_linux_paths=(
			"$HOME/bin/sublime_merge"
			"/opt/sublime_merge/sublime_merge"
			"/usr/bin/sublime_merge"
			"/usr/local/bin/sublime_merge"
			"/usr/bin/sublime_merge"
			"/usr/local/bin/smerge"
			"/usr/bin/smerge"
			)
		for _sublime_merge_path in $_sublime_linux_paths; do
			if [[ -a $_sublime_merge_path ]]; then
				sm_run() { $_sublime_merge_path "$@" >/dev/null 2>&1 &| }
				ssm_run_sudo() {sudo $_sublime_merge_path "$@" >/dev/null 2>&1}
				alias ssm=ssm_run_sudo
				alias sm=sm_run
				break
			fi
		done
	elif  [[ "$OSTYPE" = darwin* ]]; then
		local _sublime_darwin_paths
		_sublime_darwin_paths=(
			"/usr/local/bin/smerge"
			"/Applications/Sublime Merge.app/Contents/SharedSupport/bin/smerge"
			"$HOME/Applications/Sublime Merge.app/Contents/SharedSupport/bin/smerge"
			)
		for _sublime_merge_path in $_sublime_darwin_paths; do
			if [[ -a $_sublime_merge_path ]]; then
				subm () { "$_sublime_merge_path" "$@" }
				alias sm=subm
				break
			fi
		done
	elif [[ "$OSTYPE" = 'cygwin' ]]; then
		local sublime_merge_cygwin_paths
		sublime_merge_cygwin_paths=(
			"$(cygpath $ProgramW6432/Sublime\ Merge)/sublime_merge.exe"
			)
		for _sublime_merge_path in $_sublime_merge_cygwin_paths; do
			if [[ -a $_sublime_merge_path ]]; then
				subm () { "$_sublime_merge_path" "$@" }
				alias sm=subm
				break
			fi
		done
	fi

}

alias smt='sm .'

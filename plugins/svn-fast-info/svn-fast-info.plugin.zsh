# vim:ft=zsh ts=2 sw=2 sts=2
#
# Faster alternative to the current SVN plugin implementation.
#
# Works with svn 1.6, 1.7, 1.8.
# Use `svn_prompt_info` method to enquire the svn data.
# It's faster because his efficient use of svn (single svn call) done in the `parse_svn` function
# Also changed prompt suffix *after* the svn dirty marker
#
# *** IMPORTANT *** DO NO USE with the simple svn plugin, this plugin acts as a replacement of it.

function svn_prompt_info() {
	info=$(svn info 2>&1) || return; # capture stdout and stdout
	in_svn=true
	repo_need_upgrade="$(svn_repo_need_upgrade $info)"
	svn_branch_name="$(svn_get_branch_name $info)"
	svn_dirty="$(svn_dirty_choose)"
	svn_repo_name="$(svn_get_repo_name $info)"
	svn_rev="$(svn_get_revision $info)"

	if [ ! -z $repo_need_upgrade ]; then
		echo $ZSH_PROMPT_BASE_COLOR$ZSH_THEME_SVN_PROMPT_PREFIX$ZSH_PROMPT_BASE_COLOR\
$repo_need_upgrade\
$ZSH_PROMPT_BASE_COLOR$ZSH_THEME_SVN_PROMPT_SUFFIX$ZSH_PROMPT_BASE_COLOR
	fi

	if [[ ${in_svn} == true && -z $repo_need_upgrade ]]; then
		echo "$ZSH_PROMPT_BASE_COLOR$ZSH_THEME_SVN_PROMPT_PREFIX\
$ZSH_THEME_REPO_NAME_COLOR${svn_branch_name}\
$ZSH_PROMPT_BASE_COLOR${svn_dirty}\
$ZSH_PROMPT_BASE_COLOR$ZSH_THEME_SVN_PROMPT_SUFFIX\
$ZSH_PROMPT_BASE_COLOR"
	fi
}


function svn_repo_need_upgrade() {
	info=$1
	[ -z "${info}" ] && info=$(svn info 2>&1)
	if grep -q "E155036" <<< $info; then echo "E155036: upgrade repo with svn upgrade"; fi
}

function svn_get_branch_name() {
	info=$1
	[ -z "${info}" ] && info=$(svn info 2> /dev/null)
	echo $info | grep '^URL:' | egrep -o '(tags|branches)/[^/]+|trunk' | egrep -o '[^/]+$' | read SVN_URL
	echo $SVN_URL
}

function svn_get_repo_name() {
	info=$1
	[ -z "${info}" ] && info=$(svn info 2> /dev/null)
	echo $info | sed -n 's/Repository\ Root:\ .*\///p' | read SVN_ROOT
	echo $info | sed -n "s/URL:\ .*$SVN_ROOT\///p"
}

function svn_get_revision() {
	info=$1
	[ -z "${info}" ] && info=$(svn info 2> /dev/null)
	echo $info 2> /dev/null | sed -n s/Revision:\ //p
}

function svn_dirty_choose() {
	svn status | grep -E '^\s*[ACDIM!?L]' > /dev/null 2>/dev/null && echo $ZSH_THEME_SVN_PROMPT_DIRTY && return
	echo $ZSH_THEME_SVN_PROMPT_CLEAN
}


function svn_prompt_info {
    if [ $(in_svn) ]; then
        if [ "x$SVN_SHOW_BRANCH" = "xtrue" ]; then
            unset SVN_SHOW_BRANCH
            _DISPLAY=$(svn_get_branch_name)
        else
            _DISPLAY=$(svn_get_repo_name)
        fi
        echo "$ZSH_PROMPT_BASE_COLOR$ZSH_THEME_SVN_PROMPT_PREFIX\
$ZSH_THEME_REPO_NAME_COLOR$_DISPLAY$ZSH_PROMPT_BASE_COLOR$ZSH_THEME_SVN_PROMPT_SUFFIX$ZSH_PROMPT_BASE_COLOR$(svn_dirty)$ZSH_PROMPT_BASE_COLOR"
        unset _DISPLAY
    fi
}


function in_svn() {
    if [[ -d .svn ]]; then
        echo 1
    fi
}

function svn_get_repo_name {
    if [ $(in_svn) ]; then
        svn info | sed -n 's/Repository\ Root:\ .*\///p' | read SVN_ROOT

        svn info | sed -n "s/URL:\ .*$SVN_ROOT\///p"
    fi
}

function svn_get_branch_name {
    _DISPLAY=$(svn info 2> /dev/null | awk -F/ '/^URL:/ { for (i=0; i<=NF; i++) { if ($i == "branches" || $i == "tags" ) { print $(i+1); break }; if ($i == "trunk") { print $i; break } } }')
    if [ "x$_DISPLAY" = "x" ]; then
        svn_get_repo_name
    else
        echo $_DISPLAY
    fi
    unset _DISPLAY
}

function svn_get_rev_nr {
    if [ $(in_svn) ]; then
        svn info 2> /dev/null | sed -n s/Revision:\ //p
    fi
}

function svn_dirty_choose {
    if [ $(in_svn) ]; then
        svn status 2> /dev/null | grep -Eq '^\s*[ACDIM!?L]'
        if [ $pipestatus[-1] -eq 0 ]; then
            # Grep exits with 0 when "One or more lines were selected", return "dirty".
            echo $1
        else
            # Otherwise, no lines were found, or an error occurred. Return clean.
            echo $2
        fi
    fi
}

function svn_dirty {
    svn_dirty_choose $ZSH_THEME_SVN_PROMPT_DIRTY $ZSH_THEME_SVN_PROMPT_CLEAN
}

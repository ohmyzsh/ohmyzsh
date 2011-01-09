function scm_in_svn_repo() {
    if [[ -d .svn ]]; then
        echo 1
    fi
}

function scm_svn_prompt_info {
    if [ -d .svn ]; then
        out="$ZSH_THEME_SCM_PROMPT_PREFIX$(svn_get_repo_name)$(parse_svn_dirty)$ZSH_THEME_SCM_PROMPT_SUFFIX"
        if [[ ZSH_THEME_SCM_DISPLAY_NAME -eq 1 ]]; then
              out="svn$out"
        fi
        echo $out
    fi
}

function svn_get_repo_name {
    if [ in_svn_repo ]; then
        svn info | sed -n 's/Repository\ Root:\ .*\///p' | read SVN_ROOT
    
        svn info | sed -n "s/URL:\ .*$SVN_ROOT\///p" | sed "s/\/.*$//"
    fi
}

function svn_get_rev_nr {
    if [ in_svn_repo ]; then
        svn info 2> /dev/null | sed -n s/Revision:\ //p
    fi
}

function parse_svn_dirty {
    if [ in_svn_repo ]; then
        s=$(svn status 2>/dev/null)
        if [ $s ]; then 
            echo $ZSH_THEME_SCM_PROMPT_DIRTY
        else 
            echo $ZSH_THEME_SCM_PROMPT_CLEAN
        fi
    fi
}

ZSH_THEME_SVN_NAME="svn"
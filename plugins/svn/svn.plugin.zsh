function svn_prompt_info {
    if [[ -d .svn ]]; then
        echo "$ZSH_PROMPT_BASE_COLOR$ZSH_THEME_SVN_PROMPT_PREFIX\
$ZSH_THEME_REPO_NAME_COLOR$(svn_get_repo_name)$ZSH_PROMPT_BASE_COLOR$ZSH_THEME_SVN_PROMPT_SUFFIX$ZSH_PROMPT_BASE_COLOR$(svn_dirty)$ZSH_PROMPT_BASE_COLOR"
    fi
}


function in_svn() {
    if [[ -d .svn ]]; then
        echo 1
    fi
}

function svn_get_repo_name {
    if [ is_svn ]; then
        svn info | sed -n 's/Repository\ Root:\ .*\///p' | read SVN_ROOT
    
        svn info | sed -n "s/URL:\ .*$SVN_ROOT\///p" | sed "s/\/.*$//"
    fi
}

function svn_get_rev_nr {
    if [ is_svn ]; then
        svn info 2> /dev/null | sed -n s/Revision:\ //p
    fi
}

function svn_dirty_choose {
    if [ is_svn ]; then
        s=$(svn status 2>/dev/null)
        if [ $s ]; then 
            echo $1
        else 
            echo $2
        fi
    fi
}

function svn_dirty {
    svn_dirty_choose $ZSH_THEME_SVN_PROMPT_DIRTY $ZSH_THEME_SVN_PROMPT_CLEAN
}

# Function to update an SVN repository in a safe manner: first display
# diffstat (if installed), log and diff (folded), then ask about continuing
# with `svn up`.
# Optional args: $to $from (default: HEAD BASE)
function svnsafeup() {
  if [[ "$(in_svn)" != "1" ]]; then
    echo "Not in a SVN repository." 1>&2 ; return 1
  fi
  local from=${2:-BASE} to=${1:-HEAD}
  local range="$from:$to"
  local repo_id="$(svn_get_repo_name)@$(svn_get_rev_nr)"
  local diffcmd="svn diff -r $range"

  local diff="$($=diffcmd)"
  if [[ $diff == '' ]] ; then
    echo "No changes for $repo_id in range $range."
    return
  fi

  {
    echo "Diff for: $repo_id, range: $range"
    echo
    if [ $commands[diffstat] ] ; then
      diffstat=$(echo $diff | diffstat)
      echo -n "diffstat: "
      echo $diffstat | tail -n1
      echo $diffstat | sed 's/^/  /'
      echo
    fi
    echo "svn log -r $range:"
    svn log -r $range | sed 's/^/  /'
    echo
    echo "$diffcmd:"
    echo $diff | sed 's/^/  /' | sed '/^  Index: / !s/^/  /'
  } | view -c 'set foldnestmax=2 foldlevel=0 shiftwidth=2 foldmethod=indent'  -
  read "answer?continue to 'svn up'? (ctrl-c to abort, y to continue) " || return 1
  [[ $answer == "y" ]] || return 1
  currev="$(svn info | grep '^Revision:' | cut -f2 -d\ )"
  echo "Updating from revision $currev to $to.."
  svn up -r $to
}

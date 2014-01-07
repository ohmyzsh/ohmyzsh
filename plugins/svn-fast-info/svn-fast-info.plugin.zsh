# vim:ft=zsh ts=2 sw=2 sts=2 et
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
  local info
  info=$(svn info 2>&1) || return 1; # capture stdout and stderr
  local repo_need_upgrade=$(svn_repo_need_upgrade $info)

  if [ -n $repo_need_upgrade ]; then
    printf '%s%s%s%s%s%s%s\n' \
      $ZSH_PROMPT_BASE_COLOR \
      $ZSH_THEME_SVN_PROMPT_PREFIX \
      $ZSH_PROMPT_BASE_COLOR \
      $repo_need_upgrade \
      $ZSH_PROMPT_BASE_COLOR \
      $ZSH_THEME_SVN_PROMPT_SUFFIX \
      $ZSH_PROMPT_BASE_COLOR \
  else
    # something left for you to fix -
    # repo name and rev aren't used here, did you forget them?
    # especially since you set a repo name color
    # if the prompt is alright this way, leave it as is and just
    # delete the comment. The functions itself could stay imo,
    # gives others the chance to use them.
    printf '%s%s%s%s%s%s%s%s%s\n' \
      $ZSH_PROMPT_BASE_COLOR \
      $ZSH_THEME_SVN_PROMPT_PREFIX \
      $ZSH_THEME_REPO_NAME_COLOR \
      $(svn_get_branch_name $info)
      ${svn_branch_name}\
      $ZSH_PROMPT_BASE_COLOR
      $(svn_dirty_choose $info)
      $ZSH_PROMPT_BASE_COLOR
      $ZSH_THEME_SVN_PROMPT_SUFFIX\
      $ZSH_PROMPT_BASE_COLOR
  fi
}

function svn_repo_need_upgrade() {
  grep -q "E155036" <<< ${1:-$(svn info 2> /dev/null)} && \
    echo "E155036: upgrade repo with svn upgrade"
}

function svn_get_branch_name() {
  echo ${1:-$(svn info 2> /dev/null)} |\
    grep '^URL:' | egrep -o '(tags|branches)/[^/]+|trunk' |\
    egrep -o '[^/]+$'
}

function svn_get_repo_name() {
  # I think this can be further cleaned up as well, not sure how,
  # as I can't test it
  local svn_root
  local info=${1:-$(svn info 2> /dev/null)}
  echo $info | sed 's/Repository\ Root:\ .*\///p' | read svn_root
  echo $info | sed "s/URL:\ .*$svn_root\///p"
}

function svn_get_revision() {
  # does this work as it should?
  echo ${1:-$(svn info 2> /dev/null)} | sed 's/Revision: //p'
}

function svn_dirty_choose() {
  if svn status | grep -E '^\s*[ACDIM!?L]' &> /dev/null; then
    echo $ZSH_THEME_SVN_PROMPT_DIRTY
  else
    echo $ZSH_THEME_SVN_PROMPT_CLEAN
  fi
}

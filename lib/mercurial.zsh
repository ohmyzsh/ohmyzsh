function hg_prompt_info() {
  branch=$(hg id -b 2> /dev/null) || return
  tag=$(hg id -t 2> /dev/null) || return
  rev_number=$(hg id -n 2> /dev/null) || return
  rev_id=$(hg id -i 2> /dev/null) || return
  echo "${ZSH_THEME_HG_PROMPT_PREFIX}${rev_number/\+/}:${rev_id/\+/}@${branch}(${tag})${ZSH_THEME_HG_PROMPT_SUFFIX}"
}
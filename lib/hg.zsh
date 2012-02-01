

ZSH_THEME_HG_PROMPT_PREFIX=$ZSH_THEME_GIT_PROMPT_PREFIX
ZSH_THEME_HG_PROMPT_SUFFIX=$ZSH_THEME_GIT_PROMPT_SUFFIX
ZSH_THEME_HG_PROMPT_SHA_BEFORE=$ZSH_THEME_GIT_PROMPT_SHA_BEFORE
ZSH_THEME_HG_PROMPT_SHA_AFTER=$ZSH_THEME_GIT_PROMPT_SHA_AFTER
ZSH_THEME_HG_PROMPT_UNTRACKED=$ZSH_THEME_GIT_PROMPT_UNTRACKED
ZSH_THEME_HG_PROMPT_ADDED=$ZSH_THEME_GIT_PROMPT_ADDED
ZSH_THEME_HG_PROMPT_MODIFIED=$ZSH_THEME_GIT_PROMPT_MODIFIED
ZSH_THEME_HG_PROMPT_RENAMED=$ZSH_THEME_GIT_PROMPT_RENAMED
ZSH_THEME_HG_PROMPT_DELETED=$ZSH_THEME_GIT_PROMPT_DELETED
ZSH_THEME_HG_PROMPT_UNMERGED=$ZSH_THEME_GIT_PROMPT_UNMERGED


# get the name of the branch we are on
function hg_prompt_info() {
  ref=$(hg branch 2> /dev/null) || return
  tag=$(hg parent | grep tag | cut -f 2 -d ":" | tr -d ' ')
  echo "$ZSH_THEME_HG_PROMPT_PREFIX${ref}:${tag}$ZSH_THEME_HG_PROMPT_SUFFIX"
}



# Formats prompt string for current git commit short SHA
function hg_prompt_name() {
  SHA=$(hg id 2> /dev/null) && echo "$ZSH_THEME_HG_PROMPT_SHA_BEFORE$SHA$ZSH_THEME_HG_PROMPT_SHA_AFTER"
}


# Get the status of the working tree
hg_prompt_status() {
  INDEX=$(hg status 2> /dev/null)
  STATUS=""
  if $(echo "$INDEX" | grep '^? ' &> /dev/null); then
    STATUS="$ZSH_THEME_HG_PROMPT_UNTRACKED$STATUS"
  fi
  if $(echo "$INDEX" | grep '^A  ' &> /dev/null); then
    STATUS="$ZSH_THEME_HG_PROMPT_ADDED$STATUS"
  elif $(echo "$INDEX" | grep '^M  ' &> /dev/null); then
    STATUS="$ZSH_THEME_HG_PROMPT_ADDED$STATUS"
  fi
  if $(echo "$INDEX" | grep '^ M ' &> /dev/null); then
    STATUS="$ZSH_THEME_HG_PROMPT_MODIFIED$STATUS"
  elif $(echo "$INDEX" | grep '^AM ' &> /dev/null); then
    STATUS="$ZSH_THEME_HG_PROMPT_MODIFIED$STATUS"
  elif $(echo "$INDEX" | grep '^ T ' &> /dev/null); then
    STATUS="$ZSH_THEME_HG_PROMPT_MODIFIED$STATUS"
  fi
  if $(echo "$INDEX" | grep '^R  ' &> /dev/null); then
    STATUS="$ZSH_THEME_HG_PROMPT_RENAMED$STATUS"
  fi
  if $(echo "$INDEX" | grep '^ D ' &> /dev/null); then
    STATUS="$ZSH_THEME_HG_PROMPT_DELETED$STATUS"
  elif $(echo "$INDEX" | grep '^AD ' &> /dev/null); then
    STATUS="$ZSH_THEME_HG_PROMPT_DELETED$STATUS"
  fi
  if $(echo "$INDEX" | grep '^UU ' &> /dev/null); then
    STATUS="$ZSH_THEME_HG_PROMPT_UNMERGED$STATUS"
  fi
  echo $STATUS
}
# Invoked only by preview.zsh in a fresh zsh -df process. Themes and hooks
# are intentionally sourced/run at top level (not inside a setup function).
emulate -R zsh
if [[ $1 == --supervise ]]; then
  # This process is the private PTY's session leader. Keep the actual worker's
  # standard descriptors non-TTY, and report its status outside theme state.
  typeset -r _omz_preview_tmp=$2
  shift 2
  unsetopt monitor
  command "$commands[zsh]" -df "${0:A}" "$@" \
    < /dev/null > "$_omz_preview_tmp/output" 2>&1
  print -r -- $? > "$_omz_preview_tmp/result"
  exit
fi
typeset -r _omz_preview_root=$1 _omz_preview_theme=$2 _omz_preview_status=$3
export ZSH=${ZSH:-$_omz_preview_root}
ZSH_THEME=$4
ZSH_CUSTOM=$5
fpath=("$_omz_preview_root/functions" $fpath)
autoload -Uz colors add-zsh-hook vcs_info
colors
setopt prompt_subst prompt_percent
zstyle ':omz:alpha:lib:git' async-prompt no
ZSH_THEME_GIT_PROMPT_PREFIX='git:('
ZSH_THEME_GIT_PROMPT_SUFFIX=')'
ZSH_THEME_GIT_PROMPT_DIRTY='*'
ZSH_THEME_GIT_PROMPT_CLEAN=''
ZSH_THEME_RUBY_PROMPT_PREFIX='('
ZSH_THEME_RUBY_PROMPT_SUFFIX=')'
source "$_omz_preview_root/lib/git.zsh"
source "$_omz_preview_root/lib/vcs_info.zsh"
source "$_omz_preview_root/lib/bzr.zsh"
source "$_omz_preview_root/lib/nvm.zsh"
source "$_omz_preview_root/lib/prompt_info_functions.zsh"
source "$_omz_preview_root/lib/spectrum.zsh"
# Check syntax before accepting a final false conditional as a successful load.
# This subprocess shares the worker's execution deadline and process group.
command "$commands[zsh]" -dfn "$_omz_preview_theme" || {
  print -u2 -r -- 'theme preview: theme syntax check failed'
  exit 1
}
# Keep zsh's PROMPT/PS1 and RPROMPT/RPS1 aliases intact (dieter sets RPS1).
PROMPT=''
RPROMPT=''
source "$_omz_preview_theme"
typeset -i _omz_preview_load_status=$?
# Status 1 may just be a final conditional; require an initialized prompt below.
# Higher statuses include syntax/runtime errors and missing commands.
if (( _omz_preview_load_status > 1 )); then
  print -u2 -r -- "theme preview: theme could not be loaded (exit $_omz_preview_load_status)"
  exit 1
fi

function _omz_preview_set_status { return "$_omz_preview_status" }
typeset -i _omz_preview_hook_status=0
if (( $+functions[precmd] )); then
  _omz_preview_set_status
  precmd
  _omz_preview_hook_status=$?
  if (( _omz_preview_hook_status )); then
    print -u2 -r -- "theme preview: precmd failed (exit $_omz_preview_hook_status); remaining hooks skipped"
  fi
fi
for _omz_preview_hook in "${precmd_functions[@]}"; do
  (( _omz_preview_hook_status )) && break
  if (( $+functions[$_omz_preview_hook] )); then
    _omz_preview_set_status
    "$_omz_preview_hook"
    _omz_preview_hook_status=$?
    if (( _omz_preview_hook_status )); then
      print -u2 -r -- "theme preview: precmd hook $_omz_preview_hook failed (exit $_omz_preview_hook_status); remaining hooks skipped"
    fi
  fi
done
if (( _omz_preview_load_status )) && [[ -z $PROMPT && -z $RPROMPT ]]; then
  print -u2 -r -- "theme preview: theme did not initialize a prompt (load exit $_omz_preview_load_status)"
  exit 1
fi
# Native prompt expansion handles PROMPT_SUBST once, followed by percent escapes.
# An explicit (e) pass here would re-execute literal substitutions from helpers.
print -r -- "Left prompt (status $_omz_preview_status):"
_omz_preview_set_status
print -Pr -- "${PROMPT-}"
print -r -- 'Right prompt (shown separately):'
_omz_preview_set_status
print -Pr -- "${RPROMPT-}"
(( _omz_preview_hook_status )) && exit 1
exit 42

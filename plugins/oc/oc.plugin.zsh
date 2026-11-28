# Autocompletion for oc, the command line interface for OpenShift
#
# Author: https://github.com/kevinkirkup

if (( ! $+commands[oc] )); then
  return
fi

# If the completion file does not exist, generate it and then source it
# Otherwise, source it and regenerate in the background
if [[ ! -f "$ZSH_CACHE_DIR/completions/_oc" ]]; then
  oc completion zsh | tee "$ZSH_CACHE_DIR/completions/_oc" >/dev/null
  source "$ZSH_CACHE_DIR/completions/_oc"
else
  source "$ZSH_CACHE_DIR/completions/_oc"
  zmodload -F zsh/files b:zf_mv
  () {
    local TMPPREFIX="$ZSH_CACHE_DIR/completions/._oc"
    zf_mv -f -- =( oc completion zsh ) "$ZSH_CACHE_DIR/completions/_oc"
  } &|
fi

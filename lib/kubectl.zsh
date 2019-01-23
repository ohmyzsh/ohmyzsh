# Outputs current kubectl in prompt format
function kubectl_prompt_info() {
  local ref
  ref=$(cat ~/.kube/config | grep "current-context:" | sed "s/current-context: //") || return 0
  echo "$ZSH_THEME_KUBECTL_PROMPT_PREFIX${ref}$ZSH_THEME_KUBECTL_PROMPT_SUFFIX"
}

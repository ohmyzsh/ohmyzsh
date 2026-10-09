_terragrunt_refresh_completion_cache() {
  emulate -L zsh
  setopt pipefail

  local unit_dir=${1:A}
  local cache_dir="$unit_dir/.terragrunt-cache/.zsh-completion"
  local temp_dir line kind value

  [[ -f "$unit_dir/terragrunt.hcl" ]] || return 1
  (( $+commands[jq] )) || return 1

  command mkdir -p -- "$cache_dir" || return 1
  temp_dir=$(mktemp -d "$cache_dir/.refresh.XXXXXXXX") || return 1
  : >| "$temp_dir/resources"
  : >| "$temp_dir/outputs"

  if ! (
    cd -- "$unit_dir" &&
      command terragrunt show -json --log-disable \
        --non-interactive --experiment optional-dependency-outputs \
        --no-dependency-outputs 2>/dev/null |
        command jq -r '
          ((.values.root_module? // {})
            | recurse(.child_modules[]?)
            | .resources[]?.address?
            | strings
            | "resource\t\(.)"),
          ((.values.outputs? // {})
            | keys[]?
            | strings
            | "output\t\(.)")
        '
  ) | while IFS=$'\t' read -r kind value; do
    case $kind in
      resource) print -r -- "$value" >> "$temp_dir/resources" ;;
      output) print -r -- "$value" >> "$temp_dir/outputs" ;;
    esac
  done; then
    command rm -rf -- "$temp_dir"
    return 1
  fi

  command mv -f -- "$temp_dir/resources" "$cache_dir/resources"
  command mv -f -- "$temp_dir/outputs" "$cache_dir/outputs"
  command rmdir -- "$temp_dir"
}

_terragrunt_command_changes_state() {
  emulate -L zsh

  local command_line=$1 token
  local -a command_words
  local -i index terragrunt_index=0 state_command=0 workspace_command=0

  command_words=(${(z)command_line})
  for token in "${command_words[@]}"; do
    [[ $token == --help || $token == -h ]] && return 1
  done

  for ((index = 1; index <= ${#command_words}; index++)); do
    if [[ ${command_words[index]:t} == terragrunt ]]; then
      terragrunt_index=$index
      break
    fi
  done
  ((terragrunt_index)) || return 1

  for ((index = terragrunt_index + 1; index <= ${#command_words}; index++)); do
    token=${command_words[index]}

    if ((state_command)) && [[ $token == (mv|rm|push|replace-provider) ]]; then
      return 0
    elif ((workspace_command)) && [[ $token == (new|select|delete) ]]; then
      return 0
    fi

    case $token in
      apply|destroy|import|refresh|taint|untaint)
        return 0
        ;;
      state)
        state_command=1
        ;;
      workspace)
        workspace_command=1
        ;;
    esac
  done

  return 1
}

_terragrunt_cache_preexec() {
  _terragrunt_cache_refresh_dir=
  if [[ -f "$PWD/terragrunt.hcl" ]] && _terragrunt_command_changes_state "$2"; then
    _terragrunt_cache_refresh_dir=$PWD
  fi
}

_terragrunt_cache_precmd() {
  local unit_dir=$_terragrunt_cache_refresh_dir

  _terragrunt_cache_refresh_dir=
  [[ -n $unit_dir ]] || return 0
  (_terragrunt_refresh_completion_cache "$unit_dir") &!
}

typeset -g _terragrunt_cache_refresh_dir
autoload -Uz add-zsh-hook
add-zsh-hook -d preexec _terragrunt_cache_preexec 2>/dev/null
add-zsh-hook -d precmd _terragrunt_cache_precmd 2>/dev/null
add-zsh-hook preexec _terragrunt_cache_preexec
add-zsh-hook precmd _terragrunt_cache_precmd

alias tg='terragrunt'
alias tga='terragrunt apply --use-partial-parse-config-cache'
alias tgc='terragrunt run -- console'
alias tgd='terragrunt destroy --use-partial-parse-config-cache'
alias tgf='terragrunt hcl fmt'
alias tgi='terragrunt init --use-partial-parse-config-cache'
alias tgiu='terragrunt init -upgrade --use-partial-parse-config-cache'
alias tgo='terragrunt output --use-partial-parse-config-cache'
alias tgoj='terragrunt output -json --use-partial-parse-config-cache'
alias tgp='terragrunt plan --use-partial-parse-config-cache'
alias tgv='terragrunt validate'
alias tgs='terragrunt state --use-partial-parse-config-cache'
alias tgt='terragrunt run -- taint'
alias tgsh='terragrunt show'

autoload -Uz _terragrunt
compdef _terragrunt terragrunt

_terragrunt_alias() {
  local alias_name=${words[1]}
  local -a alias_words original_words
  local original_current=$CURRENT ret

  if [[ -z ${aliases[$alias_name]-} ]]; then
    _terragrunt "$@"
    return
  fi

  alias_words=(${(z)aliases[$alias_name]})
  original_words=("${words[@]}")
  words=("${alias_words[@]}" "${original_words[@][2,-1]}")
  CURRENT=$((original_current + ${#alias_words} - 1))

  _terragrunt
  ret=$?

  words=("${original_words[@]}")
  CURRENT=$original_current
  return ret
}

compdef _terragrunt_alias tg tga tgc tgd tgf tgi tgiu tgo tgoj tgp tgv tgs tgt tgsh

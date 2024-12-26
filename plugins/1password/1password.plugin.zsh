# Do nothing if op is not installed
(( ${+commands[op]} )) || return

# If the completion file doesn't exist yet, we need to autoload it and
# bind it to `op`. Otherwise, compinit will have already done that.
if [[ ! -f "$ZSH_CACHE_DIR/completions/_op" ]]; then
  typeset -g -A _comps
  autoload -Uz _op
  _comps[op]=_op
fi

op completion zsh >| "$ZSH_CACHE_DIR/completions/_op" &|

# Load opswd function
autoload -Uz opswd


# List of commands to inject secrets into before running
OP_RUN_WRAPPER_CMDS=()
OP_RUN_WRAPPER_ORIGINAL_PROMPT=$PROMPT
OP_RUN_WRAPPER_SYMBOL="🔑"

# Currently we take a simple approach and set aliases to override each command, this could be done with functions instead
# Also ignoring the option to specify specific environment files with the `--env-file` flag
function set_op_aliases() {
  for cmd in "${OP_RUN_WRAPPER_CMDS[@]}"; do
    alias "$cmd"="op run -- $cmd"
  done
}

function unset_op_aliases() {
  for cmd in "${OP_RUN_WRAPPER_CMDS[@]}"; do
    unalias "$cmd" 2>/dev/null
  done
}

function set_prompt() {
  OP_RUN_WRAPPER_ORIGINAL_PROMPT=$PROMPT
  export PROMPT="(${OP_RUN_WRAPPER_SYMBOL}) ${PROMPT}"
}

function unset_prompt() {
  export PROMPT="${OP_RUN_WRAPPER_ORIGINAL_PROMPT}"
}
 
function toggle_secrets_injection() {
  if [[ -z "${OP_RUN_WRAPPER_CMDS[*]}" ]]; then
    echo "Error: OP_RUN_WRAPPER_CMDS is empty, please update the list of commands which require secrets injection."
    zle reset-prompt
    return 1
  fi
  
  if [[ -z "$OP_RUN_WRAPPER_ACTIVE" ]]; then
    export OP_RUN_WRAPPER_ACTIVE=true
    set_op_aliases   
    set_prompt    
  else
    unset OP_RUN_WRAPPER_ACTIVE
    unset_op_aliases  
    unset_prompt     
  fi

  zle reset-prompt 
}

zle -N toggle_secrets_injection
bindkey '^O' toggle_secrets_injection 
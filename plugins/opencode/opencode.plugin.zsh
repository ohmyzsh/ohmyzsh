if (( ! $+commands[opencode] )); then
  return
fi

# -------------------------------------------------------------------
# Aliases — core TUI
# -------------------------------------------------------------------

alias oc='opencode'
alias occ='opencode --continue'
alias ocfc='opencode --fork --continue'
alias ocm='opencode --model'
alias ocp='opencode --prompt'
alias ocpu='opencode --pure'

# -------------------------------------------------------------------
# Aliases — run (non-interactive)
# -------------------------------------------------------------------

alias ocr='opencode run'
alias ocrc='opencode run --continue'
alias ocrs='opencode run --share'
alias ocrj='opencode run --format json'
alias ocrf='opencode run --file'
alias ocra='opencode run --attach'
alias ocrq='opencode run --dangerously-skip-permissions'

# -------------------------------------------------------------------
# Aliases — server
# -------------------------------------------------------------------

alias ocs='opencode serve'
alias ocw='opencode web'
alias oca='opencode attach'
alias ocacp='opencode acp'

# -------------------------------------------------------------------
# Aliases — auth
# -------------------------------------------------------------------

alias ocau='opencode auth'
alias oclogin='opencode auth login'
alias ocaul='opencode auth list'
alias oclogout='opencode auth logout'

# -------------------------------------------------------------------
# Aliases — models
# -------------------------------------------------------------------

alias ocmo='opencode models'
alias ocmor='opencode models --refresh'
alias ocmov='opencode models --verbose'

# -------------------------------------------------------------------
# Aliases — MCP
# -------------------------------------------------------------------

alias ocmc='opencode mcp'
alias ocmca='opencode mcp add'
alias ocmcl='opencode mcp list'
alias ocmcau='opencode mcp auth'
alias ocmclo='opencode mcp logout'
alias ocmcd='opencode mcp debug'

# -------------------------------------------------------------------
# Aliases — agents
# -------------------------------------------------------------------

alias ocag='opencode agent'
alias ocagl='opencode agent list'
alias ocagc='opencode agent create'

# -------------------------------------------------------------------
# Aliases — sessions
# -------------------------------------------------------------------

alias ocse='opencode session'
alias ocsel='opencode session list'
alias ocsed='opencode session delete'

# -------------------------------------------------------------------
# Aliases — stats
# -------------------------------------------------------------------

alias ocst='opencode stats'
alias ocstm='opencode stats --models'

# -------------------------------------------------------------------
# Aliases — export / import
# -------------------------------------------------------------------

alias ocex='opencode export'
alias ocim='opencode import'

# -------------------------------------------------------------------
# Aliases — GitHub
# -------------------------------------------------------------------

alias ocgh='opencode github'
alias ocghi='opencode github install'
alias ocghr='opencode github run'
alias ocpr='opencode pr'

# -------------------------------------------------------------------
# Aliases — plugins
# -------------------------------------------------------------------

alias ocpl='opencode plugin'
alias ocplug='opencode plug'
alias ocplg='opencode plugin --global'

# -------------------------------------------------------------------
# Aliases — debug / database
# -------------------------------------------------------------------

alias ocdbg='opencode debug'
alias ocdb='opencode db'
alias ocdbp='opencode db path'
alias ocdbm='opencode db migrate'

# -------------------------------------------------------------------
# Aliases — maintenance
# -------------------------------------------------------------------

alias ocup='opencode upgrade'
alias ocun='opencode uninstall'
alias occom='opencode completion'

# -------------------------------------------------------------------
# Completion wiring
# -------------------------------------------------------------------

: ${ZSH_CACHE_DIR:="$HOME/.cache/zsh"}

if [[ ! -f "$ZSH_CACHE_DIR/completions/_opencode" ]]; then
  typeset -g -A _comps
  autoload -Uz _opencode
  _comps[opencode]=_opencode
fi

command opencode completion zsh >! "$ZSH_CACHE_DIR/completions/_opencode" &|

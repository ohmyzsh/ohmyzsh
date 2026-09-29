# Aliases for the Claude Code CLI. Completion lives in _claude, which
# Oh My Zsh puts on $fpath before compinit runs.

(( $+commands[claude] )) || return

# Sessions
alias cl='claude'
alias clc='claude --continue'
alias clr='claude --resume'
alias clw='claude --worktree'
alias clp='claude --print'

# Background sessions
alias clbg='claude --bg'
alias clag='claude agents'
alias clat='claude attach'
alias cllog='claude logs'

# Management
alias clmcp='claude mcp'
alias clpl='claude plugin'
alias clup='claude update'
alias clur='claude update && claude'


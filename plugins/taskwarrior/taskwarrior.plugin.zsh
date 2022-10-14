zstyle ':completion:*:*:task:*' verbose yes
zstyle ':completion:*:*:task:*:descriptions' format '%U%B%d%b%u'
zstyle ':completion:*:*:task:*' group-name ''

alias t='task'
compdef _task t=task

# General reports
alias tn='task next'
alias tl='task list' # Conflict with Tmux plugin
alias tll='task long'
alias tls='task ls'
alias tlm='task minimal'
alias tall='task all'

# Handlers for general reports with due dates
alias tnd='task next +TODAY'
alias tld='task list +TODAY'
alias tlld='task long +TODAY'
alias tlsd='task ls +TODAY'
alias tlmd='task minimal +TODAY'

alias tnw='task next +WEEK'
alias tlw='task list +WEEK'
alias tllw='task long +WEEK'
alias tlsw='task ls +WEEK'
alias tlmw='task minimal +WEEK'

alias tnm='task next +MONTH'
alias tlm='task list +MONTH'
alias tllm='task long +MONTH'
alias tlsm='task ls +MONTH'
alias tlmm='task minimal +MONTH'

# Status-related reports
alias ta='task active' # Conflict with Tmux plugin
alias to='task overdue'
alias tw='task waiting'
alias tc='task completed'

# Extra reports
alias tb='task burndown' # Conflict with Toolbox plugin
alias tbd='task burndown.daily'
alias tbw='task burndown.weekly'
alias tbm='task burndown.monthly'

alias th='task history'
alias thd='task history.daily'
alias thw='task history.weekly'
alias thm='task history.monthly'
alias tha='task history.annual'

alias tg='task ghistory'
alias tgd='task ghistory.daily'
alias tgw='task ghistory.weekly'
alias tgm='task ghistory.monthly'
alias tga='task ghistory.annual'

alias tcl='task calendar'
alias ts='task summary' # Conflict with Tmux plugin

# Task handling
alias tad='task add' # Conflict with Tmux plugin
alias tmd='task modify'
alias tdl='task delete'
alias td='task done'
alias te='task edit' # Conflict with Emacs and Rails plugins
alias tu='task undo'

# Behaviour commands
alias tcx='task context'
alias tcxn='task context none'

alias tpd='task purge <(task _zshuuids status:deleted)' # Purge all deleted tasks

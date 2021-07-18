zstyle ':completion:*:*:task:*' verbose yes
zstyle ':completion:*:*:task:*:descriptions' format '%U%B%d%b%u'
zstyle ':completion:*:*:task:*' group-name ''

# GENERAL
alias t='task'                                    # t    →  task
  compdef _task t=task
alias t+='task add'                               # t+   →  add
alias t-='task delete'                            # t-   →  del
function ta(){task $1 annotate ${@:2}}            # ta   →  annotate
alias td='task done'                              # td   →  done
alias tm='task modify'                            # tm   →  modify
alias tu='task undo'                              # tu   →  undo
alias ti='task info'                              # ti   →  info
alias ts='task start'                             # ts   →  start
alias tS='task stop'                              # tS   →  stop

#### DISPLAY ####
alias tn='task next'                              # tn   →  next
alias tl='task long'                              # tl   →  long
alias tc='task completed'                         # tc   →  completed

#### REPORTS ####
alias trmt='task modified:today completed'        # trmt →  modified today
alias trmy='task modified:yesterday completed'    # trmy →  modified yesterday
alias trct='task end:today all'                   # trct →  closed today
alias trdt='task end:today status:completed all'  # trdt →  done today

#### BURNDOWN ####
alias tbd="task burndown.daily"                   # tbd  →  daily
alias tbw="task burndown.weekly"                  # tbw  →  weekly
alias tbm="task burndown.monthly"                 # tbd  →  monthly

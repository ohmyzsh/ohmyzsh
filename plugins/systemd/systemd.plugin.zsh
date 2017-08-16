user_commands=(
  cat
  help
  is-active
  is-enabled
  list-jobs
  list-timers
  list-unit-files
  list-units
  show
  show-environment
  status)

sudo_commands=(
  cancel
  disable
  edit
  enable
  isolate
  kill
  link
  load
  mask
  preset
  reenable
  reload
  reset-failed
  restart
  set-environment
  start
  stop
  try-restart
  unmask
  unset-environment)

for c in $user_commands; do; alias sc-$c="systemctl $c"; done
for c in $sudo_commands; do; alias sc-$c="sudo systemctl $c"; done

alias sc-enable-now="sc-enable --now"
alias sc-disable-now="sc-disable --now"
alias sc-mask-now="sc-mask --now"

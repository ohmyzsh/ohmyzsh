user_commands=(
  list-units is-active status show help list-unit-files
  is-enabled list-jobs show-environment cat)

dash_user_commands=(
  start stop restart status enable disable edit cat
  )

sudo_commands=(
  start stop reload restart try-restart isolate kill
  reset-failed enable disable reenable preset mask unmask
  link load cancel set-environment unset-environment
  edit)

for c in $user_commands; do; alias sc-$c="systemctl $c"; done
for c in $dash_user_commands; do; alias sc-user-$c="systemctl --user $c"; done
for c in $sudo_commands; do; alias sc-$c="sudo systemctl $c"; done

alias sc-enable-now="sc-enable --now"
alias sc-disable-now="sc-disable --now"
alias sc-mask-now="sc-mask --now"
alias sc-user-dr="systemctl --user daemon-reload"

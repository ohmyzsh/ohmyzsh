user_commands=(
  list-units is-active status show help list-unit-files
  is-enabled list-jobs show-environment)

sudo_commands=(
  start stop reload restart try-restart isolate kill
  reset-failed enable disable reenable preset mask unmask
  link load cancel set-environment unset-environment)

for c in $user_commands; do; alias sc-$c="systemctl $c"; done
# Do not use sudo for root user
if [ "`id -u`" = "0" ]; then
   for c in $sudo_commands; do; alias sc-$c="systemctl $c"; done
else
   for c in $sudo_commands; do; alias sc-$c="sudo systemctl $c"; done
fi

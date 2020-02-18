user_commands=(
  list-units is-active status show help list-unit-files
  is-enabled list-jobs show-environment cat list-timers)

sudo_commands=(
  start stop reload restart try-restart isolate kill
  reset-failed enable disable reenable preset mask unmask
  link load cancel set-environment unset-environment
  edit)

for c in $user_commands; do; alias sc-$c="systemctl $c"; done
for c in $sudo_commands; do; alias sc-$c="sudo systemctl $c"; done
for c in $user_commands; do; alias scu-$c="systemctl --user $c"; done
for c in $sudo_commands; do; alias scu-$c="systemctl --user $c"; done

alias sc-enable-now="sc-enable --now"
alias sc-disable-now="sc-disable --now"
alias sc-mask-now="sc-mask --now"

alias scu-enable-now="scu-enable --now"
alias scu-disable-now="scu-disable --now"
alias scu-mask-now="scu-mask --now"

function systemd_prompt_info {
  local unit
  local unitdisplay
  for unit in $@; do
    [[ -n "$ZSH_THEME_SYSTEMD_PROMPT_CAPS" ]] && unitdisplay=${(U)unit} || unitdisplay=$unit
    echo -n "$ZSH_THEME_SYSTEMD_PROMPT_PREFIX$unitdisplay:"
    if systemctl is-active $unit; then
        echo -n $ZSH_THEME_SYSTEMD_PROMPT_ACTIVE 
    else
        echo -n $ZSH_THEME_SYSTEMD_PROMPT_NOTACTIVE
    fi
    echo -en "$ZSH_THEME_SYSTEMD_PROMPT_SUFFIX"
  done
}


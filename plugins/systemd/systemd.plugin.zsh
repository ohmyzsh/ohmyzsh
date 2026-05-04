# systemctl aliases
user_commands=(
  cat
  get-default
  help
  is-active
  is-enabled
  is-failed
  is-system-running
  list-dependencies
  list-jobs
  list-sockets
  list-timers
  list-unit-files
  list-units
  show
  show-environment
  status
)

sudo_commands=(
  add-requires
  add-wants
  cancel
  daemon-reexec
  daemon-reload
  default
  disable
  edit
  emergency
  enable
  halt
  import-environment
  isolate
  kexec
  kill
  link
  list-machines
  load
  mask
  preset
  preset-all
  reenable
  reload
  reload-or-restart
  reset-failed
  rescue
  restart
  revert
  set-default
  set-environment
  set-property
  start
  stop
  switch-root
  try-reload-or-restart
  try-restart
  unmask
  unset-environment
)

power_commands=(
  hibernate
  hybrid-sleep
  poweroff
  reboot
  suspend
)

if [[ -z "$ZSH_THEME_SYSTEMD_PRIVILEGE_TOOL" ]]; then
  ZSH_THEME_SYSTEMD_PRIVILEGE_TOOL="sudo"
fi

# Error messages are defined in variables for better formatting
privilege_tool_error_msg="\
zsh systemd plugin:
  \$ZSH_THEME_SYSTEMD_PRIVILEGE_TOOL is set to unknown value
  Use 'custom' if the one you use in unsupported, or
  'builtin-polkit' if you want to use builtin authentication methods.
  Defaulting to 'sudo'"

privilege_tool_custom_error_msg="\
zsh systemd plugin:
  \$ZSH_THEME_SYSTEMD_PRIVILEGE_TOOL is set to 'custom', but
  \$ZSH_THEME_SYSTEMD_PRIVILEGE_TOOL_CUSTOM is not set.
  Defaulting to 'sudo'"

case "$ZSH_THEME_SYSTEMD_PRIVILEGE_TOOL" in
  builtin-polkit)
    # Since all the privilege escalation is done by systemctl itself, it's 
    # easier to alias them as unprivileged
    user_commands+=( "${sudo_commands[@]}" )
    unset sudo_commands
    privilege_tool=""
    ;;
  custom)
    if [[ -n "$ZSH_THEME_SYSTEMD_PRIVILEGE_TOOL_CUSTOM" ]]; then
      privilege_tool="$ZSH_THEME_SYSTEMD_PRIVILEGE_TOOL_CUSTOM"  
    else
      print "$privilege_tool_custom_error_msg" >&2
      privilege_tool="sudo"
    fi
    ;;
  sudo)
    privilege_tool="sudo"
    ;;
  sudo-rs)
    privilege_tool="sudo-rs"
    ;;
  doas)
    privilege_tool="doas"
    ;;
  pkexec)
    privilege_tool="pkexec"
    ;;
  run0)
    privilege_tool="run0"
    ;;
  *)
    print "$privilege_tool_error_msg" >&2
    privilege_tool="sudo"
    ;;
esac

for c in $user_commands; do
  alias "sc-$c"="systemctl $c"
  alias "scu-$c"="systemctl --user $c"
done

for c in $sudo_commands; do
  alias "sc-$c"="$privilege_tool systemctl $c"
  alias "scu-$c"="systemctl --user $c"
done

for c in $power_commands; do
  alias "sc-$c"="systemctl $c"
done

unset c user_commands sudo_commands power_commands privilege_tool
unset privilege_tool_error_msg privilege_tool_custom_error_msg


# --now commands
alias sc-enable-now="sc-enable --now"
alias sc-disable-now="sc-disable --now"
alias sc-mask-now="sc-mask --now"

alias scu-enable-now="scu-enable --now"
alias scu-disable-now="scu-disable --now"
alias scu-mask-now="scu-mask --now"

# --failed commands
alias scu-failed='systemctl --user --failed'
alias sc-failed='systemctl --failed'

function systemd_prompt_info {
  local unit
  for unit in "$@"; do
    echo -n "$ZSH_THEME_SYSTEMD_PROMPT_PREFIX"

    if [[ -n "$ZSH_THEME_SYSTEMD_PROMPT_CAPS" ]]; then
      echo -n "${(U)unit:gs/%/%%}:"
    else
      echo -n "${unit:gs/%/%%}:"
    fi

    if systemctl is-active "$unit" &>/dev/null; then
      echo -n "$ZSH_THEME_SYSTEMD_PROMPT_ACTIVE"
    elif systemctl --user is-active "$unit" &>/dev/null; then
      echo -n "$ZSH_THEME_SYSTEMD_PROMPT_ACTIVE"
    else
      echo -n "$ZSH_THEME_SYSTEMD_PROMPT_NOTACTIVE"
    fi

    echo -n "$ZSH_THEME_SYSTEMD_PROMPT_SUFFIX"
  done
}

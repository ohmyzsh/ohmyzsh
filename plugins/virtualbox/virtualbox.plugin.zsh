# VirtualBox aliases

ZSH_PLUGIN_VIRTUALBOX_ALIAS_PREFIX="${ZSH_PLUGIN_VIRTUALBOX_ALIAS_PREFIX:-vbox}"

# VBoxManage
declare -A manage_commands=(
  ["start"]="startvm"
  ["start-headless"]="startvm --type=headless"
  ["clone"]="clonevm --register"
  ["create"]="createvm --register"
  ["create-medium"]="createmedium"
  ["discard"]="discardstate"
  ["delete"]="unregistervm --delete"
  ["control"]="controlvm"
  ["info"]="showvminfo"
  ["list"]="list"
)

for c in "${(k)manage_commands[@]}"; do
  alias "${ZSH_PLUGIN_VIRTUALBOX_ALIAS_PREFIX}-${c}"="VBoxManage ${manage_commands[${c}]}"
done

unset c manage_commands

# Functions
function ${ZSH_PLUGIN_VIRTUALBOX_ALIAS_PREFIX}-poweroff() {
  VBoxManage controlvm "$1" poweroff
}

function ${ZSH_PLUGIN_VIRTUALBOX_ALIAS_PREFIX}-shutdown() {
  VBoxManage controlvm "$1" shutdown
}

function ${ZSH_PLUGIN_VIRTUALBOX_ALIAS_PREFIX}-pause() {
  VBoxManage controlvm "$1" pause
}

function ${ZSH_PLUGIN_VIRTUALBOX_ALIAS_PREFIX}-resume() {
  VBoxManage controlvm "$1" resume
}

function ${ZSH_PLUGIN_VIRTUALBOX_ALIAS_PREFIX}-save() {
  VBoxManage controlvm "$1" savestate
}

function ${ZSH_PLUGIN_VIRTUALBOX_ALIAS_PREFIX}-reboot() {
  VBoxManage controlvm "$1" reboot
}

function ${ZSH_PLUGIN_VIRTUALBOX_ALIAS_PREFIX}-reset() {
  VBoxManage controlvm "$1" reset
}

alias "${ZSH_PLUGIN_VIRTUALBOX_ALIAS_PREFIX}-stop"="${ZSH_PLUGIN_VIRTUALBOX_ALIAS_PREFIX}-shutdown"

# VirtualBox prompt
function virtualbox_prompt_info() {
  if [[ -n "${ZSH_THEME_VIRTUALBOX_PROMPT_COUNT}" ]]; then
    local vm_count="$(VBoxManage list runningvms | wc -l)"
    local vm_total="$(VBoxManage list vms | wc -l)"

    echo -n "${ZSH_THEME_VIRTUALBOX_PROMPT_PREFIX}"
    echo -n "${vm_count} / ${vm_total}"
    echo -n "${ZSH_THEME_VIRTUALBOX_PROMPT_SUFFIX}"
  fi

  local vm_name
  for vm_name in "$@"; do
    echo -n "${ZSH_THEME_VIRTUALBOX_PROMPT_PREFIX}"

    if [[ -n "${ZSH_THEME_VIRTUALBOX_PROMPT_CAPS}" ]]; then
      echo -n "${(U)vm_name:gs/%/%%}:"
    else
      echo -n "${vm_name:gs/%/%%}:"
    fi

    if VBoxManage list runningvms | grep -w "\"${vm_name}\"" &>/dev/null; then
      echo -n "${ZSH_THEME_VIRTUALBOX_PROMPT_RUNNING}"
    else
      echo -n "${ZSH_THEME_VIRTUALBOX_PROMPT_NOTRUNNING}"
    fi

    echo -n "${ZSH_THEME_VIRTUALBOX_PROMPT_SUFFIX}"
  done
}

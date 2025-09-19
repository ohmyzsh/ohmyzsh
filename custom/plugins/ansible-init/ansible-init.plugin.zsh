# ansible-init OMZ plugin
# Path: ~/.oh-my-zsh/custom/plugins/ansible-init/ansible-init.plugin.zsh
# Features:
#  - ansible-init new [NAME] [PATH] [--minimal|--standard|--full] [--force]
#  - ansible-init group add <GROUP> [PROJECT]
#  - ansible-init host  add <HOSTNAME> <IP> [PROJECT]
#  - works with "new ." to scaffold in current directory
#  - completions + extensions loader

# --- Config -------------------------------------------------------------------
: ${ANSIBLE_INIT_BASE:="$HOME/Downloads/"}   # default projects root
: ${ANSIBLE_INIT_DEFAULT_NAME:="ansible_temp"}           # default project name
: ${ANSIBLE_INIT_MODE:="standard"}                      # minimal|standard|full

# --- Utils --------------------------------------------------------------------
_ans_i_echo() { print -P "%F{cyan}[ansible-init]%f $*"; }
_ans_i_err()  { print -P "%F{red}[ansible-init]%f $*" >&2; }

# mkdir -p if missing
_ans_i_mk() { [[ -d "$1" ]] || mkdir -p "$1" }

# Create/overwrite file conditionally
# usage: _ans_i_write <path> <content> [force(0|1)]
_ans_i_write() {
  local path="$1"; shift
  local content="$1"; shift
  local force="${1:-0}"
  if [[ -e "$path" && "$force" != "1" ]]; then
    _ans_i_echo "skip: $path (exists)"
    return 0
  fi
  print -r -- "$content" > "$path"
  _ans_i_echo "write: $path"
}

# Global help
_ans_i_usage() {
  cat <<'USAGE'
ansible-init — быстрый каркас и утилиты для Ansible-проектов

Использование:
  ansible-init [--help|-h]
  ansible-init new [NAME] [PATH] [--minimal|--standard|--full] [--force] [--help|-h]
  ansible-init group add <GROUP> [PROJECT] [--help|-h]
  ansible-init host  add <HOSTNAME> <IP> [PROJECT] [--help|-h]

Подсказки:
  • ansible-init new .                   # каркас прямо в текущей папке
  • ansible-init new myproj .            # создаст ./myproj
  • ANSIBLE_INIT_BASE=/path ansible-init new myproj
  • Режимы наполнения: --minimal | --standard (по умолчанию) | --full

Переменные окружения:
  ANSIBLE_INIT_BASE            Базовый путь (по умолчанию: $HOME/Movies/Work/Scripting)
  ANSIBLE_INIT_DEFAULT_NAME    Имя проекта по умолчанию (x-ui-server)
  ANSIBLE_INIT_MODE            Режим по умолчанию: minimal|standard|full
USAGE
}

# --- Scaffold writer blocks ---------------------------------------------------
# Each file respects ANSIBLE_INIT_MODE

_ans_i_write_ansible_cfg() {
  local target="$1" force="$2"
  if [[ "$ANSIBLE_INIT_MODE" == "minimal" ]]; then
    _ans_i_write "$target/ansible.cfg" \
'[defaults]
inventory = inventories/production/hosts.yml
roles_path = roles
' "$force"
  else
    _ans_i_write "$target/ansible.cfg" \
'[defaults]
inventory = inventories/production/hosts.yml
roles_path = roles
host_key_checking = False
retry_files_enabled = False
' "$force"
  fi
}

_ans_i_write_hosts_yml() {
  local target="$1" force="$2"
  if [[ "$ANSIBLE_INIT_MODE" == "minimal" ]]; then
    _ans_i_write "$target/inventories/production/hosts.yml" \
'all:
  vars:
    ansible_user: ernestsh
    ansible_python_interpreter: /usr/bin/python3.11
  hosts:
    # jump-1:
    #   ansible_host: <SERVER_IP>
' "$force"
  else
    _ans_i_write "$target/inventories/production/hosts.yml" \
'all:
  vars:
    ansible_user: ernestsh
    ansible_python_interpreter: /usr/bin/python3.11
  hosts:
    jump-1:
      ansible_host: <SERVER_IP>
' "$force"
  fi
}

_ans_i_write_group_vars_all() {
  local target="$1" force="$2"
  if [[ "$ANSIBLE_INIT_MODE" == "minimal" ]]; then
    _ans_i_write "$target/inventories/production/group_vars/all.yml" \
'---
# Добавляй сюда общие переменные, например:
# timezone: Europe/Moscow
# packages_common: [nano, tmux, git, zsh, ufw, fail2ban]
' "$force"
  else
    _ans_i_write "$target/inventories/production/group_vars/all.yml" \
'---
timezone: Europe/Moscow
packages_common:
  - nano
  - tmux
  - git
  - zsh
  - ufw
  - fail2ban
' "$force"
  fi
}

_ans_i_write_site_yml() {
  local target="$1" force="$2"
  if [[ "$ANSIBLE_INIT_MODE" == "minimal" ]]; then
    _ans_i_write "$target/site.yml" \
'---
- name: Your first playbook
  hosts: all
  become: true
  roles:
    - common  # создай роль и добавь туда задачи
' "$force"
  else
    _ans_i_write "$target/site.yml" \
'---
- name: Base configuration
  hosts: all
  become: true
  roles:
    - common
' "$force"
  fi
}

_ans_i_write_common_tasks() {
  local target="$1" force="$2"
  if [[ "$ANSIBLE_INIT_MODE" == "minimal" ]]; then
    _ans_i_write "$target/roles/common/tasks/main.yml" \
'---
# Пример первых задач:
# - name: Ensure packages present
#   dnf:
#     name: "{{ packages_common }}"
#     state: present
#
# - name: Set timezone
#   timezone:
#     name: "{{ timezone | default(\"Europe/Moscow\") }}"
' "$force"
  else
    _ans_i_write "$target/roles/common/tasks/main.yml" \
'---
- name: Ensure common packages are installed
  dnf:
    name: "{{ packages_common }}"
    state: present

- name: Set system timezone
  timezone:
    name: "{{ timezone }}"
' "$force"
  fi
}

_ans_i_write_readme_if_full() {
  local target="$1" force="$2"
  if [[ "$ANSIBLE_INIT_MODE" == "full" ]]; then
    _ans_i_write "$target/README.md" \
'# Infrastructure

## Быстрый старт
1) Правь inventories/production/hosts.yml → ansible_host
2) Запуск:
   ansible-playbook -i inventories/production/hosts.yml site.yml --check --diff
   ansible-playbook -i inventories/production/hosts.yml site.yml

## Полезно
- ansible-doc dnf
- ansible-lint
- molecule
' "$force"
  fi
}

# --- Scaffold ---------------------------------------------------------------
_ans_i_scaffold() {
  local project_name="$1"
  local target="${2:-$ANSIBLE_INIT_BASE/$project_name}"
  local force="${3:-0}"

  # Support "new ." or empty name => use current directory
  if [[ -z "$project_name" || "$project_name" == "." ]]; then
    target="$PWD"
    project_name="${project_name:-$(basename "$PWD")}"
  elif [[ "$target" == "." ]]; then
    target="$PWD/$project_name"
  fi

  _ans_i_mk "$target"/{inventories/production/group_vars,roles/common/{tasks,templates,files,defaults}}

  _ans_i_write_ansible_cfg        "$target" "$force"
  _ans_i_write_hosts_yml          "$target" "$force"
  _ans_i_write_group_vars_all     "$target" "$force"
  _ans_i_write_site_yml           "$target" "$force"
  _ans_i_write_common_tasks       "$target" "$force"
  _ans_i_write_readme_if_full     "$target" "$force"

  _ans_i_echo "✅ scaffold ready: $target (mode: $ANSIBLE_INIT_MODE)"
}

# --- Inventory helpers --------------------------------------------------------
_ans_i_group_add() {
  local group="$1"
  local project="${2:-$ANSIBLE_INIT_BASE/$ANSIBLE_INIT_DEFAULT_NAME}"
  [[ "$group" == "-h" || "$group" == "--help" ]] && { print "usage: ansible-init group add <GROUP> [PROJECT]"; return 0; }
  if [[ -z "$group" ]]; then _ans_i_err "group name required"; return 1; fi
  local gv="$project/inventories/production/group_vars/$group.yml"
  _ans_i_mk "$(dirname "$gv")"
  _ans_i_write "$gv" \
'---
# group vars for '"$group"'
' 0
  _ans_i_echo "✅ group_vars created: $gv"
}

_ans_i_host_add() {
  local host="$1"
  local ip="$2"
  local project="${3:-$ANSIBLE_INIT_BASE/$ANSIBLE_INIT_DEFAULT_NAME}"
  [[ "$host" == "-h" || "$host" == "--help" ]] && { print "usage: ansible-init host add <HOSTNAME> <IP> [PROJECT]"; return 0; }
  if [[ -z "$host" || -z "$ip" ]]; then
    _ans_i_err "usage: ansible-init host add <name> <ip> [project_path]"
    return 1
  fi
  local inv="$project/inventories/production/hosts.yml"
  if ! grep -q "^all:" "$inv" 2>/dev/null; then
    _ans_i_err "inventory not found or invalid: $inv"
    return 1
  fi
  if grep -q "^[[:space:]]*$host:" "$inv"; then
    _ans_i_echo "host exists: $host -> updating ansible_host"
    awk -v h="$host" -v ip="$ip" '
      $0 ~ "^[[:space:]]*"h":" {print; getline; print "      ansible_host: "ip; skip=1; next}
      skip==1 { if ($0 ~ /ansible_host:/) { skip=0; next } }
      {print}
    ' "$inv" > "$inv.tmp" && mv "$inv.tmp" "$inv"
  else
    _ans_i_echo "adding host: $host ($ip)"
    printf "    %s:\n      ansible_host: %s\n" "$host" "$ip" >> "$inv"
  fi
}

# --- CLI ----------------------------------------------------------------------
ansible-init() {
  local cmd="$1"; shift

  # Global help
  if [[ -z "$cmd" || "$cmd" == "-h" || "$cmd" == "--help" || "$cmd" == "help" ]]; then
    _ans_i_usage; return 0
  fi

  case "$cmd" in
    new)
      # per-subcommand help
      if [[ "$1" == "-h" || "$1" == "--help" ]]; then
        print "usage: ansible-init new [NAME] [PATH] [--minimal|--standard|--full] [--force]"
        print "tips:  ansible-init new .    # здесь; NAME возьмём из текущей папки"
        return 0
      fi

      # Collect args (name, path, flags)
      local name="" path="" force_flag=0
      local args=("$@")
      for a in "${args[@]}"; do
        case "$a" in
          --minimal)  ANSIBLE_INIT_MODE=minimal ;;
          --standard) ANSIBLE_INIT_MODE=standard ;;
          --full)     ANSIBLE_INIT_MODE=full ;;
          --force)    force_flag=1 ;;
          -h|--help)  print "usage: ansible-init new [NAME] [PATH] [--minimal|--standard|--full] [--force]"; return 0 ;;
          *)
            if [[ -z "$name" ]]; then name="$a"
            elif [[ -z "$path" ]]; then path="$a"
            fi
            ;;
        esac
      done

      # Default name if omitted (only when not using ".")
      [[ -z "$name" ]] && name="$ANSIBLE_INIT_DEFAULT_NAME"
      # If user said "new ." => scaffold here
      if [[ "$name" == "." ]]; then
        _ans_i_scaffold "." "$PWD" "$force_flag"
      else
        if [[ "$path" == "." ]]; then
          _ans_i_scaffold "$name" "$PWD/$name" "$force_flag"
        else
          _ans_i_scaffold "$name" "${path:-$ANSIBLE_INIT_BASE/$name}" "$force_flag"
        fi
      fi
      ;;
    group)
      local sub="$1"; shift
      [[ "$sub" == "-h" || "$sub" == "--help" ]] && { print "usage: ansible-init group add <GROUP> [PROJECT]"; return 0; }
      case "$sub" in
        add) _ans_i_group_add "$@";;
        *)   _ans_i_err "unknown: group $sub"; return 1;;
      esac
      ;;
    host)
      local sub="$1"; shift
      [[ "$sub" == "-h" || "$sub" == "--help" ]] && { print "usage: ansible-init host add <HOSTNAME> <IP> [PROJECT]"; return 0; }
      case "$sub" in
        add) _ans_i_host_add "$@";;
        *)   _ans_i_err "unknown: host $sub"; return 1;;
      esac
      ;;
    *)
      _ans_i_err "unknown command: $cmd"; _ans_i_usage; return 1;;
  esac
}

# --- Completions --------------------------------------------------------------
_ans_i_complete() {
  local -a subcmds
  subcmds=(help new group host)
  if (( CURRENT == 2 )); then
    compadd "${subcmds[@]}" -h --help
  else
    case "$words[2]" in
      new)   compadd --minimal --standard --full --force -h --help ;;
      group) compadd add -h --help ;;
      host)  compadd add -h --help ;;
      *)     compadd -h --help ;;
    esac
  fi
}
compdef _ans_i_complete ansible-init

# --- Extensions loader --------------------------------------------------------
# Доп. команды можно класть как *.zsh в .../plugins/ansible-init/extensions/
_ans_i_extdir="${0:A:h}/extensions"
if [[ -d "$_ans_i_extdir" ]]; then
  for _f in "$_ans_i_extdir"/*.zsh(.N); do
    source "$_f"
  done
fi
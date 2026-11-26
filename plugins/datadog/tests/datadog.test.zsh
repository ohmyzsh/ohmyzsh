#!/usr/bin/env zsh

# Run with: zsh -df plugins/datadog/tests/datadog.test.zsh
emulate -L zsh

local plugin="${0:A:h:h}/datadog.plugin.zsh"
local test_dir=$(mktemp -d)
typeset -i failures=0 tests=0

# Keep the background completion job away from the user's cache
export ZSH_CACHE_DIR="$test_dir/cache"
mkdir -p "$ZSH_CACHE_DIR/completions"

# Make sure that an override on this machine does not change the results
unset ZSH_DATADOG_AGENT_BINARY
mkdir -p "$test_dir/empty-path"

# check_alias <description> <alias> <expected value, or empty if the alias must not exist>
# Reads the aliases that the plugin defined, from the alias list in $defined.
check_alias() {
  local description=$1 name=$2 expected=$3 actual=${defined[$2]}
  (( tests++ ))
  if [[ "$actual" == "$expected" ]]; then
    print -r -- "PASS: $description: $name"
  else
    print -u2 -r -- "FAIL: $description: $name -> '$actual' (expected '$expected')"
    (( failures++ ))
  fi
}

# load_plugin <ostype> <commands to add, as name=path...>
# Loads the plugin in a subshell and prints the aliases that it defines.
# Only the given commands exist, so that a real sudo or Agent on this machine does not change the results.
load_plugin() {
  local ostype=$1 entry
  shift
  (
    unalias -a
    PATH="$test_dir/empty-path"
    hash -r
    for entry; do commands[${entry%%=*}]=${entry#*=}; done
    OSTYPE=$ostype
    source "$plugin"
    alias -L
  )
}

# parse_aliases: reads `alias -L` lines into the associative array $defined
typeset -A defined
parse_aliases() {
  defined=()
  local line name value
  for line in "${(@f)1}"; do
    line=${line#alias }
    [[ $line == '-- '* ]] && line=${line#-- }
    name=${line%%=*}
    value=${(Q)${line#*=}}
    defined[$name]=$value
  done
}

if (( EUID == 0 )); then
  local root_prefix=""
else
  local root_prefix="sudo "
fi

# Linux, with sudo
parse_aliases "$(load_plugin linux-gnu datadog-agent=/bin/echo sudo=/bin/echo)"
check_alias "linux with sudo" ddog "${root_prefix}datadog-agent"
check_alias "the dd command is not hidden" dd ""
check_alias "linux with sudo" dds "${root_prefix}datadog-agent status"
check_alias "linux with sudo" ddf "${root_prefix}datadog-agent flare"
check_alias "linux with sudo" ddcfg "${root_prefix}datadog-agent config"
check_alias "linux with sudo" ddc "sudo -u dd-agent -- datadog-agent check"
check_alias "linux has no Windows alias" ddrs ""
check_alias "linux has no Windows alias" ddgui ""

# Linux, without sudo (for example, a root shell in a container)
parse_aliases "$(load_plugin linux-gnu datadog-agent=/bin/echo)"
check_alias "linux without sudo" dds "datadog-agent status"
check_alias "linux without sudo" ddc "datadog-agent check"

# Linux, with a binary that is not in $PATH
parse_aliases "$(ZSH_DATADOG_AGENT_BINARY=/opt/datadog-agent/bin/agent/agent load_plugin linux-gnu)"
check_alias "linux with override" ddv "/opt/datadog-agent/bin/agent/agent version"

# macOS: the system-wide install (LaunchDaemon) uses sudo, the per-user install does not.
# The LaunchDaemon file is real, so the expected result depends on this machine.
local mac_prefix=""
if [[ -f /Library/LaunchDaemons/com.datadoghq.agent.plist ]] && (( EUID != 0 )); then
  mac_prefix="sudo "
fi
parse_aliases "$(load_plugin darwin25.0 datadog-agent=/bin/echo sudo=/bin/echo)"
check_alias "macos" dds "${mac_prefix}datadog-agent status"
check_alias "macos" ddf "${mac_prefix}datadog-agent flare"
check_alias "macos" ddc "${mac_prefix}datadog-agent check"
check_alias "macos" ddgui "${mac_prefix}datadog-agent launch-gui"
check_alias "macos has no Windows alias" ddst ""

# macOS, without sudo: the aliases run the Agent directly
parse_aliases "$(load_plugin darwin25.0 datadog-agent=/bin/echo)"
check_alias "macos without sudo" dds "datadog-agent status"

# macOS, with the Agent not in $PATH: the plugin uses the default install location
if [[ -x /opt/datadog-agent/bin/agent/agent ]]; then
  parse_aliases "$(load_plugin darwin25.0 sudo=/bin/echo)"
  check_alias "macos default location" ddv "${mac_prefix}/opt/datadog-agent/bin/agent/agent version"
else
  print -r -- "SKIP: macos default location (no Agent in /opt/datadog-agent)"
fi

# Linux, without the Agent: the plugin defines no aliases
parse_aliases "$(load_plugin linux-gnu sudo=/bin/echo)"
check_alias "linux without the Agent" ddog ""

# Windows (MSYS2 or Git Bash), Agent found in the default install location.
# sudo must not be used, even when a sudo command exists.
local win_agent="$test_dir/Program Files/Datadog/Datadog Agent/bin/agent.exe"
mkdir -p "${win_agent:h}" && touch "$win_agent"
cygpath() { print -r -- "$test_dir/Program Files" }
parse_aliases "$(load_plugin msys sudo=/bin/echo)"
check_alias "windows" ddog "${(q-)win_agent}"
check_alias "windows" dds "${(q-)win_agent} status"
check_alias "windows" ddc "${(q-)win_agent} check"
check_alias "windows" ddrs "${(q-)win_agent} restart-service"
check_alias "windows" ddst "${(q-)win_agent} start-service"
check_alias "windows" ddsp "${(q-)win_agent} stop-service"
check_alias "windows" ddgui "${(q-)win_agent} launch-gui"

# Cygwin, with a custom install location
parse_aliases "$(ZSH_DATADOG_AGENT_BINARY='/cygdrive/d/Data dog/agent.exe' load_plugin cygwin)"
check_alias "cygwin with override" dds "'/cygdrive/d/Data dog/agent.exe' status"

unfunction cygpath
rm -rf "$test_dir"

print -r -- "$tests tests, $failures failures"
(( failures == 0 ))

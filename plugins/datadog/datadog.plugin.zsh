# Aliases and completion for the Datadog Agent CLI
# (`datadog-agent` on Linux and macOS, `agent.exe` on Windows).

() {
  local agent_bin agent_path

  # Find the Agent binary: user override, then $PATH, then the default install location
  if [[ -n "$ZSH_DATADOG_AGENT_BINARY" ]]; then
    agent_bin="$ZSH_DATADOG_AGENT_BINARY"
  elif (( $+commands[datadog-agent] )); then
    agent_bin=datadog-agent
  elif [[ "$OSTYPE" == darwin* && -x /opt/datadog-agent/bin/agent/agent ]]; then
    agent_bin=/opt/datadog-agent/bin/agent/agent
  elif [[ "$OSTYPE" == (cygwin|msys)* ]]; then
    for agent_path in \
      "$(cygpath -u "$ProgramW6432" 2>/dev/null)/Datadog/Datadog Agent/bin/agent.exe" \
      "/c/Program Files/Datadog/Datadog Agent/bin/agent.exe" \
      "/cygdrive/c/Program Files/Datadog/Datadog Agent/bin/agent.exe"; do
      if [[ -f "$agent_path" ]]; then
        agent_bin="$agent_path"
        break
      fi
    done
  fi

  [[ -n "$agent_bin" ]] || return 0

  local agent="${(q-)agent_bin}" check_agent="${(q-)agent_bin}"

  # On Linux, the Agent commands need root, and checks must run as the dd-agent user.
  # On macOS, the system-wide install (LaunchDaemon) needs root, and the per-user install does not.
  # On Windows, run the shell as Administrator instead.
  if [[ "$OSTYPE" == linux* ]] && (( $+commands[sudo] )); then
    (( EUID == 0 )) || agent="sudo $agent"
    check_agent="sudo -u dd-agent -- $check_agent"
  elif [[ "$OSTYPE" == darwin* && -f /Library/LaunchDaemons/com.datadoghq.agent.plist ]] \
    && (( EUID != 0 && $+commands[sudo] )); then
    agent="sudo $agent"
    check_agent="sudo $check_agent"
  fi

  alias ddog="$agent"
  alias ddc="$check_agent check"
  alias ddcc="$agent configcheck"
  alias ddcfg="$agent config"
  alias dddiag="$agent diagnose"
  alias ddh="$agent health"
  alias ddhn="$agent hostname"
  alias ddl="$agent stream-logs"
  alias dds="$agent status"
  alias ddv="$agent version"

  # Windows and macOS: open the Agent GUI in the browser
  if [[ "$OSTYPE" == (cygwin|msys|darwin)* ]]; then
    alias ddgui="$agent launch-gui"
  fi
}

# COMPLETION FUNCTION
if (( ! $+commands[datadog-agent] )); then
  return
fi

# If the completion file doesn't exist yet, we need to autoload it and
# bind it to `datadog-agent`. Otherwise, compinit will have already done that.
if [[ ! -f "$ZSH_CACHE_DIR/completions/_datadog-agent" ]]; then
  typeset -g -A _comps
  autoload -Uz _datadog-agent
  _comps[datadog-agent]=_datadog-agent
fi

zmodload -F zsh/files b:zf_mv
() {
  local TMPPREFIX="$ZSH_CACHE_DIR/completions/._datadog-agent"
  zf_mv -f -- =( datadog-agent completion zsh < /dev/null 2> /dev/null ) "$ZSH_CACHE_DIR/completions/_datadog-agent"
} &|

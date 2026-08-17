#!/usr/bin/zsh -df

set -euo pipefail

if (( $# != 2 )); then
  print -u2 "Usage: $0 <manager> <positive|negative>"
  exit 1
fi

manager="$1"
scenario="$2"

if [[ "$scenario" != "positive" && "$scenario" != "negative" ]]; then
  print -u2 "scenario must be 'positive' or 'negative'"
  exit 1
fi

repo_root="${0:A:h:h:h}"
tmp==(:)
workspace="$tmp/workspace"
home_dir="$tmp/home"
cache_dir="$tmp/cache"
zshrc="$tmp/.zshrc"

mkdir -p "$workspace" "$home_dir" "$cache_dir"

manager_install=''
manager_source=''

case "$manager" in
  antigen)
    manager_install='git clone https://github.com/zsh-users/antigen.git "$MANAGER_HOME/antigen" >/dev/null 2>&1'
    manager_source='source "$MANAGER_HOME/antigen/antigen.zsh"'
    ;;
  zinit)
    manager_install='git clone https://github.com/zdharma-continuum/zinit.git "$MANAGER_HOME/zinit" >/dev/null 2>&1'
    manager_source='source "$MANAGER_HOME/zinit/zinit.zsh"'
    ;;
  zgen)
    manager_install='git clone https://github.com/tarjoilija/zgen.git "$MANAGER_HOME/zgen" >/dev/null 2>&1'
    manager_source='source "$MANAGER_HOME/zgen/zgen.zsh"'
    ;;
  zplug)
    manager_install='git clone https://github.com/zplug/zplug "$MANAGER_HOME/zplug" >/dev/null 2>&1'
    manager_source='export ZPLUG_HOME="$MANAGER_HOME/zplug"; source "$ZPLUG_HOME/init.zsh"'
    ;;
  antibody)
    manager_install='command -v go >/dev/null 2>&1; export GOBIN="$MANAGER_HOME/bin"; mkdir -p "$GOBIN"; go install github.com/getantibody/antibody@latest >/dev/null 2>&1'
    manager_source='"$MANAGER_HOME/bin/antibody" --version >/dev/null 2>&1'
    ;;
  zulu)
    manager_install='git clone https://github.com/zulu-zsh/zulu.git "$MANAGER_HOME/zulu" >/dev/null 2>&1'
    manager_source='source "$MANAGER_HOME/zulu/zulu.zsh"'
    ;;
  *)
    print -u2 "Unsupported manager: $manager"
    exit 1
    ;;
esac

cat > "$zshrc" <<RC
set -euo pipefail

export HOME="$home_dir"
export XDG_CACHE_HOME="$cache_dir"
export OMZ_ROOT="$repo_root"
export ZSH="\$OMZ_ROOT"
export MANAGER_HOME="$workspace/$manager"
mkdir -p "\$MANAGER_HOME"

$manager_install
$manager_source
RC

if [[ "$scenario" == "positive" ]]; then
  cat >> "$zshrc" <<'RC'
source "$OMZ_ROOT/lib/bootstrap.zsh"
[[ "${OMZ_IS_BOOTSTRAPPED:-}" == true ]] || { print -u2 "bootstrap signal missing before OMZ load"; return 1; }
RC
else
  cat >> "$zshrc" <<'RC'
[[ -z "${OMZ_IS_BOOTSTRAPPED:-}" ]] || { print -u2 "bootstrap signal unexpectedly set without hook"; return 1; }
source "$OMZ_ROOT/lib/bootstrap.zsh"
RC
fi

cat >> "$zshrc" <<RC
[[ "\${OMZ_IS_BOOTSTRAPPED:-}" == true ]] || { print -u2 "bootstrap signal not set before OMZ entrypoint sourcing"; return 1; }

source "\$OMZ_ROOT/lib/functions.zsh"
source "\$OMZ_ROOT/plugins/git/git.plugin.zsh"
source "\$OMZ_ROOT/themes/robbyrussell.zsh-theme"

[[ -d "\$ZSH_CACHE_DIR/completions" ]] || { print -u2 "completions cache directory missing"; return 1; }

touch "\$ZSH_CACHE_DIR/completions/_ci_${manager}_${scenario}" || { print -u2 "completion cache write failed"; return 1; }
[[ -f "\$ZSH_CACHE_DIR/completions/_ci_${manager}_${scenario}" ]] || { print -u2 "completion cache file missing"; return 1; }
RC

zsh -df "$zshrc"
print -u2 "\e[32mSuccess\e[0m $manager $scenario"

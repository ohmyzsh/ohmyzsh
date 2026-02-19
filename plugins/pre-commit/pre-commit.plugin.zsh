# Aliases for pre-commit
alias prc='pre-commit'

alias prcau='pre-commit autoupdate'

alias prcr='pre-commit run'
alias prcra='pre-commit run --all-files'
alias prcrf='pre-commit run --files'

# Auto install

## Settings

# Filename of the pre-commit file to look for
: ${ZSH_PRE_COMMIT_CONFIG_FILE:=.pre-commit-config.yaml}

# Path to the file containing installed paths
: ${ZSH_PRE_COMMIT_INSTALLED_LIST:="${ZSH_CACHE_DIR:-$ZSH/cache}/pre-commit-installed.list"}

# Default setting for auto install to prompt
: ${ZSH_PRE_COMMIT_AUTO_INSTALL:="prompt"}

## Functions

autoload -U add-zsh-hook
if [[ "$ZSH_PRE_COMMIT_AUTO_INSTALL" == "off" ]]; then
  add-zsh-hook -d chpwd auto_install_pre_commit
  return
fi

auto_install_pre_commit() {
  if [[ ! -f "$ZSH_PRE_COMMIT_CONFIG_FILE" ]]; then
    return
  fi

  local dirpath="${PWD:A}"

  # early return if already installed
  if command grep -Fx -q "$dirpath" "$ZSH_PRE_COMMIT_INSTALLED_LIST" &>/dev/null; then
    return
  fi

  if [[ "$ZSH_PRE_COMMIT_AUTO_INSTALL" == "prompt" ]]; then
    local confirmation

    touch "$ZSH_PRE_COMMIT_INSTALLED_LIST"

    # get cursor column and print new line before prompt if not at line beginning
    local column
    echo -ne "\e[6n" > /dev/tty
    read -t 1 -s -d R column < /dev/tty
    column="${column##*\[*;}"
    [[ $column -eq 1 ]] || echo

    # print same-line prompt and output newline character if necessary
    echo -n "pre-commit: found '$ZSH_PRE_COMMIT_CONFIG_FILE' file. Install hooks? ([Y]es/[A]sk again/[N]ever)"
    read -k 1 confirmation
    [[ "$confirmation" = $'\n' ]] || echo

    # check input
    case "$confirmation" in
      [yY]) ;; # yes
      [aA]) return ;; # ask again
      [nN]) echo "$dirpath" >> "$ZSH_PRE_COMMIT_INSTALLED_LIST"; return ;; # never ask again
      *) return ;; # interpret anything else as ask again
    esac
  fi

  # check if pre-commit is installed
  if ! type pre-commit > /dev/null; then
    echo "You need to install pre-commit first. https://pre-commit.com/#install can help you out.";
    return
  fi

  pre-commit install && echo "$dirpath" >> "$ZSH_PRE_COMMIT_INSTALLED_LIST"
}

add-zsh-hook chpwd auto_install_pre_commit
auto_install_pre_commit

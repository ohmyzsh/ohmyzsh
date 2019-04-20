main() {
  # Use colors, but only if connected to a terminal, and that terminal
  # supports them.
  if which tput >/dev/null 2>&1; then
      ncolors=$(tput colors)
  fi
  if [ -t 1 ] && [ -n "$ncolors" ] && [ "$ncolors" -ge 8 ]; then
    RED="$(tput setaf 1)"
    GREEN="$(tput setaf 2)"
    YELLOW="$(tput setaf 3)"
    BLUE="$(tput setaf 4)"
    BOLD="$(tput bold)"
    NORMAL="$(tput sgr0)"
  else
    RED=""
    GREEN=""
    YELLOW=""
    BLUE=""
    BOLD=""
    NORMAL=""
  fi

  # Only enable exit-on-error after the non-critical colorization stuff,
  # which may fail on systems lacking tput or terminfo
  set -e

  if ! command -v zsh >/dev/null 2>&1; then
    printf "${YELLOW}Zsh is not installed!${NORMAL} Please install zsh first!\n"
    exit
  fi

  if [ ! -n "$ZSH" ]; then
    ZSH=~/.oh-my-zsh
  fi

  if [ -d "$ZSH" ]; then
    printf "${YELLOW}You already have Oh My Zsh installed.${NORMAL}\n"
    printf "You'll need to remove $ZSH if you want to re-install.\n"
    exit
  fi

  # Prevent the cloned repository from having insecure permissions. Failing to do
  # so causes compinit() calls to fail with "command not found: compdef" errors
  # for users with insecure umasks (e.g., "002", allowing group writability). Note
  # that this will be ignored under Cygwin by default, as Windows ACLs take
  # precedence over umasks except for filesystems mounted with option "noacl".
  umask g-w,o-w

  printf "${BLUE}Cloning Oh My Zsh...${NORMAL}\n"
  command -v git >/dev/null 2>&1 || {
    echo "Error: git is not installed"
    exit 1
  }
  # The Windows (MSYS) Git is not compatible with normal use on cygwin
  if [ "$OSTYPE" = cygwin ]; then
    if git --version | grep msysgit > /dev/null; then
      echo "Error: Windows/MSYS Git is not supported on Cygwin"
      echo "Error: Make sure the Cygwin git package is installed and is first on the path"
      exit 1
    fi
  fi
  env git clone --depth=1 https://github.com/robbyrussell/oh-my-zsh.git "$ZSH" || {
    printf "Error: git clone of oh-my-zsh repo failed\n"
    exit 1
  }


  printf "${BLUE}Looking for an existing zsh config...${NORMAL}\n"
  if [ -f ~/.zshrc ] || [ -h ~/.zshrc ]; then
    printf "${YELLOW}Found ~/.zshrc.${NORMAL} ${GREEN}Backing up to ~/.zshrc.pre-oh-my-zsh${NORMAL}\n";
    mv ~/.zshrc ~/.zshrc.pre-oh-my-zsh;
  fi

  printf "${BLUE}Using the Oh My Zsh template file and adding it to ~/.zshrc${NORMAL}\n"
  cp "$ZSH"/templates/zshrc.zsh-template ~/.zshrc
  sed "/^export ZSH=/ c\\
  export ZSH=\"$ZSH\"
  " ~/.zshrc > ~/.zshrc-omztemp
  mv -f ~/.zshrc-omztemp ~/.zshrc

  TEST_LOGIN_SHELL=$(basename "$SHELL")
  if [ "$TEST_LOGIN_SHELL" = "zsh" ]; then
    # No need to change login shell.
    ENV_ZSH="$SHELL"
  # Let's attempt to change the login shell if the STDIN file descriptor is bound to TTY.
  elif [ -t 0 ] || [ -p /dev/stdin ]; then
    # See what zsh (if any) they have in the current environment -- it's probably
    # the zsh they prefer, assuming /etc/shells could have multiple zsh entries.
    ENV_ZSH="$(which zsh)" # $(type -P zsh) would be better but not POSIX sh

    # Will it blend?
    if [ -z "$("$ENV_ZSH" -c 'print $ZSH_VERSION')" ]; then
      unset ENV_ZSH
    fi

    # Is the environment zsh also in the list of supported login shells?
    if [ -n "$ENV_ZSH" ] && grep "^${ENV_ZSH}$" /etc/shells >/dev/null 2>&1; then
      printf "${YELLOW}Found ${ENV_ZSH}${NORMAL} ${GREEN}in /etc/shells.${NORMAL}\n"
      CHSH_ZSH="$ENV_ZSH"
    else
      # No? Then let's get the last zsh entry from the list of supported login shells.
      GREP_ZSH="$(grep /zsh$ /etc/shells | tail -1)"
      # Will it blend?
      if [ ! -n "$GREP_ZSH" ] && [ -n "$("$GREP_ZSH" -c 'print $ZSH_VERSION')" ]; then
        # Yep, let's use that zsh entry.
        CHSH_ZSH="$GREP_ZSH"
      else
        if [ ! -n "$GREP_ZSH" ]; then
          # Nope, it's a blank path.
          printf "${RED}I can't change your shell automatically because there is no zsh entry in /etc/shells.${NORMAL}\n"
        else
          # Nope, it's a bogus path.
          printf "${RED}I can't change your shell automatically because there is a bad zsh entry in /etc/shells.${NORMAL}\n"
        fi
        if [ -n "$ENV_ZSH" ]; then
          # If the environment zsh is real, suggest they add that to the list of supported login shells.
          printf "${BLUE}Consider adding $ENV_ZSH to /etc/shells and then manually change your default shell.${NORMAL}\n"
        else
          printf "${RED}No real zsh found in the current environment or /etc/shells.${NORMAL}\n"
          printf "${RED}You might not have zsh properly installed...${NORMAL}\n"
          # OKAY, IT'S GETTIN' WEIRD. BAIL OUT!
          exit
        fi
      fi
    fi

    if [ -n "$CHSH_ZSH" ]; then
      # If this platform provides a "chsh" command (not Cygwin), do it, man!
      if hash chsh >/dev/null 2>&1; then
        printf "${BLUE}Time to change your default shell to ${CHSH_ZSH}!${NORMAL}\n"
        # CTRL-C at the chsh password prompt will bubble up and kill this script,
        # so we set a benign trap on the INT signal to stop the bubbling.
        trap 'true' INT
        # We need a loop so the user can retry after entering a bad password.
        while true; do
          # Attempt to change the default login shell.
          CHSH_ZSH_STDERR="$(chsh -s "$CHSH_ZSH" 2>&1)" && {
            # Great. It worked.
            printf "${BLUE}Default login shell changed to: ${CHSH_ZSH}\n${NORMAL}"
            # Update the $SHELL export for this session.
            SHELL="$CHSH_ZSH"
            break
          } || {
            case $? in
              # On CTRL-C, chsh returns 130.
              130)
                # The user cancelled changing the default login shell at the password prompt.
                printf "${RED}Change of default login shell has been cancelled!${NORMAL}\n"
                printf "${BLUE}To try again, run the following command at any time:\n${NORMAL}"
                printf '    %schsh -s "%s"%s\n' "${BLUE}" "$CHSH_ZSH" "${NORMAL}"
                # Probably best to fall back to the environment zsh if it exists.
                if [ -n "$ENV_ZSH" ]; then
                  unset CHSH_ZSH
                fi
                break
              ;;
              # Some other error code.
              *)
                case "$CHSH_ZSH_STDERR" in
                  # The user entered a wrong password.
                  *Credentials*)
                    printf "${RED}Wrong password!${NORMAL} ${GREEN}Press CTRL-C to cancel.${NORMAL}\n"
                  ;;
                  # The user entered an empty password.
                  *Empty*)
                    printf "${RED}Empty password!${NORMAL} ${GREEN}Press CTRL-C to cancel.${NORMAL}\n"
                  ;;
                  # Unhandled error.
                  *)
                    printf "${RED}There was a problem changing the default login shell! See below.${NORMAL}\n"
                    printf "${RED}${CHSH_ZSH_STDERR}${NORMAL}\n"
                    # Probably best to fall back to the environment zsh if it exists.
                    if [ -n "$ENV_ZSH" ]; then
                      unset CHSH_ZSH
                    fi
                    break
                  ;;
                esac
              ;;
            esac
          }
        done
        # Unset the INT trap.
        trap - INT
      # Else, suggest the user change the login shell manually.
      else
        printf "I can't change your shell automatically because this system does not have chsh.\n"
        printf "${BLUE}Please manually change your default login shell to ${CHSH_ZSH}!${NORMAL}\n"
      fi
    fi
  else
    printf "${BLUE}No input TTY! You will have to manually change your default login shell to zsh.${NORMAL}\n"
  fi

  printf "${GREEN}"
  echo '         __                                     __   '
  echo '  ____  / /_     ____ ___  __  __   ____  _____/ /_  '
  echo ' / __ \/ __ \   / __ `__ \/ / / /  /_  / / ___/ __ \ '
  echo '/ /_/ / / / /  / / / / / / /_/ /    / /_(__  ) / / / '
  echo '\____/_/ /_/  /_/ /_/ /_/\__, /    /___/____/_/ /_/  '
  echo '                        /____/                       ....is now installed!'
  echo ''
  echo ''
  echo 'Please look over the ~/.zshrc file to select plugins, themes, and options.'
  echo ''
  echo 'p.s. Follow us at https://twitter.com/ohmyzsh.'
  echo ''
  echo 'p.p.s. Get stickers and t-shirts at https://shop.planetargon.com.'
  echo ''
  printf "${NORMAL}"
  
  if [ ! -t 0 ] || [ -p /dev/stdin ]; then
    # Zsh exits immeditaly after invocation if STDIN is not a TTY, so it would be
    # pointless to exec it in the first place. Let's just print a message instead.
    printf "${BLUE}No input TTY! To begin using Oh My Zsh, start a new zsh session!${NORMAL}\n"
    exit
  elif [ -n "$CHSH_ZSH" ]; then
    exec "$CHSH_ZSH" --LOGIN
  else
    exec "$ENV_ZSH"
  fi
}

main

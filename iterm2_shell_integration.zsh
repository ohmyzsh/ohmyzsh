# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

if [[ -o interactive ]]; then
  if [ "$ITERM_ENABLE_SHELL_INTEGRATION_WITH_TMUX""$TERM" != "screen" -a "$ITERM_SHELL_INTEGRATION_INSTALLED" = "" ]; then
    ITERM_SHELL_INTEGRATION_INSTALLED=Yes
    ITERM2_SHOULD_DECORATE_PROMPT="1"
    # Indicates start of command output. Runs just before command executes.
    iterm2_before_cmd_executes() {
      printf "\033]133;C;\007"
    }

    iterm2_set_user_var() {
      printf "\033]1337;SetUserVar=%s=%s\007" "$1" $(printf "%s" "$2" | base64 | tr -d '\n')
    }

    # Users can write their own version of this method. It should call
    # iterm2_set_user_var but not produce any other output.
    # e.g., iterm2_set_user_var currentDirectory $PWD
    # Accessible in iTerm2 (in a badge now, elsewhere in the future) as
    # \(user.currentDirectory).
    whence -v iterm2_print_user_vars > /dev/null 2>&1
    if [ $? -ne 0 ]; then
      iterm2_print_user_vars() {
      }
    fi

    iterm2_print_state_data() {
      printf "\033]1337;RemoteHost=%s@%s\007" "$USER" "$iterm2_hostname"
      printf "\033]1337;CurrentDir=%s\007" "$PWD"
      iterm2_print_user_vars
    }

    # Report return code of command; runs after command finishes but before prompt
    iterm2_after_cmd_executes() {
      printf "\033]133;D;%s\007" "$STATUS"
      iterm2_print_state_data
    }

    # Mark start of prompt
    iterm2_prompt_mark() {
      printf "\033]133;A\007"
    }

    # Mark end of prompt
    iterm2_prompt_end() {
      printf "\033]133;B\007"
    }

    # There are three possible paths in life.
    #
    # 1) A command is entered at the prompt and you press return.
    #    The following steps happen:
    #    * iterm2_preexec is invoked
    #      * PS1 is set to ITERM2_PRECMD_PS1
    #      * ITERM2_SHOULD_DECORATE_PROMPT is set to 1
    #    * The command executes (possibly reading or modifying PS1)
    #    * iterm2_precmd is invoked
    #      * ITERM2_PRECMD_PS1 is set to PS1 (as modified by command execution)
    #      * PS1 gets our escape sequences added to it
    #    * zsh displays your prompt
    #    * You start entering a command
    #
    # 2) You press ^C while entering a command at the prompt.
    #    The following steps happen:
    #    * (iterm2_preexec is NOT invoked)
    #    * iterm2_precmd is invoked
    #      * iterm2_before_cmd_executes is called since we detected that iterm2_preexec was not run
    #      * (ITERM2_PRECMD_PS1 and PS1 are not messed with, since PS1 already has our escape
    #        sequences and ITERM2_PRECMD_PS1 already has PS1's original value)
    #    * zsh displays your prompt
    #    * You start entering a command
    #
    # 3) A new shell is born.
    #    * PS1 has some initial value, either zsh's default or a value set before this script is sourced.
    #    * iterm2_precmd is invoked
    #      * ITERM2_SHOULD_DECORATE_PROMPT is initialized to 1
    #      * ITERM2_PRECMD_PS1 is set to the initial value of PS1
    #      * PS1 gets our escape sequences added to it
    #    * Your prompt is shown and you may begin entering a command.
    #
    # Invariants:
    # * ITERM2_SHOULD_DECORATE_PROMPT is 1 during and just after command execution, and "" while the prompt is
    #   shown and until you enter a command and press return.
    # * PS1 does not have our escape sequences during command execution
    # * After the command executes but before a new one begins, PS1 has escape sequences and
    #   ITERM2_PRECMD_PS1 has PS1's original value.
    iterm2_decorate_prompt() {
      # This should be a raw PS1 without iTerm2's stuff. It could be changed during command
      # execution.
      ITERM2_PRECMD_PS1="$PS1"
      ITERM2_SHOULD_DECORATE_PROMPT=""

      # Add our escape sequences just before the prompt is shown.
      if [[ $PS1 == *'$(iterm2_prompt_mark)'* ]]
      then
        PS1="$PS1%{$(iterm2_prompt_end)%}"
      else
        PS1="%{$(iterm2_prompt_mark)%}$PS1%{$(iterm2_prompt_end)%}"
      fi
    }

    iterm2_precmd() {
      local STATUS="$?"
      if [ -z "$ITERM2_SHOULD_DECORATE_PROMPT" ]; then
        # You pressed ^C while entering a command (iterm2_preexec did not run)
        iterm2_before_cmd_executes
      fi

      iterm2_after_cmd_executes "$STATUS"

      if [ -n "$ITERM2_SHOULD_DECORATE_PROMPT" ]; then
        iterm2_decorate_prompt
      fi
    }

    # This is not run if you press ^C while entering a command.
    iterm2_preexec() {
      # Set PS1 back to its raw value prior to executing the command.
      PS1="$ITERM2_PRECMD_PS1"
      ITERM2_SHOULD_DECORATE_PROMPT="1"
      iterm2_before_cmd_executes
    }

    # If hostname -f is slow on your system, set iterm2_hostname prior to sourcing this script.
    [[ -z "$iterm2_hostname" ]] && iterm2_hostname=`hostname -f 2>/dev/null`
    # some flavors of BSD (i.e. NetBSD and OpenBSD) don't have the -f option
    if [ $? -ne 0 ]; then
      iterm2_hostname=`hostname`
    fi

    [[ -z $precmd_functions ]] && precmd_functions=()
    precmd_functions=($precmd_functions iterm2_precmd)

    [[ -z $preexec_functions ]] && preexec_functions=()
    preexec_functions=($preexec_functions iterm2_preexec)

    iterm2_print_state_data
    printf "\033]1337;ShellIntegrationVersion=6;shell=zsh\007"
  fi
fi
alias imgcat=~/.oh-my-zsh/tools/iterm2/imgcat;alias imgls=~/.oh-my-zsh/tools/iterm2/imgls;alias it2attention=~/.oh-my-zsh/tools/iterm2/it2attention;alias it2check=~/.oh-my-zsh/tools/iterm2/it2check;alias it2copy=~/.oh-my-zsh/tools/iterm2/it2copy;alias it2dl=~/.oh-my-zsh/tools/iterm2/it2dl;alias it2getvar=~/.oh-my-zsh/tools/iterm2/it2getvar;alias it2setcolor=~/.oh-my-zsh/tools/iterm2/it2setcolor;alias it2setkeylabel=~/.oh-my-zsh/tools/iterm2/it2setkeylabel;alias it2ul=~/.oh-my-zsh/tools/iterm2/it2ul;alias it2universion=~/.oh-my-zsh/tools/iterm2/it2universion

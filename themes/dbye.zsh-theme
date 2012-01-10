# A prompt theme for oh-my-zsh, based largely on prompt_clint that
# ships with zsh. The vcs_info zstyle is a slightly modified version 
# of what you'll find in the kolo oh-my-zsh theme, using asterisks 
# instead of UTF-8 characters as the repo status indicators.

# The $pcc array holds colours. The defaults work well on a black or blue 
# background, but if you want to customize them, you just need to set your
# overrides in ~/.zshrc *before* the line that loads oh-my-zsh.sh. The 
# different values are:

# pcc[1] - paired characters - [], (), <>. By default these are yellow if
#          you're logged in over ssh, red otherwise
# pcc[2] - the informational text on the first line - date, and ruby version
#          information
# pcc[3] - user@host on the second line. Note that if you are currently
#          running as root, user is picked out with pcc[7] text on a pcc[6]
#          background (black on red by default)
# pcc[4] - Screen WINDOW (2nd line, after user@host) and zsh/$SHLVL, 3rd line
# pcc[5] - history number, 3rd line
# pcc[6] - background colour for user portion of user@host if current shell
#          is running with EUID 0
# pcc[7] - foreground colour for user portion of user@host if current shell
#          is running with EUID 0

# The first line of the prompt displays the current date and time. If you
# use rbenv or rvm, you will also get a summary of the current Ruby version.
#
# For rbenv, you will see the current ruby version, followed by one of:
# "/rbenv(global)" if the version is set in ~/.rbenv/version
# "/rbenv(local)" if the version is set in ./rbenv-version
# "/rbenv(shell)" if the version is set in the $RBENV_VERSION envar.
# "/rbenv" if, for some reason, we're unable to detect any of the preceding.
#
# rvm users will see the current rvm environment, as printed by rvm-prompt,
# followed by "/rvm". 
#
# In both cases, if you are currently using the system default ruby,
# you will see "system (`ruby --version | awk '{prnit $2}'`)" followed by
# the rbenv- or rvm-specific information.
#
# If you use neither rbenv or rvm, you'll just get the date/time.
#
# The second line shows you the user@host of the current session, followed by
# the current screen WINDOW (if the current shell is running directly under
# a screen session), followed by ":" and your current working directory.
#
# The third line shows the string "zsh" followed by "/$SHLVL" if $SHLVL is
# greater than 1, followed by the history number of the last command, followed
# by the exit status of the last command, if not 0, followed by any vcs 
# information if the current directory is under version control (git and
# svn are enabled by default), followed by either "$" in your default text
# colour, or "#" in bold red if currently running as root.
#
# The vcs info is customized:
# For git, show (git) [${branchname}${staged}${unstaged}${untracked}], where
# ${branchname} is the name of the currently checked-out branch,
# ${staged} is a bold green '*' (indicating staged changes in the repo)
# ${unstaged} is a bold yellow '*' (unstaged changes in the repo), and
# ${untracked} is a bold red '*', indicating files that are not tracked and 
#       not ignored in either a global ignores or a local .gitignore file.

############################
# DISCLAIMER
# This is my first attempt at writing a useable zsh prompt. I have been
# using clint for the last year or so, but wanted to integrate ruby and
# git repo status information. I imagine there are better ways of doing 
# what I have done, so feel free to make any such improvements.

local -a pcc
local -A pc
local p_date p_win p_user p_usercwd p_ruby_ver p_shlvlhist p_rc p_end

autoload -Uz vcs_info

# zstyles for the vcs_info bits
# Taken more or less unchanged from the kolo theme
# The only difference is that I use a plain ASCII * character,
# instead of the UTF-8 character, to indicate repo status.
zstyle ':vcs_info:*' stagedstr '%F{green}*'
zstyle ':vcs_info:*' unstagedstr '%F{yellow}*'
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:(sv[nk]|bzr):*' branchformat '%b%F{1}:%F{11}%r'
zstyle ':vcs_info:*' enable git svn


pcc[1]=${pcc[1]:-${${SSH_CLIENT+'yellow'}:-'red'}}
pcc[2]=${pcc[2]:-'cyan'}
pcc[3]=${pcc[3]:-'green'}
pcc[4]=${pcc[4]:-'yellow'}
pcc[5]=${pcc[5]:-'white'}
pcc[6]=${pcc[6]:-'red'}
pcc[7]=${pcc[7]:-'black'}

pc['\[']="%{$fg[$pcc[1]]%}["
pc['\]']="%{$fg[$pcc[1]]%}]"
pc['<']="%{$fg[$pcc[1]]%}<"
pc['>']="%{$fg[$pcc[1]]%}>"
pc['\(']="%{$fg[$pcc[1]]%}("
pc['\)']="%{$fg[$pcc[1]]%})"

# Set the date:
p_date="$pc['\[']%F{$pcc[2]}%D{%a %y/%m/%d %R %Z}$pc['\]']"

# If screen is running, add its current window number to the prompt
[[ -n "$WINDOW" ]] && p_win="$pc['\(']%{$fg[$pcc[4]]%}$WINDOW$pc['\)']"

# If running as root, make user name standout in prompt - black on red.
p_user="%(0#.%{$bg[$pcc[6]]$fg[$pcc[7]]%}%n%{$bg[default]%}.%{$fg[$pcc[3]]%}%n)"

p_usercwd="$pc['<']$p_user%{$fg[$pcc[3]]%}@%m%{$fg[default]%}$p_win%{$fg[$pcc[5]]%}:%{$fg[$pcc[4]]%}%~$pc['>']"

p_ruby_ver="%(2V.$pc['\[']%{$fg[$pcc[2]]%}%2v/%3v$pc['\]'].)"

p_shlvlhist="%{$fg_bold[$pcc[4]]%}zsh%(2L./$SHLVL.) %b%{$fg[$pcc[5]]%}%h "
p_rc="%(?..%{$pc['\[']%}%{$fg[red]%}%?%1v%{$pc['\]']%} )"

# As an additional reminder, set the prompt character to print in red
# if the shell's EUID is 0
p_end="%f%B%(0#.%{$fg[red]%}.)%#%f%b "

PROMPT='$p_date$p_ruby_ver 
$p_usercwd
$p_shlvlhist$p_rc$vcs_info_msg_0_$p_end'

PS2='%(4_.\.)%3_> %E'

autoload -U add-zsh-hook
add-zsh-hook precmd prompt_setup_precmd

prompt_setup_precmd () {
  setopt noxtrace noksharrays localoptions
  local vcstype ruby rbenv_scope
  psvar=()

  [[ $exitstatus -ge 128 ]] && psvar[1]=" $signals[$exitstatus-127]" ||
        psvar[1]=""

  # Try rbenv first, then rvm.
  if $(which rbenv 2>&1 > /dev/null); then
    ruby="$(rbenv version-name)"

    # Are we in the global, local or shell-specific environment?
    rbenv_scope=`rbenv version-origin`
    
    case $rbenv_scope in
      *variable ) 
          psvar[3]="rbenv(shell)" ;;
      *.rbenv-version ) 
          psvar[3]="rbenv(local)" ;;
      *version ) 
          psvar[3]="rbenv(global)" ;;
      *)  psvar[3]="rbenv" ;;
    esac
  elif $(which rvm 2>&1 > /dev/null); then
    ruby="${$(rvm-prompt):-system}"
    psvar[3]="rvm"
  else
    ruby=""
  fi
  case $ruby in
    "" ) psvar[2]='' ;;
    "system" ) psvar[2]="system ($(ruby --version | awk '{print $2}'))" ;;
    *) psvar[2]=$ruby ;;
  esac

  vcstype=" %{$fg_bold[$pcc[3]]%}(%s)"
  if [[ -z $(git ls-files --other --exclude-standard 2> /dev/null) ]] {
    zstyle ':vcs_info:*' formats "$vcstype [%F{cyan}%b%c%u%{$fg_bold[$pcc[3]]%}] "
  } else {
    zstyle ':vcs_info:*' formats "$vcstype [%F{cyan}%b%c%u%{$fg_bold[red]%}*%{$fg_bold[$pcc[3]]%}] "
  }

  vcs_info
}

# =====[ NAME ]=================================================================
#
# Shell Plugin

# =====[ DESCRIPTION ]==========================================================
#
# Functions for providing cleanly themeable values for basic prompt information.
#
# Each essentially exposes a simple shell parameter from `man zshparam` and
# wraps it in a prefix and suffix, so you can more cleanly apply style
# directives (i.e. color and spacing) rather than including them directly
# inline in your PROMPT.
#
# required plugins: none

# =====[ FUNCTIONS ]============================================================
#
# $(exit_status)           : %? exit status of the previous command
#
# $(prompt_displayed_time) : %* time prompt was rendered
#                          : useful for seeing the approximate time of execution
#                          : for each command
#
# $(command_number)        : %! command number associated with command
#                          : useful for using the shell's history functionality
#
# $(shell_depth)           : $SHLVL derived current shell depth; by default
#                          : ignores the shell underlying a terminal multiplexer
#                          : (i.e. tmux, screen)
#
# $(jobs_info)             : %j number of background jobs
#
# $(user_info)             : %n the current user
#
# $(host_info)             : %m the current host
#
# $(user_host_info)        : %n@%m current user and current host
#                          : with themeable separator (default is "@")
#
# $(path_info)             : %~ cwd
#
# $(prompt_character)      : %# prompt indicator

# =====[ CONFIGURABLE SETTINGS (and default values) ]===========================
# Associative array for plugin settings
typeset -gA SHELL_PLUGIN

SHELL_PLUGIN[exit_status_failure_prefix]="%{$reset_color%}%{$fg[white]%}%{$bg[red]%} "
SHELL_PLUGIN[exit_status_failure_suffix]=" %{$reset_color%}"
SHELL_PLUGIN[exit_status_success_prefix]="%{$reset_color%}%{$fg[white]%}%{$bg[green]%} "
SHELL_PLUGIN[exit_status_success_suffix]=" %{$reset_color%}"
SHELL_PLUGIN[exit_status_success_hidden]=true
#SHELL_PLUGIN[exit_status_success_hidden]=

SHELL_PLUGIN[shell_level_prefix]="%{$fg[red]%}%{$bg[white]%}"
SHELL_PLUGIN[shell_level_prefix]+="⇣"
SHELL_PLUGIN[shell_level_suffix]="%{$reset_color%}"
SHELL_PLUGIN[shell_level_includes_multiplexer]=
#SHELL_PLUGIN[shell_level_includes_multiplexer]=true

SHELL_PLUGIN[prompt_displayed_time_prefix]="%{$fg_bold[green]%}["
SHELL_PLUGIN[prompt_displayed_time_suffix]="]%{$reset_color%}"

SHELL_PLUGIN[command_number_prefix]="%{$bg[white]%}%{$fg_bold[grey]%} "
SHELL_PLUGIN[command_number_suffix]=" %{$reset_color%}"

SHELL_PLUGIN[user_info_prefix]=
SHELL_PLUGIN[user_info_suffix]=

SHELL_PLUGIN[host_info_prefix]=
SHELL_PLUGIN[host_info_suffix]=

SHELL_PLUGIN[user_host_info_prefix]=
SHELL_PLUGIN[user_host_info_suffix]=
SHELL_PLUGIN[user_host_info_divider_symbol_prefix]="%{$fg[white]%}"
SHELL_PLUGIN[user_host_info_divider_symbol]="@"
SHELL_PLUGIN[user_host_info_divider_symbol_suffix]="%{$reset_color%}"

SHELL_PLUGIN[jobs_info_prefix]=
SHELL_PLUGIN[jobs_info_suffix]=

SHELL_PLUGIN[path_info_prefix]=
SHELL_PLUGIN[path_info_suffix]=

SHELL_PLUGIN[prompt_character_prefix]=" "
SHELL_PLUGIN[prompt_character_suffix]="%{$reset_color%} "

# =====[ IMPLEMENTATION ]=======================================================

# TODO: DRY up these implementations

function exit_status() {
  local exit_status=$? 
  local result=''
  if [[ $exit_status == 0 ]]; then
    [[ -n "$SHELL_PLUGIN[exit_status_success_hidden]" ]] && return
    result+=$SHELL_PLUGIN[exit_status_success_prefix]
    result+="%?"
    result+=$SHELL_PLUGIN[exit_status_success_suffix]
  else
    result+=$SHELL_PLUGIN[exit_status_failure_prefix]
    result+="%?"
    result+=$SHELL_PLUGIN[exit_status_failure_suffix]
  fi
  echo $result
}

function shell_depth() {
  local level=$SHLVL
  ((level--))
  if [[ -z $SHELL_PLUGIN[shell_level_includes_multiplexer] ]]; then
      if [[ $STY != "" || $TMUX != "" ]]; then # ignore screen and tmux
        ((level--))
      fi
  fi
  if [[ $level -gt 0 ]]; then
    local result=''
    result+="$SHELL_PLUGIN[shell_level_prefix]"
    result+="$level"
    result+="$SHELL_PLUGIN[shell_level_suffix]"
    echo $result
  fi
}

function prompt_displayed_time() {
  local result=''
  result+="$SHELL_PLUGIN[prompt_displayed_time_prefix]"
  result+="%*"
  result+="$SHELL_PLUGIN[prompt_displayed_time_suffix]"
  echo $result
}

function command_number() {
  local result=''
  result+="$SHELL_PLUGIN[command_number_prefix]"
  result+="%!"
  result+="$SHELL_PLUGIN[command_number_suffix]"
  echo $result
}

function user_info() {
  local result=''
  result+="$SHELL_PLUGIN[user_info_prefix]"
  result+="%n"
  result+="$SHELL_PLUGIN[user_info_suffix]"
  echo $result
}

function host_info() {
  local result=''
  result+="$SHELL_PLUGIN[host_info_prefix]"
  result+="%m"
  result+="$SHELL_PLUGIN[host_info_suffix]"
  echo $result
}

function user_host_info() {
  local result=''
  result+="$SHELL_PLUGIN[user_host_info_prefix]"
  result+="$(user_info)"
  result+="$SHELL_PLUGIN[user_host_info_divider_symbol_prefix]"
  result+="$SHELL_PLUGIN[user_host_info_divider_symbol]"
  result+="$SHELL_PLUGIN[user_host_info_divider_symbol_suffix]"
  result+="$(host_info)"
  result+="$SHELL_PLUGIN[user_host_info_suffix]"
  echo $result
}

function jobs_info() {
  local result=''
  result+="$SHELL_PLUGIN[jobs_info_prefix]"
  result+="%j"
  result+="$SHELL_PLUGIN[jobs_info_suffix]"
  echo $result
}

function path_info() {
  local result=''
  result+="$SHELL_PLUGIN[path_info_prefix]"
  result+="%~"
  result+="$SHELL_PLUGIN[path_info_suffix]"
  echo $result
}

function prompt_character() {
  local result=''
  result+="$SHELL_PLUGIN[prompt_character_prefix]"
  result+="%#"
  result+="$SHELL_PLUGIN[prompt_character_suffix]"
  echo $result
}

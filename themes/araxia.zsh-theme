# -----------------------------------------------------------------------------
#    FILE                  : araxia.zsh-theme
#    DESCRIPTION           : oh-my-zsh theme file
#    AUTHOR                : Seth Milliken <seth_github@araxia.net>
#    VERSION               : 1.0
#    PLUGINS               : vcs vi-mode shell
#    TERMINAL CAPABILITIES : unicode 256color
#    SCREENSHOT            :
#    FEATURES              : - demonstrates vcs plugin, including counts of each
#                          :     type of dirty file
#                          : - demonstrates use of shell plugin to facilitate
#                          :     easily themeable, more readable standard prompt
#                          :     elements
#                          : - demonstrates use of plugin configuration with 
#                          :     associate arrays
#                          : - demonstrates entirely declarative configuration
#                          :     (all code lives in plugins to promote reuse and
#                          :     separation of concerns)
#                          : - demonstrates append technique of incrementally
#                          :      setting variables (to make configuration more
#                          :      readable and elements easier to move around)
#                          : - simple vi-mode indicator
#                          :     (prompt character changes to red)
#                          : - includes indicator of exit status of previous command
#                          : - includes indicator of shell-depth
#                          : - includes indicator of command number (for ease of
#                          :      using shell history functionality)
# -----------------------------------------------------------------------------

## Prompt # {{{
PROMPT=''
PROMPT+='$(command_number)'
PROMPT+='$(shell_depth)'
PROMPT+='$(user_host_info)'
PROMPT+='$(jobs_info)'
PROMPT+=' $(vcs_status_prompt) '
PROMPT+='$(path_info)'
PROMPT+='$(vi_mode_prompt_info)'
PROMPT+='$(prompt_character)'

RPROMPT=''
RPROMPT+='$(exit_status)'
RPROMPT+='$(prompt_displayed_time)'

# }}} prompt

## SHELL Plugin Customization # {{{
SHELL_PLUGIN[user_info_prefix]="%b%F{208}"
SHELL_PLUGIN[user_info_suffix]="%f"

SHELL_PLUGIN[host_info_prefix]="%F{039}"
SHELL_PLUGIN[host_info_suffix]="%f"

SHELL_PLUGIN[user_host_info_prefix]="[ "
SHELL_PLUGIN[user_host_info_suffix]=" ]"

SHELL_PLUGIN[jobs_info_prefix]="%{$bg[green]%}%{$fg[white]%} "
SHELL_PLUGIN[jobs_info_suffix]=" %{$reset_color%}"

SHELL_PLUGIN[path_info_prefix]="[ %F{178}"
SHELL_PLUGIN[path_info_suffix]="%f ]"

# }}} # shell
## VCS Plugin Customization # {{{

# Wrap VCS status
VCS_PLUGIN[prompt_prefix]="("
VCS_PLUGIN[prompt_suffix]=")"
VCS_PLUGIN[dirt_status_verbosity]="full"
VCS_PLUGIN[untracked_is_dirty]=
VCS_PLUGIN[include_dirty_counts]=true

# Change default modified character to `▹`: mnemonic "delta"
#VCS_PLUGIN[time_verbose]=true
VCS_PLUGIN[modified_symbol]="%{$fg_bold[green]%}"
VCS_PLUGIN[modified_symbol]+="▹"
VCS_PLUGIN[modified_symbol]+="%{$reset_color%}"

# Colors vary depending on time lapsed since last commit
VCS_PLUGIN[time_since_commit_neutral]="%{$fg[white]%}"
VCS_PLUGIN[time_since_commit_short]="%{$fg[green]%}"
VCS_PLUGIN[time_short_commit_medium]="%{$fg[yellow]%}"
VCS_PLUGIN[time_since_commit_long]="%{$fg[red]%}"

# Mercurial tweak
VCS_PLUGIN[rev_prefix]="%{$fg[green]%} "
VCS_PLUGIN[rev_suffix]="%{$reset_color%}"

# }}} vcs
## vi-mode Customization # {{{
MODE_INDICATOR="%{$fg_bold[red]%}"
#MODE_INDICATOR="%{$fg_bold[red]%}❮%{$reset_color%}%{$fg[red]%}❮❮%{$reset_color%}" # fancier alternate for RPROMPT inclusion

# }}} vi-mode

# vim: ft=zsh:fdm=marker

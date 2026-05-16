if ! hg prompt 2>/dev/null; then
    function hg_prompt_info { }
else
    function hg_prompt_info {
        hg prompt --angle-brackets "\
< on %{$fg[magenta]%}<branch>%{$reset_color%}>\
< at %{$fg[yellow]%}<tags|%{$reset_color%}, %{$fg[yellow]%}>%{$reset_color%}>\
%{$fg[green]%}<status|modified|unknown><update>%{$reset_color%}<
patches: <patches|join( → )|pre_applied(%{$fg[yellow]%})|post_applied(%{$reset_color%})|pre_unapplied(%{$fg_bold[black]%})|post_unapplied(%{$reset_color%})>>" 2>/dev/null
    }
fi

function box_name {
  local box="${SHORT_HOST:-$HOST}"
  [[ -f ~/.box-name ]] && box="$(< ~/.box-name)"
  echo "${box:gs/%/%%}"
}

PROMPT='
%{$fg[magenta]%}%n%{$reset_color%}@%{$fg[yellow]%}$(box_name)%{$reset_color%}:%{$fg_bold[green]%}%~%{$reset_color%}$(hg_prompt_info)$(git_prompt_info)
%(?,,%{${fg_bold[white]}%}[%?]%{$reset_color%} )$ '

ZSH_THEME_GIT_PROMPT_PREFIX=" (%{$fg[magenta]%}branch: "
ZSH_THEME_GIT_PROMPT_CLEAN=""
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[red]%}?"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[orange]%}!"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%})"

RPROMPT='%{$fg[red]%}%(?..✘)%{$reset_color%}'

# Add battery status if the battery plugin is enabled
if (( $+functions[battery_pct_prompt] )); then
    RPROMPT+='$(battery_time_remaining) $(battery_pct_prompt)%{$reset_color%}'
fi

# Some colors
# -----------
# Expand these right away, to minimise cycles spent expanding every prompt!
# You can override these before loading the theme.
: ${GNOSIS_C1="%{$reset_color$fg[blue]%}"}
: ${GNOSIS_C2="%{$reset_color$fg_bold[green]%}"}
: ${GNOSIS_C3="%{$reset_color$fg[cyan]%}"}
: ${GNOSIS_ACCENT1="%{$reset_color$fg[yellow]%}"}
: ${GNOSIS_ACCENT2="%{$reset_color$fg_bold[white]%}"}
: ${GNOSIS_STANDOUT="%{$fg_bold[red]%}"}

# Use ACS if the terminal supports that
typeset -A altchar
set -A altchar ${(s..)terminfo[acsc]}


# Some graphics
# -------------
# Not forgetting to set some fallbacks for non-ACS capable terminals.
# You can override these before loading too.
: ${GNOSIS_ACS_HLINE="${altchar[q]:--}"}
: ${GNOSIS_ACS_VLINE="${altchar[x]:-|}"}
: ${GNOSIS_ACS_LRCORNER="${altchar[j]:-\'}"}
: ${GNOSIS_ACS_URCORNER="${altchar[k]:-.}"}
: ${GNOSIS_ACS_ULCORNER="${altchar[l]:-,}"}
: ${GNOSIS_ACS_LLCORNER="${altchar[m]:-\`}"}
: ${GNOSIS_ACS_LTEE="${altchar[t]:-|}"}
: ${GNOSIS_ACS_RTEE="${altchar[u]:-|}"}


# Prompt fragments
# ----------------
# More early expansion where you can override things before loading.
: ${GNOSIS_PREFIX1="%{$terminfo[enacs]$terminfo[smacs]%}$GNOSIS_ACS_ULCORNER$GNOSIS_ACS_HLINE$GNOSIS_ACS_RTEE%{$terminfo[rmacs]%}"}
: ${GNOSIS_PREFIX2="%{$terminfo[smacs]%}$GNOSIS_ACS_LTEE%{$terminfo[rmacs]%}"}
: ${GNOSIS_SEP="%{$reset_color$terminfo[smacs]%}$GNOSIS_ACS_VLINE%{$terminfo[rmacs]%}"}

# Format for git_prompt_info()
ZSH_THEME_GIT_PROMPT_PREFIX=$GNOSIS_SEP
ZSH_THEME_GIT_PROMPT_SUFFIX=%{$reset_color%}

# Format for parse_git_dirty()
ZSH_THEME_GIT_PROMPT_DIRTY=$GNOSIS_STANDOUT
ZSH_THEME_GIT_PROMPT_CLEAN=$GNOSIS_ACCENT2

# Format for git_prompt_status()
ZSH_THEME_GIT_PROMPT_ADDED="${GNOSIS_C1}+"
ZSH_THEME_GIT_PROMPT_MODIFIED="${GNOSIS_C2}*"
ZSH_THEME_GIT_PROMPT_RENAMED="${GNOSIS_C3}!"
ZSH_THEME_GIT_PROMPT_UNTRACKED="${GNOSIS_ACCENT1}?"
ZSH_THEME_GIT_PROMPT_DELETED="${GNOSIS_ACCENT2}-"
ZSH_THEME_GIT_PROMPT_UNMERGED="${GNOSIS_STANDOUT}<"

# Format for git_prompt_ahead()
ZSH_THEME_GIT_PROMPT_AHEAD="${GNOSIS_STANDOUT}>"

# Format for git_prompt_long_sha() and git_prompt_short_sha()
ZSH_THEME_GIT_PROMPT_SHA_BEFORE=$GNOSIS_SEP$GNOSIS_ACCENT1
ZSH_THEME_GIT_PROMPT_SHA_AFTER=%{$reset_color%}$GNOSIS_SEP


# precmd ()
# ---------
# Recalculate terminal width and padding before every prompt!
function precmd {
    local TERMWIDTH
    (( TERMWIDTH = $COLUMNS - 1 ))	# RPROMPT leaves one space unused

    # Truncate the path if it's too long
    GNOSIS_PAD=0
    GNOSIS_TILDELEN=''

    promptstrip=$(echo "${(e):-$GNOSIS_LEFT$GNOSIS_RIGHT}" \
	|sed -e :a -e 's/%{[^}]*%}//g;/%{/N;//ba')
    promptsize=${#${(%):-$promptstrip}}
    pwdsize=${#${(%):-%~}}

    if [[ "$promptsize + $pwdsize" -gt $TERMWIDTH ]]; then
        (( GNOSIS_TILDELEN = $TERMWIDTH - $promptsize ))
    else
	(( GNOSIS_PAD = $TERMWIDTH - $promptsize - $pwdsize ))
    fi
}

# git_prompt_info ()
# ------------------
# Overrides the oh-my-zsh definition to use $(parse_git_dirty) to change
# colors rather than print extra symbols.
function git_prompt_info() {
  ref=$(git symbolic-ref HEAD 2> /dev/null) || return
  echo "$ZSH_THEME_GIT_PROMPT_PREFIX$(parse_git_dirty)${ref#refs/heads/}$ZSH_THEME_GIT_PROMPT_SUFFIX"
}

# gnosis_shlvl ()
# ---------------
# Show the value of $SHLVL if it is greater than 1.
function gnosis_shlvl {
    test 1 = "$SHLVL" && return
    echo "$GNOSIS_SEP$GNOSIS_ACCENT2^$SHLVL%{$reset_color%}"
}

# gnosis_stopped_jobs ()
# ----------------------
# Show a reminder in the prompt if there are any stopped jobs still
# attached to the shell.
function gnosis_stopped_jobs {
    local stopped=`jobs -s | wc -l | sed 's| *||'`
    [ $stopped -gt 0 ] && print "$GNOSIS_SEP$GNOSIS_STANDOUT$stopped stopped%{$reset_color%}$GNOSIS_SEP"
}


## ------------- ##
## Prompt format ##
## ------------- ##

# These two form the left and right sides of the second line of the
# prompt, their widths are counted so anything that might take up
# character cells needs to be in here, and not later.
#
# Note that the function calls are escaped, because we don't want
# to call them right now, but every time the prompt is displayed!
GNOSIS_LEFT="$GNOSIS_PREFIX1$GNOSIS_C1%n%{$reset_color%}@$GNOSIS_C1%m$GNOSIS_SEP"
GNOSIS_RIGHT=" \$(git_prompt_ahead)\$(git_prompt_status)\$(parse_git_dirty)\$(git_prompt_info)%{$reset_color%}\$(git_prompt_short_sha)"

# Main prompt
# -----------
# Print GNOSIS_LEFT up against the left side of the terminal, and
# GNOSIS_RIGHT up against the right side with the current directory in
# the gap, adding any additional padding dynamically.
PROMPT="
$GNOSIS_LEFT$GNOSIS_C2%\$GNOSIS_TILDELEN<...<%~%<<%{$reset_color%}\${(l.\$GNOSIS_PAD.. .)}$GNOSIS_RIGHT
$GNOSIS_PREFIX2$GNOSIS_ACCENT1!%!\$(gnosis_shlvl)%(?,,$GNOSIS_SEP${GNOSIS_STANDOUT}?%?)%{$reset_color%}="
RPROMPT="$GNOSIS_STANDOUT\$(gnosis_stopped_jobs)%{$reset_color%}"
PS2="$GNOSIS_PREFIX2$GNOSIS_ACCENT1!%!%{$reset_color%}+${GNOSIS_C1}%_%{$reset_color%}="

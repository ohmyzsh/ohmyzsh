# kstrauser's theme for oh-my-zsh by Kirk Strauser <kirk@strauser.com>

# Git prompt coloring was heavily influenced by the "muse" theme, but muse
# doesn't offer green smileys to indicate that the last command exited
# successfully or red frowneys to indicate failure. :)

# Define common and useful things to put in a prompt. By building a little
# library of these components, the actual PROMPT=... definition can be short,
# readable, and editable.
typeset -A prc
prc[abbrevpath]='%{${fg[red]}%}%B%45<...<%~%<<%b%{$reset_color%}'
prc[gitprompt]='%{$fg[cyan]%}$(git_prompt_info)$(git_prompt_status)%{$reset_color%}'
prc[newline]=$'\n'
prc[promptchar]='%(!.#.$)'
prc[smiley]='%(?.%{${fg[green]}%}:).%{${fg[red]}%}:()%{$reset_color%}'
prc[timestamp]='%B%{${fg[blue]}%}[%T]%{$reset_color%}%b'
prc[userspec]='%B%(!.%{${fg[red]}%}.%{${fg[green]}%})%n@%m%{$reset_color%}%b'
 
PROMPT="${prc[userspec]} ${prc[timestamp]} ${prc[gitprompt]} ${prc[abbrevpath]}${prc[newline]}${prc[smiley]} ${prc[promptchar]} %{$reset_color%}"

# Unclutter the namespace
unset prc

ZSH_THEME_GIT_PROMPT_PREFIX="("
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$fg[cyan]%})"
ZSH_THEME_GIT_PROMPT_DIRTY=" %{$fg[red]%}✘"
ZSH_THEME_GIT_PROMPT_CLEAN=" %{$fg[green]%}✔"

ZSH_THEME_GIT_PROMPT_ADDED="%{$FG[082]%}✚%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_MODIFIED="%{$FG[166]%}✹%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DELETED="%{$FG[160]%}✖%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_RENAMED="%{$FG[220]%}➜%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_UNMERGED="%{$FG[082]%}═%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$FG[190]%}✭%{$reset_color%}"

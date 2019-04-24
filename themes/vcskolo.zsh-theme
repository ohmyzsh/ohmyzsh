# Theme based on kolo with extended VCS info
autoload -Uz vcs_info

zstyle ':vcs_info:*' stagedstr '%F{green}●'
zstyle ':vcs_info:*' unstagedstr '%F{yellow}●'
zstyle ':vcs_info:*' get-revision true
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' enable git hg svn
theme_precmd () {
    if [[ -z $(git ls-files --other --exclude-standard 2> /dev/null) ]] {
        #zstyle ':vcs_info:*' formats ' [%b%c%u%B%F{green}]'
        zstyle ':vcs_info:*' formats '%F{cyan}[%b%c%u%f%F{cyan}]%f'
    } else {
        #zstyle ':vcs_info:*' formats ' [%b%c%u%B%F{red}●%F{green}]'
        zstyle ':vcs_info:*' formats '%F{cyan}[%b%c%u%f%F{red}●%f%F{cyan}]%f'
    }

    vcs_info
}

local ret_status="%(?:%{$fg_bold[green]%}➜ :%{$fg_bold[red]%}➜ )"

### Detects the VCS and shows the appropriate sign
function prompt_char {
    git branch >/dev/null 2>/dev/null && echo '±' && return
    hg root >/dev/null 2>/dev/null && echo '☿' && return
    svn info >/dev/null 2>/dev/null && echo '⚡' && return
    [[ -d CVS ]] && echo '¤' && return
    echo '%#'
}

setopt prompt_subst
autoload -U colors && colors    # Enables colours

#PROMPT='${ret_status}%(!.%B%U%F{blue}%n%f%u%b.%F{blue}%n)@%m%f %F{white}%~%f${prompt_newline} %(!.%F{red}$(prompt_char)%f.$(prompt_char)) %{$reset_color%}'
PROMPT='${ret_status} %F{247}%2~%f${prompt_newline} %(!.%F{red}$(prompt_char)%f.$(prompt_char)) %{$reset_color%}'
RPROMPT='%F{magenta}${vcs_info_msg_0_}%{$reset_color%}'

### My prompt for loops
PROMPT2='{%_}  '

### My prompt for selections
PROMPT3='{ … }  '

autoload -U add-zsh-hook
add-zsh-hook precmd  theme_precmd

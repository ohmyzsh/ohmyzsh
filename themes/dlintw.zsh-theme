# Based on cypher and 's prompt http://blog.mired.org/2011/02/adding-vcs-to-zshs-vcsinfo.html
# @author Daniel YC Lin <dlin.tw at gmail>
# Shows the exit status of the last command if non-zero
# Uses "#" instead of "»" when running with elevated privileges
PROMPT="%{$fg_bold[green]%}%D{%H:%M:%S}%(0?. . ${fg[red]}%? )%{${fg[blue]}%}$%{${reset_color}%} "

autoload -Uz vcs_info
precmd () { vcs_info }

zstyle ':vcs_info:*' get-revision true
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' formats '%u%c|%s:%b'
zstyle ':vcs_info:*' actionformats '%c%u|%s@%a:%b'
zstyle ':vcs_info:*' branchformat '%b@%r'
zstyle ':vcs_info:*' unstagedstr "%{$fg_no_bold[red]%}"
zstyle ':vcs_info:*' stagedstr "%{$fg_no_bold[yellow]%}"
zstyle ':vcs_info:*' enable fossil hg svn git cvs # p4 off, but must be last.

RPROMPT='%n@%m %{$fg_no_bold[magenta]%}%3~%{$fg_no_bold[green]%}${vcs_info_msg_0_}%{$reset_color%}'
setopt PROMPT_SUBST

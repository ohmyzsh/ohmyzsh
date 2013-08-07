# Based on cypher and 's prompt http://blog.mired.org/2011/02/adding-vcs-to-zshs-vcsinfo.html
# @author Daniel YC Lin <dlin.tw at gmail>
# Shows the exit status of the last command if non-zero
# Uses "#" instead of "$" when running as root
p_time="%K{black}%B%F{yellow}%D{%H:%M:%S}%k"
p_ret="%(0?.. %F{red}%? )"
p_ps="%B%F{blue}%(#.#.$)%b "
PROMPT="$p_time$ret$p_ps%{$reset_color%}"

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

RPROMPT='%F{green}%n@%m %F{magenta}%3~${vcs_info_msg_0_}%{$reset_color%}'
setopt PROMPT_SUBST

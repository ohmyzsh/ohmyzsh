# Based on cypher and 's prompt http://blog.mired.org/2011/02/adding-vcs-to-zshs-vcsinfo.html
# @author Daniel YC Lin <dlin.tw at gmail>
# Shows the exit status of the last command if non-zero
# Uses "#" instead of "$" when running as root

# ref: http://linux-sxs.org/housekeeping/lscolors.html
# and http://geoff.greer.fm/lscolors/
export LS_COLORS='di=1;34;47:ln=1;35:so=32;40:pi=33;40:ex=1;31:bd=31;46:cd=34;43:su=0;41:sg=0;46:tw=0;42:ow=0;43:'

# set variable debian_chroot if running in a chroot with /etc/debian_chroot
if [[ -z "$debian_chroot" ]] && [[ -r /etc/debian_chroot ]]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

p_chroot="${debian_chroot:+[$debian_chroot]}"
p_time="%K{black}%B%F{yellow}%D{%H:%M:%S}%k"
p_ret="%(0?.. %F{red}%? )"
p_ps="%B%F{blue}%(#.#.$)%b "
PROMPT="$p_chroot$p_time$p_ret$p_ps%{$reset_color%}"

autoload -Uz vcs_info
zstyle ':vcs_info:*' enable fossil hg svn git cvs # p4 off, but must be last.
precmd () { vcs_info }

zstyle ':vcs_info:*' get-revision true
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' formats '%u%c|%s:%b'
zstyle ':vcs_info:*' actionformats '%c%u|%s@%a:%b'
zstyle ':vcs_info:*' branchformat '%b@%r'
#zstyle ':vcs_info:(sv[nk]|bzr):*' branchformat '%b%F{1}:%F{3}%r'
zstyle ':vcs_info:*' unstagedstr "%{$fg_no_bold[red]%}"
zstyle ':vcs_info:*' stagedstr "%{$fg_no_bold[yellow]%}"

RPROMPT='%F{green}%n@%m %F{magenta}%3~$%{$reset_color%}${vcs_info_msg_0_}%{$reset_color%}'
setopt PROMPT_SUBST

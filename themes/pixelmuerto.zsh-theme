# inspirated in { kolo alanpeabody microtech }.zsh-theme
autoload -U colors && colors

autoload -Uz vcs_info

local localDate='%{$fg[white]%}$(date +%H:%M)%{$reset_color%}'
local userHost= #'[%n@%m] '

zstyle ':vcs_info:*' stagedstr '%F{green}+'
zstyle ':vcs_info:*' unstagedstr '%F{yellow}*'
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:(sv[nk]|bzr):*' branchformat '%b%F{1}:%F{11}%r'
zstyle ':vcs_info:*' enable git svn

# check remote branch
function git_remotes() {
  remotes=""
  if [[ -d .git ]]; then
	  if [[ $(git branch | awk '{ print $2}') == "master" ]]; then
  			git_dir=$(git rev-parse --git-dir)
	        fetchUpdate=3600 
	        remotes=()
	        for remote in $(git remote)
	        do
	                if [[ ! -e $git_dir/FETCH_HEAD ]]; then
	                        ( git fetch $remote >& /dev/null &)
	                else
							# with date (GNU coreutils)
	                        fetchDate=$(date --utc --reference=$git_dir/FETCH_HEAD +%s)
	                        now=$(date --utc +%s)
	                        delta=$(( $now - $fetchDate ))
	                        # if last update to .git/FETCH_HEAD file 
	                        if [[ $delta -gt $fetchUpdate  ]]; then
	                                ( git fetch $remote >& /dev/null &)
	                        fi
	                fi
	                if [[ $(git branch -a | grep $remote) != "" ]]; then
	                        nRemoteCommit=$(git log --oneline HEAD..$remote/master | wc -l)
	                        if [[ -f $git_dir/FETCH_HEAD && $nRemoteCommit != "0" ]]; then
	                                remotes+=" "${remote/origin/o}:$nRemoteCommit
	                        fi
	                else
	                        (git fetch $remote >& /dev/null &)
	                fi
	        done
	  fi
  fi
  echo $remotes
}
local remotes='%B%F{blue}$(git_remotes)%{$reset_color%}'

precmd () {
    if [[ -z $(git ls-files --other --exclude-standard 2> /dev/null) ]] {
        zstyle ':vcs_info:*' formats ' [%b%c%u%B%F{green}]'
    } else {
        zstyle ':vcs_info:*' formats ' [%b%c%u%B%F{red}?%F{green}]'
    }

    vcs_info
}

setopt prompt_subst
PROMPT='%B%F{white}${userHost}%~%B%F{green}${vcs_info_msg_0_}%B%F{magenta}%{$reset_color%}$ '
RPROMPT="${remotes} ${localDate}"

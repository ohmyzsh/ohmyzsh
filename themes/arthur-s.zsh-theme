setopt prompt_subst
autoload -Uz vcs_info
autoload -U add-zsh-hook

zstyle ':vcs_info:*' enable git


function git_untracked(){
    if [[ $(git rev-parse --is-inside-work-tree 2> /dev/null) == 'true' ]] && \
        git status --porcelain | grep '??' &> /dev/null ; then
        hook_com[staged]+='?'
    fi
}

function git_st() {
    local unpushed ahead behind
    local -a gitstatus

    if [[ -z `git branch --list ${hook_com[branch]}` ]] ; then
        return
    fi

    unpushed=$(git rev-list ${hook_com[branch]} "^${hook_com[branch]}@{upstream}" --count)
    gitstatus+=( "+${unpushed}" )   # unpushed commits

    ahead=$(git rev-list ${hook_com[branch]}@{upstream} "^master@{upstream}" --count)
    gitstatus+=( "+${ahead}" )      # commits on remote

    behind=$(git rev-list master@{upstream} "^${hook_com[branch]}@{u}" --count)
    gitstatus+=( "-${behind}" )    # behind origin/master

    hook_com[misc]+=${(j:|:)gitstatus}
}

function git_stash() {
    local -a stashes

    if [[ -s ${hook_com[base]}/.git/refs/stash ]] ; then
        stashes=$(git stash list 2>/dev/null | wc -l)
        hook_com[misc]+=" (${stashes} stashed)"
    fi
}

function git_remotebranch() {
    local remote
    remote=${$(git rev-parse --verify ${hook_com[branch]}@{upstream} \
        --symbolic-full-name 2>/dev/null)/refs\/remotes\/}
    if [[ -n ${remote} ]] ; then
        hook_com[branch]="${hook_com[branch]} [${remote}]"
    fi
}

zstyle ':vcs_info:git*+set-message:*' hooks git-msg
function +vi-git-msg() {
    git_untracked
    git_st
    git_stash
    # git_remotebranch
}

zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' get-revision true

prompt_precmd() {
    vcs_info
}
add-zsh-hook precmd prompt_precmd

zstyle ':vcs_info:git*'          formats "%F{117}(%25>..>%b%>>)%f %K{4}%F{117}%m%f %k%K{5} %F{180}%u %c %f%k" "[%12.12i]"
zstyle ':vcs_info:git*' actionformats "%F{200}(%25>..>%b%>>|%a)%f %K{4}%F{117}%m%f %k%K{5} %F{180}%u %c %f%k" "[%12.12i]"
zstyle ':vcs_info:git*' unstagedstr '!'
zstyle ':vcs_info:git*' stagedstr '+'

if [[ $EUID == 0 ]]; then
    PROMPT='%F{50}%2~%f ${vcs_info_msg_0_} # ' # root
else
    PROMPT='%F{50}%2~%f ${vcs_info_msg_0_} $ ' # regular user
fi

RPROMPT=$'%(?,'',%F{red}%B:(%b%f) %F{blue} %m ${vcs_info_msg_1_} [%T]  %f'

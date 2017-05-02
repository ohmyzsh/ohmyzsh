# ~/.oh-my-zsh/bashrc.sh

export LC_ALL=en_US.UTF-8

alias grep='grep --color'

# python
PATHONRC="$HOME/.pythonrc"
[[ -f $PATHONRC ]] && export PYTHONSTARTUP=$PATHONRC

# git
if [ -f ~/.oh-my-zsh/plugins/gitfast/git-prompt.sh ]; then
    . ~/.oh-my-zsh/plugins/gitfast/git-prompt.sh
fi

function _get_git_current_branch {
    echo $(__git_ps1 '%s')
}

function g {
    local cmds git_current_branch=$(_get_git_current_branch)

    case $1 in
        're'|'retrunk')
            if [ $git_current_branch = 'master' ]; then
                cmds=("git pull trunk master")
            else
                cmds=("git checkout master" "git pull trunk master" "git co $git_current_branch" "git rebase master")
            fi
            ;;
        'pu'*)
            cmds=("git $* origin $git_current_branch:$git_current_branch")
            ;;
        'clone')
            shift
            cmds=("git clone git@git.lo.mixi.jp:$*")
            ;;
        'rea'|'remote-add')
            [ $# -ne 3 ] && echo "ex. g remote-add trunk mixi/mixi.git" && return
            cmds=("git remote add $2 git@git.lo.mixi.jp:$3" "git fetch $2")
            ;;
        'ci'|'commit')
            shift
            cmds=("git commit -av $*")
            ;;
    esac

    if [ -z "$cmds" ]; then
        echo "sorry, unknown arguments given, will run \`git $*\`"
        git $@
    else
        local cmd
        for cmd in $cmds[@]; do
            echo "executing \`$cmd\`"
            (${(s/ /)cmd}) || break
        done
    fi
}

# rbenv
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"

# aws
AWS_ZSH_COMPLETER=$(which aws_zsh_completer.sh)
[[ -f $AWS_ZSH_COMPLETER ]] && source $AWS_ZSH_COMPLETER

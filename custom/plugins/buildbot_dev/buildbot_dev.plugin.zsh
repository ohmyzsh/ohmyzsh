BUILDBOT_PROJECT_PATH="$HOME/projects/buildbot/"

alias cdb='cd $BUILDBOT_PROJECT_PATH/main'
alias cdp='cd $BUILDBOT_PROJECT_PATH'
alias cdd='cd $HOME/projects/dev-tools'

alias c='cactus'
alias cj='cactus jump'
alias ct='cactus trial'
alias cjh='cactus jump home'
alias cjw='cactus jump workdir'
alias cjc='cactus jump cactus'
alias cjt='cactus jump txwebservices'
alias cja='cactus jump android'
alias cjm='cactus jump metacactus'
alias cjs='cactus jump src'
alias cjy='cactus jump yamls'
alias cjb='cactus jump buildbot'

alias m='make'
alias s='subl'

alias saguysaguy='sudo apt-get update -y && sudo apt-get upgrade -y'
alias saguysaguysagay='sudo apt-get update -y && sudo apt-get upgrade -y && sudo apt-get autoremove -y'
alias update-my-ubuntu='saguysaguysagay'

function bb_env()
{
    local BASE

    BBDIR=$1
    shift

    if [[ -z $BBDIR ]]; then
      BASE=$BUILDBOT_PROJECT_PATH/main-new/
    else
      BASE=$BBDIR
    fi
    # export __PATHBKP=$PATH
    # export PYTHONPATH=$BASE/buildbot/master:$BASE/txwebservices/install:$BASE/cactus/install:$BASE/config/tools
    # export PATH=$HOME/bin:$BASE/buildbot/master/bin:$BASE/txwebservices/install:$PATH
    # export format_warnings_path=$BASE/config
    # export warning_path=$BASE/config/latests_warnings
    # export __PS1BKP=$PS1

    # fg_blue=%{$'\e[0;34m'%}
    # fg_cyan=%{$'\e[0;36m'%}
    # fg_lgreen=%{$'\e[1;32m'%}
    # export PS1=${fg_lgreen}BBENV${fg_cyan}:$PS1

    cd $BASE/config
    . ../tosource
}

function bb_envrestore()
{
    unset BASE
    unset PYTHONPATH
    unset warning_path
    unset format_warnings_path

    # export PATH=$__PATHBKP
    # export PS1=$__PS1BKP
}

alias autopep8_cur_directory='autopep8 --ignore=E501 -i **/*.py'

function bb_repo_upload()
{
    local REVIEWERS
    local A

    declare -a REVIEWERS
    REVIEWERS=$(txw gerrit-getGroupMembers reviewers-buildbot 2> /dev/null | tr " " ",")
    echo "Reviewers: $REVIEWERS"
    echo "Cmd: repo upload --cbr --re=$REVIEWERS ."
    yes | repo upload --cbr --re=$REVIEWERS .
}

function bb_merge_bottom_branch_to_here()
{
    local branch
    local bottom_branch

    branch=$(git branch -a| grep "remotes/m/" | cut -d'/' -f5 | cut -d' ' -f1)
    case $branch in
        main)
            bottom_branch="staging"
            ;;
        staging)
            bottom_branch="prod"
            ;;
        *)
            echo "Error: unable to findout current branch!"
            return 1
    esac
    echo "Merging branch $bottom_branch to $branch..."
    cmd="git merge umg/platform/buildbot/$bottom_branch --m \"Manual merge of branch 'platform/buildbot/$bottom_branch' into 'platform/buildbot/$branch'\""
    eval $cmd
    git mergetool --no-prompt
}


function bb_push_with_care()
{
    local branch
    local project

    branch=$(git branch -a | grep "remotes/m/" | cut -d'/' -f5 | cut -d' ' -f1)
    project=$(git remote -v | grep umg | tail -n 1 | cut -d'/' -f6 | cut -d' ' -f1)

    if [[ -z $project || -z $branch ]]; then
      echo "Unable to findout branches or project name :("
      return
    fi
    echo "Pushing branch '$branch' on project '$project'"
    echo "Press Enter to continue"
    echo "Command: git push ssh://android.intel.com/a/buildbot/$project HEAD:refs/heads/platform/buildbot/$branch"
    read
    git push ssh://android.intel.com/a/buildbot/$project HEAD:refs/heads/platform/buildbot/$branch

    echo "Refreshing repo"
    echo "Waitin 30s..."
    sleep "30"
    repo sync .

    echo "Display merged tree:"
    git log --pretty=oneline --graph -3 | cat
}

function bb_start_slaves()
{
    local DIR
    DIR=$(basename $PWD)
    if [[ $DIR == "config" ]]; then
      ~/bin/buildslave start ~/data/buildbot-developer
      ~/bin/buildslave start ~/data/buildbot-developer2
    else
      ~/bin/buildslave start ~/data/buildbot/
    fi
}

function bb_stop_slaves()
{
    local DIR
    DIR=$(basename $PWD)
    if [[ $DIR == "config" ]]; then
        ~/bin/buildslave stop ~/data/buildbot-developer
        ~/bin/buildslave stop ~/data/buildbot-developer2
    else
        ~/bin/buildslave stop ~/data/buildbot/
    fi
}

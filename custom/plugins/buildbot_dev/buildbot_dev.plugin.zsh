BUILDBOT_PROJECT_PATH="$HOME/projects/buildbot/"

alias cdb='cd $BUILDBOT_PROJECT_PATH/main'
alias cdp='cd $BUILDBOT_PROJECT_PATH'
alias cdd='cd $HOME/projects/dev-tools'

alias c='cactus'
alias ci='cactus info'
alias cl='cactus log'
alias clc='cactus log -l cactus.log'
alias clm='cactus log -l master.log'
alias clt='cactus log -l testmaster.log'
alias clb='cactus log -l buildmaster.log'
alias cj='cactus jump'
alias ct='cactus trial'
alias cjh='cactus jump home'
alias cjw='cactus jump workdir'
alias cjc='cactus jump cactus'
alias cjt='cactus jump txwebservices'
alias cja='cactus jump android'
alias cjm='cactus jump metacactus'
alias cjs='cactus jump slavescripts'
alias cjy='cactus jump yamls'
alias cjb='cactus jump buildbot'
alias cjx='cactus jump xutils'
alias css='cactus slaves stop'
alias csr='cactus slaves restart'
alias cs='cactus stop'
alias cr='cactus restart'
alias crb='cactus restart ; bing'
alias crw='cactus restart --wait'
alias crwb='cactus restart --wait ; bing'
alias cR='cactus reload'
alias cRw='cactus reload --wait'
alias cRwb='cactus reload --wait ; bing'
alias crcl='cactus restart ; cactus log'
alias cRcl='cactus reload ; cactus log'
alias crcsr='cactus restart ; cactus slaves restart'
alias crwcsr='cactus restart --wait && cactus slaves restart'
alias crwcsrb='cactus restart --wait && cactus slaves restart ; bing'
alias crcsrci='cactus restart ; cactus slaves restart ; cactus info'
alias crwcsrcib='cactus restart ; cactus slaves restart ; cactus info ; binb'
alias CR='crwcsrcib'
alias cscss='cactus stop ; cactus slaves stop'
alias cscssci='cactus stop ; cactus slaves stop ; cactus info'
# don't use 'ck' since it is too close to 'cl'
alias cK='cactus kill'
alias cKcrcl='cactus kill ; cactus restart ; cactus log'
alias cKcss='cactus kill ; cactus slaves restart'
alias cKcssci='cactus kill ; cactus slaves restart ; cactus info'

alias m='make'
alias s='subl'

alias sagiy='sudo apt-get install -y'
alias saguysaguy='sudo apt-get update -y && sudo apt-get upgrade -y'
alias saguysaguysagay='sudo apt-get update -y && sudo apt-get upgrade -y && sudo apt-get autoremove -y'
alias update-my-ubuntu='saguysaguysagay'
alias update-to-next-version='do-release-upgrade'

alias bing='notify-send "Stacked work finished" "Work being done in your favorite terminal is now finished. You can come back !!" -i /usr/share/pixmaps/apple-red.png -t 6000'
alias b='bing'

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

    GROUP_NAME="reviewers-buildbot"

    declare -a REVIEWERS
    REVIEWERS=$(txw --quiet gerrit-getGroupMembers $GROUP_NAME 2> /dev/null | tr " " ",")
    echo "Executing 'txw gerrit-getGroupMembers $GROUP_NAME'."
    if [[ -z $REVIEWERS ]]; then
        echo "Error occured!"
        echo "Uploading without setting reviewers !"
        yes | repo upload --cbr .
    else
        echo "Uploading with the following reviewers: $REVIEWERS"
        # echo "Cmd: repo upload --cbr --re=$REVIEWERS ."
        yes | repo upload --cbr --re=$REVIEWERS .
        if [[ $? == 2 ]]; then
            echo "Repo upload failed. Nothing to upload?"
        fi
    fi
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
    cmd="git merge umg/platform/buildbot/$bottom_branch --m \"Manual merge of branch 'platform/buildbot/$bottom_branch' into 'platform/buildbot/$branch'\""
    echo "Merging branch $bottom_branch to $branch..."
    echo "Command: $cmd"
    eval $cmd
    git mergetool --no-prompt
    if [[ $? == 0 ]]; then
        git gui citool
    fi
    echo "Use 'bb_push_with_care' to push your merge to Gerrit"
}


function bb_push_with_care()
{
    local branch
    local project
    local cmd

    branch=$(git branch -a | grep "remotes/m/" | cut -d'/' -f5 | cut -d' ' -f1)
    project=$(git remote -v | grep umg | tail -n 1 | cut -d'/' -f6 | cut -d' ' -f1)

    if [[ -z $project || -z $branch ]]; then
      echo "Unable to findout branches or project name :("
      return
    fi
    cmd="git push ssh://android.intel.com/a/buildbot/$project HEAD:refs/heads/platform/buildbot/$branch"
    echo "Pushing branch '$branch' on project '$project'"
    echo "Command: $cmd"
    echo "Press Enter to continue"
    read
    eval $cmd

    echo "Refreshing repo (repo sync)"
    echo "Waiting 30s..."
    sleep "30"
    repo sync -j5 .

    echo "Display merged tree:"
    git log --color=always --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --all -5 | cat
}

ggp () {
	if [[ "$#" != 0 ]] && [[ "$#" != 1 ]]
	then
		git push origin "${*}"
	else
		[[ "$#" == 0 ]] && local b="$(git_current_branch)"
		git push origin "${b:=$1}"
	fi
}

function killPort(){
  lsof -i tcp:$1 | awk '{print $2}' | grep -v 'PID' | xargs kill
}

killPort2 () {
        lsof -i tcp:$1 | awk '{print $2}' | grep --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn} -v 'PID' | xargs kill -9
}

reset_zsh(){
  source ~/Projects/zsh-custom/init.zsh
}

function gitUpstream() {
    CURRENT_BRANCH="$(git rev-parse --abbrev-ref HEAD)"
    git checkout master
    git fetch upstream
    git rebase upstream/master
    git push origin master
    git checkout "${CURRENT_BRANCH}"
}

function gitPullRequest() {
    local remote=${2:-origin}
    git fetch ${remote} +refs/pull/$1/head:refs/remotes/${remote}/pr/$1
    git pull --no-rebase --squash ${remote} pull/$1/head
}

function gitPullRequestUpstream() {
    git reset --hard
    gitUpstream
    local remote=${2:-upstream}
    git fetch ${remote} +refs/pull/$1/head:refs/remotes/${remote}/pr/$1
    git pull --no-rebase --squash ${remote} pull/$1/head
}

function yarnVersion() {
    echo "Uninstalling yarn..."
    rm -f /usr/local/bin/yarnpkg
    rm -f /usr/local/bin/yarn

    echo "Removing yarn cache..."
    if [ -z ${YARN_CACHE_FOLDER+x} ]; then
        rm -rf ${YARN_CACHE_FOLDER}
    else
        rm -rf ${HOME}/.yarn
    fi

    echo "Installing yarn..."
    curl -o- -L https://yarnpkg.com/install.sh | bash -s -- --version $1
}

function findDepsRecrusivly(){
    cd ~/Projects
    grep --include=\package.json -rnw '.' -e $1
}

function backupDb(){
#     host=denimsocial-beta.c5gy6o8ang2y.us-east-1.rds.amazonaws.com
# user=admin
# pass=28KBEKpwcgMQTEfd8wbvDeWN
    ssh ci.denimsocial.com 'mysqldump --opt denimsocial_beta -h denimsocial-beta.c5gy6o8ang2y.us-east-1.rds.amazonaws.com --user admin -p' | gzip | aws s3 cp - s3://social-dump/beta.sql.gz
}


# grab master and update it.
# fetch all branches
# delete all branches merged into master
# grab develop and update it
# delete all branches merged into develop
function git_clean_local(){
    git checkout master && git pull origin master && git fetch -p && git branch -d $(git branch --merged | grep master -v);
    git checkout develop && git pull origin develop && git fetch -p && git branch -d $(git branch --merged | grep develop -v);
}

# show local branches and when they were created
function git_branch_history(){
    for k in $(git branch | sed s/^..//); do echo -e $(git log --color=always -1 --pretty=format:"%Cgreen%ci %Cblue%cr%Creset" $k --)\\t"$k";done | sort
}
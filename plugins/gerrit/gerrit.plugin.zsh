function gerrit_usage {
  echo
  echo  " usage: gerrit <command>"
  echo
  echo  " try these :";
  echo  "   push             Push changes without going through a review. ";
  echo  "   pull             Pull latest changes and rebase ... or something. ";
  echo  "   review           Push changes and submit changes for review";
  echo  "   setup-reviewers  Set current repo to automatically have reviewers from your team";
  echo  "   add-reviewer     Add a reviewer to the repo";
  echo  "   clone            Clone a repo from gerrit, requires repo name";
  echo  "   setup            Add gerrit commit hook to a repo";
  echo
}

function gerrit_push () {
  git push origin HEAD:refs/heads/$1;
}

function gerrit_review () {
  git push origin HEAD:refs/for/$1;
}

function gerrit_pull () {
  #git pull --rebase origin $1;
  git fetch;
  git rebase origin/$1
}

function gerrit_clone () {
  if [ -z $1 ]; then
    echo "$yellow Please supply the name of a repo to clone. $stop"
  else
    git clone --recursive ssh://gerrit_host/$1 $2
    #echo "git clone ssh://gerrit_host/$1"
  fi
}

function gerrit_set_team_reviewers () {
  git config remote.origin.receivepack 'git receive-pack --reviewer kmcgregor@giltcity.com --reviewer nyusaf@gilt.com';
  if [[ $? -eq 0 ]]; then
    echo "$green Reviewers Added. $stop";
  else
    echo "$red That failed for some reason. I'm not sure what to do now. $stop";
  fi
}

function gerrit_add_reviewer {
  if [ -z $1 ]; then
    echo "$yellow Please specify reviewer. $stop";
  else
    echo "$red Please finish me. $stop";
  fi
}

function gerrit_setup () {
  cd .git/hooks;
  scp gerrit_host:hooks/commit-msg . > /dev/null;
  cd - > /dev/null;

  if [[ $? -eq 0 ]]; then
    echo "$green Gerrit hook installed. $stop";
  else
    echo "$red Couldn't install Gerrit hook. $stop";
  fi
}

function gerrit () {

  ref=$(git symbolic-ref HEAD 2> /dev/null);
  isGitRepo=$?
  branch=${ref#refs/heads/};

  if [ -z $1 ]; then
    gerrit_usage;
  else
    [ $1 = "push" ] && gerrit_push $branch;
    [ $1 = "review" ] && gerrit_review $branch;
    [ $1 = "pull" ] && gerrit_pull $branch;
    [ $1 = "setup-reviewers" ] && gerrit_set_team_reviewers;
    [ $1 = "add-reviewer" ] && gerrit_add_reviewer $2;
    [ $1 = "clone" ] && gerrit_clone $2;
    [ $1 = "setup" ] && gerrit_setup;
  fi

}

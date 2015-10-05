function gerrit_usage {
  echo
  echo  " usage: gerrit <command>"
  echo
  echo  " try these :";
  echo  "   push             Push changes without going through a review. ";
  echo  "   pull             Pull latest changes and rebase ... or something. ";
  echo  "   patch            Work with gerrit patchset";
  echo  "   reset            Reset hard to origin/master";
  echo  "   review           Submit changes for review";
  echo  "   draft            Submit changes for review as draft";
  echo  "   clone            Clone a repo from gerrit, requires repo name";
  echo  "   setup            Add gerrit commit hook to a repo";
  echo
}

function gerrit_patch_usage () {
  echo
  echo  " usage: gerrit patch <command>";
  echo
  echo  " try these :";
  echo
  echo  "   commit          Amend the patchset commit";
  echo  "   review          Submit patchset back to the gerrit for review";
  echo  "   draft           Submit patchset back to the gerrit for review as draft";
  echo  "   rebase          Rebase onto master into patchset";
  echo
}

function gerrit_push () {
  git push origin HEAD:refs/heads/$1;
}

function gerrit_review () {
  git push origin HEAD:refs/for/$1;
}

function gerrit_draft () {
  git push origin HEAD:refs/drafts/$1;
}

function gerrit_reset {
  git reset --hard origin/master;
}

function gerrit_pull () {
  #git pull --rebase origin $1;
  git fetch;
  git rebase origin/$1
}

function gerrit_patch () {
  if [ -z "$1" ]; then
    gerrit_patch_usage;
  else
    [ "$1" = "commit" ] && git commit --amend;
    [ "$1" = "review" ] && gerrit_review "master";
    [ "$1" = "draft" ] && gerrit_draft "master";
    [ "$1" = "rebase" ] && gerrit_pull "master";
  fi
}

function gerrit_clone () {
  if [ -z "$1" ]; then
    echo "$yellow Please supply the name of a repo to clone. $stop"
  else
    if [[ -n $(which gg-gerrit-clone) ]]; then
      gg-gerrit-clone "$1"
    else
      git clone --recursive ssh://gerrit_host/$1
    fi
  fi
}

function gerrit_setup () {
  if [ -d /web/tools/bin/install-hooks ]; then
    # install hooks
    /web/tools/bin/install-hooks;

    if [[ $? -eq 0 ]]; then
      echo "$green Gerrit hook installed. $stop";
    else
      echo "$red Couldn't install Gerrit hook. $stop";
    fi
  fi
}

function gerrit () {
  gitRemoteUrl=`git config --get remote.origin.url`;

  ref=$(git symbolic-ref HEAD 2> /dev/null);
  branch=${ref#refs/heads/};

  if [ -z "$1" ]; then
    gerrit_usage;
  else
    [ "$1" = "clone" ] && gerrit_clone "$2";
    if [[ $gitRemoteUrl != *"gerrit"* ]]; then
      echo "This repository isn't on Gerrit Host.";
      return;
    fi
    [ "$1" = "patch" ] && gerrit_patch "$2"
    [ "$1" = "push" ] && gerrit_push "$branch";
    [ "$1" = "review" ] && gerrit_review "$branch";
    [ "$1" = "reset" ] && gerrit_reset;
    [ "$1" = "draft" ] && gerrit_draft "$branch";
    [ "$1" = "pull" ] && gerrit_pull "$branch";
    [ "$1" = "setup" ] && gerrit_setup;
  fi
}

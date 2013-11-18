BUILDBOT_PROJECT_PATH="$HOME/projects/buildbot/"

alias cdb='cd $BUILDBOT_PROJECT_PATH/main'
alias cdp='cd $BUILDBOT_PROJECT_PATH'

alias c='cactus'
alias cj='cactus jump'

function bb_env()
{
  BBDIR=$1
  shift
  if [[ -z $BBDIR ]]; then
    BASE=$BUILDBOT_PROJECT_PATH/main
  else
    BASE=$BBDIR
  fi
  export __PATHBKP=$PATH
  export PYTHONPATH=$BASE/buildbot/master:$BASE/txwebservices/install:$BASE/cactus/install:$BASE/config/tools
  export PATH=$HOME/bin:$BASE/buildbot/master/bin:$BASE/txwebservices/install:$PATH
  #export format_warnings_path=$BASE/config
  #export warning_path=$BASE/config/latests_warnings
  #export __PS1BKP=$PS1

  fg_blue=%{$'\e[0;34m'%}
  fg_cyan=%{$'\e[0;36m'%}
  fg_lgreen=%{$'\e[1;32m'%}
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
  export PATH=$__PATHBKP
  export PS1=$__PS1BKP
}

alias autopep8_cur_directory='autopep8 --ignore=E501 -i **/*.py'

function bb_repo_upload()
{
  REVIEWERS=(ion.alberdi@intel.com\
             vincentx.besanceney@intel.com\
             vincentx.dardel@intel.com\
             christophex.letessier@intel.com\
             olivier.monnier@intel.com\
             remy.protat@intel.com\
             gaetan.semet@intel.com\
             pierre.tardy@intel.com)
  A=$(printf -- '%s,' ${REVIEWERS[@]})
  A=${A%,}
  echo "Reviewers: $A"
  repo upload --cbr --re=$A .
}

function bb_merge_staging_main()
{
  git merge umg/platform/buildbot/staging --m "Manual merge branch 'platform/buildbot/staging' into 'platform/buildbot/main'"
  git mergetool --no-prompt --tool=kdiff3
}

function bb_merge_prod_staging()
{
  git merge umg/platform/buildbot/prod --m "Manual merge branch 'platform/buildbot/prod' into 'platform/buildbot/staging'"
  git mergetool --no-prompt --tool=kdiff3
}

function bb_push_with_care()
{
  branch=$(git branches | grep "remotes/m/" | cut -d'/' -f5 | cut -d' ' -f1)
  project=$(git remote -v | grep umg | tail -n 1 | cut -d'/' -f6 | cut -d' ' -f1)

  if [[ -z $project || -z $branch ]]; then
    echo "Unable to findout branches or project name :("
    return
  fi
  echo "Pushing branch '$branch' on project '$project'"
  echo "Press Enter to continue"
  read
  git push ssh://android.intel.com/a/buildbot/$project HEAD:platform/buildbot/$branch
  #   git push umg HEAD:platform/buildbot/$branch
  # This requires to have the following configuration in git remote (ex for 'config' project):
  # umg     ssh://gerrit-glb.tl.intel.com/a/buildbot/config (fetch)
  # umg     ssh://gerrit-glb.tl.intel.com/a/buildbot/config (push)
  #

  echo "Refreshing repo"
  echo "Waitin 30s..."
  sleep "30"
  repo sync .

  echo "Display merged:"
  git log --pretty=oneline --graph -3 | cat
}

function bb_start_slaves()
{
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
  DIR=$(basename $PWD)
  if [[ $DIR == "config" ]]; then
    ~/bin/buildslave stop ~/data/buildbot-developer
    ~/bin/buildslave stop ~/data/buildbot-developer2
  else
    ~/bin/buildslave stop ~/data/buildbot/
  fi
}

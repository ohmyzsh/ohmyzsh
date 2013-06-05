
alias cdb='cd ~/projects/buildbot/'

function bb_env()
{
  BASE=$HOME/projects/buildbot/
  #export __PATHBKP=$PATH
  #export PYTHONPATH=$BASE/buildbot/master:$BASE/txwebservices/install:$BASE/cactus/install:$BASE/config/tools
  #export PATH=$HOME/bin:$BASE/buildbot/master/bin:$BASE/txwebservices/install:$PATH
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
  project=$1
  shift
  branch=$1
  shift

  if [[ -z $project || -z $branch ]]; then
    echo "Missing arg : <project> <branch>"
    return
  fi
  echo "Pushing branch $branch on project $project"
  echo "Press Enter to continue"
  read
  git push ssh://android.intel.com/a/buildbot/$project HEAD:platform/buildbot/$branch

  echo "Refreshing repo"
  echo "Waitin 30s..."
  sleep "30"
  repo sync .

  echo "Display merged:"
  git log --pretty=oneline --graph -3 | cat 
}

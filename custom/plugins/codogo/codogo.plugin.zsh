# Add your own custom plugins in the custom/plugins directory. Plugins placed
# here will override ones with the same name in the main plugins directory.

## --------------- Custom Functions --------------- 

function editZSH {
  sublime ~/.zshrc;
}

## Codogo sites
function updateCodogoMarketingSites {
  for FOLDER in codogo-site-write codogo-site-marketing codogo-site-projects codogo-site-consulting ; do
    pushd $FOLDER
      git add --all;
      git commit -am “$1”;
      git push;
    popd
  done
}

function upgradeCodogoMarketingSites {
  for FOLDER in codogo-site-write codogo-site-marketing codogo-site-projects codogo-site-consulting ; do
    pushd $FOLDER
      yarn upgrade codogo-marketing-scss;
    popd
  done
}

## Create react app with custom scripts
function mcclowes-react-scripts {
  dirName="${1:-new-project}"
  create-react-app --scripts-version mcclowes-react-scripts $dirName;
}

function rebaseBitBucketRepo {
  if [ $# -eq 0 ]; then # nor args
    echo "No destination is set";
  else;
    git remote rename origin bitbucket;
    git remote add origin ${1};
    git push origin master;
    git remote rm bitbucket; 
  fi;
}

function codogo {
  echo "editZSH - Edit this file";
  echo "mcclowes-react-scripts < project name : new-project > - create new react project using mcclowes-scripts create react app config";
  echo "rebaseBitBucketRepo <destination> - rebase repo to new destination (with .git at the end)";
  echo "workFunctions - echo a list of custom functions for work";
}
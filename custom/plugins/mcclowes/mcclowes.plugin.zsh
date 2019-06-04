# Add your own custom plugins in the custom/plugins directory. Plugins placed
# here will override ones with the same name in the main plugins directory.

## -------------- Alias ---------------------------

# Function to check for updates to the current directory if the CD is a git repo
cd () { 
  builtin cd "$@" && 
  cd_git_checker; 
}

cd_git_checker () { 
  if [ -d .git ]; then
    git fetch
  fi;
}

## --------------- Custom Functions --------------- 

function editZSH {
  sublime ~/.zshrc;
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

function mcclowes {
  echo "editZSH - Edit zshrc config";
  echo "mcclowes-react-scripts < project name : new-project > - create new react project using mcclowes-scripts create react app config";
  echo "rebaseBitBucketRepo <destination> - rebase repo to new destination (with .git at the end)";
}
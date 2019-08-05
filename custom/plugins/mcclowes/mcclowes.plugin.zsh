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

function moveImages {
  FILES=(`echo '${PWD}/*.png'`)
  for file in $FILES; do
    echo "Provessing $file..."
    #BRANCH="$( echo "$(git rev-parse --symbolic-full-name --abbrev-ref HEAD)" | tr '-' ' ' )";
    #FOLDER=(`echo ${ARR[0]}-${ARR[1]}`);
    #mkdir ${FOLDER}
  done
}

function mcclowes {
  echo "editZSH - Edit zshrc config";
  echo "mcclowes-react-scripts < project name : new-project > - create new react project using mcclowes-scripts create react app config";
}
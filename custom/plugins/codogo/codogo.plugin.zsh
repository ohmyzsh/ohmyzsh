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

## image manipulation
function imgRemoveWhiteBackground {
  fileType="${1:-png}"
  blurRad="${2:-20}"
  find . -type f -name *.$fileType -print0 | while IFS= read -r -d $'\0' file; do 
    convert -verbose $file -fuzz $blurRad% -transparent white "$file"; 
  done
}

function imgMaxSize {
  maxSize="${1:-1500}"
  fileType="${2:-png}"
  for file in *.$fileType ; do 
    convert -verbose $file -thumbnail "$maxSizex$maxSize" ./$file ; 
  done
}

function imgConvertFormat {
  fromFileType="${1:-png}"
  toFileType="${2:-jpg}"
  for file in *.$fromFileType ; do 
    convert -verbose $file "$( echo "./$file.$toFileType" | sed -e "s/\.$fromFileType//" )" ; 
  done
}

function imgMaxSizeConvertTiny {
  maxSize="${1:-1500}"
  fromFileType="${2:-png}"
  toFileType="${3:-jpg}"
  imgMaxSize $maxSize $fromFileType;
  imgConvertFormat $fromFileType $toFileType;
  tinypng;
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

function customFunctions {
  echo "editZSH - Edit this file";
  echo "imgRemoveWhiteBackground < file type : png > < blur radius (tolerance) : 20 > - Bulk remove white background from all images in dir of specified format";
  echo "imgMaxSize < largest h or w in pixels : 1500 > - Bulk contain image sizes by each largest dimension";
  echo "imgConvertFormat < target format : png > <destination format : jpeg > - Bulk convert images from target format to destination format";
  echo "imgMaxSizeConvertTiny < largest h or w in pixels : 1500 > < target format : png > <destination format : jpeg > - All of the above combined";
  echo "mcclowes-react-scripts < project name : new-project > - create new react project using mcclowes-scripts create react app config";
  echo "rebaseBitBucketRepo <destination> - rebase repo to new destination (with .git at the end)";
  echo "workFunctions - echo a list of custom functions for work";
}
## --------------- Custom Functions --------------- 

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

function codogo {
  echo "updateCodogoMarketingSites - something";
  echo "upgradeCodogoMarketingSites - something";
}
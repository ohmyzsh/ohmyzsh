# -- JEST --

## Jest functions
function jw { # jest watch
  ## -- means pass params to jest
  npm run test -- --watch --runInBand --bail --verbose ${1};
}

function jwnc { # jest watch no cache
  ## -- means pass params to jest
  npm run test -- --watch --no-cache --runInBand --bail --verbose ${1};
}

function jwa { # jest watch all
  ## -- means pass params to jest
  npm run test -- --watchAll --runInBand --bail --verbose ${1};
}


function jest-utils {
  echo "jw <regex pattern for files> - Run tests, watch and bail";
  echo "jwnc <regex pattern for files> - Run tests, watch and bail";
  echo "jwa <regex pattern for files> - Run all tests, watch and bail";
}
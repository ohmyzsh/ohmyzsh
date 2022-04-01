##############################
### Rune Labs Shell Functions
##############################

alias output-blank-lines='echo "\n\n\n\n\n\n\n\n\n\n"'

alias mti="output-blank-lines && make test-integration"
alias mtil="output-blank-lines && make test-integration-local"
alias mtic="output-blank-lines && make test-integration 2>&1 | tee ./make-test-integration.log && code ./make-test-integration.log"
alias mtilc="output-blank-lines && make test-integration-local 2>&1 | tee ./make-test-integration-local.log && code ./make-test-integration-local.log"

alias kill-tortillas"psgr '/var/folders/bh/' | grep 'server' | grep -v PID |awk '{ print $2 };' | xargs kill -9"

##########################
### Building funcs
##########################

export RUNE_SRC=${HOME}/src/rune
export GO_MONO=${RUNE_SRC}/go-mono
# Params: the command to execute in each source sub dir
iterate-source-dirs() {
  page-break
  cd $GO_MONO

  TLD=$(pwd)

  for DIR in gorune carrotstream tortilla; do
    echo "DIR: $DIR"
    cd $DIR
    $*
    RESULT=$?
    if [ $RESULT -ne "0" ]; then
      echo "\n\n$* failed in $DIR, exiting."
    fi
    cd $GO_MONO
  done
}

go-make-mocks() {
  iterate-source-dirs make mocks
}

go-lint() {
  iterate-source-dirs golangci-lint run -v --timeout 2m0s ./...
}

go-build() {
  iterate-source-dirs go build ./...
}

go-make() {
  iterate-source-dirs make
}

go-test() {
  iterate-source-dirs go test ./...
}

go-make-clean() {
  iterate-source-dirs make clean
}

psgr-rune() {
  psgr 'taco|tortilla|broccoli|influx|carrotstream|artichoke'
}

gitignore-update() {
  pushd ${HOME}/src/rune/go-mono
  echo -e "\nprod-query*/" >>.gitignore
  popd
}

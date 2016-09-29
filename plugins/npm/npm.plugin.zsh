(( $+commands[npm] )) &&
{

  COMPLETION="${ZSH_CACHE_DIR}/npm_completion"

  if [[ ! -f $COMPLETION ]]; then
    npm completion 2>/dev/null >! $COMPLETION
    source $COMPLETION
  else
    source $COMPLETION
    npm completion 2>/dev/null >! $COMPLETION &
  fi

  unset COMPLETION

  # Install dependencies globally
  alias npmg="npm i -g "

  # npm package names are lowercase
  # Thus, we've used camelCase for the following aliases:

  # Install and save to dependencies in your package.json
  # npms is used by https://www.npmjs.com/package/npms
  alias npmS="npm i -S "

  # Install and save to dev-dependencies in your package.json
  # npmd is used by https://github.com/dominictarr/npmd
  alias npmD="npm i -D "

  # Execute command from node_modules folder based on current directory
  # i.e npmE gulp
  alias npmE='PATH="$(npm bin)":"$PATH"'

  # Check which npm modules are outdated
  alias npmO="npm outdated"

  # Check package versions
  alias npmV="npm -v"

  # List packages
  alias npmL="npm list"

  # Run npm start
  alias npmst="npm start"

  # Run npm test
  alias npmt="npm test"
}

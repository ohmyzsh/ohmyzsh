__NPM_COMPLETION_DIR="${0:A:h}"
__NPM_COMPLETION_FILE="${__NPM_COMPLETION_DIR}/npm_completion"

if [[ ! -f $__NPM_COMPLETION_FILE ]]; then
    npm completion > $__NPM_COMPLETION_FILE || rm -f $__NPM_COMPLETION_FILE
    compinit -i -d "${ZSH_COMPDUMP}"
fi

source $__NPM_COMPLETION_FILE

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

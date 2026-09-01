# Open the node api for your current version to the optional section.
# TODO: Make the section part easier to use.
function node-docs {
  local section=${1:-all}
  open_command "https://nodejs.org/docs/$(node --version)/api/$section.html"
}

# initialise node 
alias nd='node'

# Checkout the README.md for
# detailed explanation
alias ndv='node --version'
alias ndc='node -c'
alias nde='node -e'
alias ndh='node -h'
alias ndi='node -i'
alias ndr='node -r'

alias ndnd='node --no-depreciation'
alias ndnw='node --no-warnings'
alias ndtw='node --trace-warnings'
alias ndv8='node --V8-options'
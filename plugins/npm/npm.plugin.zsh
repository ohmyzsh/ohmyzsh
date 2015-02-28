eval "$(npm completion 2>/dev/null)"

# Install and save to dependencies
alias npms="npm i -S "

# Install and save to dev-dependencies
# Skipped if npmd module installed
[[ ! -e $(which npmd) ]] && alias npmd="npm i -D "

# NodeJS installed by Homebrew
if [[ -x `which brew` && -d `brew --prefix`/lib/node ]] ; then
  export NODE_PATH="$(brew --prefix)/share/npm/lib/node_modules"
  export PATH="$(brew --prefix)/share/npm/bin:$PATH"
fi

eval "$(npm completion 2>/dev/null)"

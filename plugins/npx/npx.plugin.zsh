# NPX Plugin
# https://www.npmjs.com/package/npx
# Maintainer: Pooya Parsa <pooya@pi0.ir>

(( $+commands[npx] )) && {
 source <(npx --shell-auto-fallback zsh)
}

print -u2 ${(%):-'%F{yellow}The `osx` plugin is deprecated and has been renamed to `macos`.'}
print -u2 ${(%):-'Please update your .zshrc to use the `%Bmacos%b` plugin instead.%f'}

(( ${fpath[(Ie)$ZSH/plugins/macos]} )) || fpath=("$ZSH/plugins/macos" $fpath)
source "$ZSH/plugins/macos/macos.plugin.zsh"

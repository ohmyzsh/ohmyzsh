print ${(%):-'%F{yellow}The `rustup` plugin is deprecated and has been moved to the `rust` plugin.'}
print ${(%):-'Please update your .zshrc to use the `%Brust%b` plugin instead.%f'}

(( ${fpath[(Ie)$ZSH/plugins/rust]} )) || {
  fpath=("$ZSH/plugins/rust" $fpath)
  source "$ZSH/plugins/rust/rust.plugin.zsh"
}

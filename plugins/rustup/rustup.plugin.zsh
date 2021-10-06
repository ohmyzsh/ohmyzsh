print ${(%):-'%F{yellow}The `rustup` plugin is deprecated and has been moved to the `rust` plugin.'}
print ${(%):-'Please update your .zshrc to use the `%Brust%b` plugin instead.%f'}

# Remove old generated completion file
# TODO: 2021-12-28: remove this line
command rm -f "${0:A:h}/_rustup"

(( ${fpath[(Ie)$ZSH/plugins/rust]} )) || {
  fpath=("$ZSH/plugins/rust" $fpath)
  source "$ZSH/plugins/rust/rust.plugin.zsh"
}

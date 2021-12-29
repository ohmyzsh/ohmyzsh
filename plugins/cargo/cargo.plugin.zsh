print ${(%):-'%F{yellow}The `cargo` plugin is deprecated and has been moved to the `rust` plugin.'}
print ${(%):-'Please update your .zshrc to use the `%Brust%b` plugin instead.%f'}

# TODO: 2021-12-28: remove this block
# Handle $0 according to the standard:
# https://zdharma-continuum.github.io/Zsh-100-Commits-Club/Zsh-Plugin-Standard.html
0="${${ZERO:-${0:#$ZSH_ARGZERO}}:-${(%):-%N}}"
0="${${(M)0:#/*}:-$PWD/$0}"
# Remove old generated completion file
command rm -f "${0:A:h}/_cargo" "$ZSH_CACHE_DIR/cargo_version"

(( ${fpath[(Ie)$ZSH/plugins/rust]} )) || {
  fpath=("$ZSH/plugins/rust" $fpath)
  source "$ZSH/plugins/rust/rust.plugin.zsh"
}

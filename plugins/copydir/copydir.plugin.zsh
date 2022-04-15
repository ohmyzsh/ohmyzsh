echo ${(%):-'%F{yellow}The `%Bcopydir%b` plugin is deprecated. Use the `%Bcopypath%b` plugin instead.%f'}
source "$ZSH/plugins/copypath/copypath.plugin.zsh"

# TODO: 2022-02-22: Remove deprecated copydir function.
function copydir {
  copypath
}

<<<<<<< HEAD
function copydir {
  pwd | tr -d "\r\n" | pbcopy
}
=======
echo ${(%):-'%F{yellow}The `%Bcopydir%b` plugin is deprecated. Use the `%Bcopypath%b` plugin instead.%f'}
source "$ZSH/plugins/copypath/copypath.plugin.zsh"

# TODO: 2022-02-22: Remove deprecated copydir function.
function copydir {
  copypath
}
>>>>>>> 4d9e5ce9a7d8db3c3aadcae81580a5c3ff5a0e8b

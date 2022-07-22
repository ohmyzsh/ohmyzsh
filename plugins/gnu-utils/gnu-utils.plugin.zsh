# ------------------------------------------------------------------------------
#          FILE:  gnu-utils.plugin.zsh
#   DESCRIPTION:  oh-my-zsh plugin file.
#        AUTHOR:  Sorin Ionescu (sorin.ionescu@gmail.com)
#       VERSION:  1.0.0
# ------------------------------------------------------------------------------

# Detect if GNU coreutils are installed by looking for gwhoami
if [[ ! -x "${commands[gwhoami]}" ]]; then
  return
fi

__gnu_utils() {
  local -a gcmds
  local gcmd

  # coreutils 
  gcmds=('g[' 'gbase64' 'gbasename' 'gcat' 'gchcon' 'gchgrp' 'gchmod'
  'gchown' 'gchroot' 'gcksum' 'gcomm' 'gcp' 'gcsplit' 'gcut' 'gdate'
  'gdd' 'gdf' 'gdir' 'gdircolors' 'gdirname' 'gdu' 'gecho' 'genv' 'gexpand'
  'gexpr' 'gfactor' 'gfalse' 'gfmt' 'gfold' 'ggroups' 'ghead' 'ghostid'
  'gid' 'ginstall' 'gjoin' 'gkill' 'glink' 'gln' 'glogname' 'gls' 'gmd5sum'
  'gmkdir' 'gmkfifo' 'gmknod' 'gmktemp' 'gmv' 'gnice' 'gnl' 'gnohup' 'gnproc'
  'god' 'gpaste' 'gpathchk' 'gpinky' 'gpr' 'gprintenv' 'gprintf' 'gptx' 'gpwd'
  'greadlink' 'grm' 'grmdir' 'gruncon' 'gseq' 'gsha1sum' 'gsha224sum'
  'gsha256sum' 'gsha384sum' 'gsha512sum' 'gshred' 'gshuf' 'gsleep' 'gsort'
  'gsplit' 'gstat' 'gstty' 'gsum' 'gsync' 'gtac' 'gtail' 'gtee' 'gtest'
  'gtimeout' 'gtouch' 'gtr' 'gtrue' 'gtruncate' 'gtsort' 'gtty' 'guname'
  'gunexpand' 'guniq' 'gunlink' 'guptime' 'gusers' 'gvdir' 'gwc' 'gwho'
  'gwhoami' 'gyes')

  # findutils
  gcmds+=('gfind' 'gxargs' 'glocate')

  # Not part of either coreutils or findutils, installed separately.
  gcmds+=('gsed' 'gtar' 'gtime' 'gmake' 'ggrep')

  # can be built optionally
  gcmds+=('ghostname')

  for gcmd in "${gcmds[@]}"; do
    # Do nothing if the command isn't found
    (( ${+commands[$gcmd]} )) || continue
    
    # This method allows for builtin commands to be primary but it's
    # lost if hash -r or rehash is executed, or if $PATH is updated.
    # Thus, a preexec hook is needed, which will only run if whoami
    # is not already rehashed.
    #
    hash ${gcmd[2,-1]}=${commands[$gcmd]}
  done

  return 0
}

__gnu_utils_preexec() {
  # Run __gnu_utils when the whoami command is not already rehashed.
  # This acts as a sign that we need to rehash all GNU utils.
  [[ "${commands[whoami]}" = "${commands[gwhoami]}" ]] || __gnu_utils
}

autoload -Uz add-zsh-hook
add-zsh-hook preexec __gnu_utils_preexec

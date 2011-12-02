# ------------------------------------------------------------------------------
#          FILE:  gnu-utils.plugin.zsh
#   DESCRIPTION:  oh-my-zsh plugin file.
#        AUTHOR:  Sorin Ionescu (sorin.ionescu@gmail.com)
#       VERSION:  1.0.0
# ------------------------------------------------------------------------------


if [[ -x "${commands[gwhoami]}" ]]; then 
  __gnu_utils() {
    emulate -L zsh
    local gcmds
    local gcmd
    local cmd
    local prefix

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

    # Not part of coreutils, installed separately.
    gcmds+=('gsed' 'gtar' 'gtime')

    for gcmd in "${gcmds[@]}"; do
      #
      # This method allows for builtin commands to be primary but it's
      # lost if hash -r or rehash -f is executed. Thus, those two 
      # functions have to be wrapped.
      #
      (( ${+commands[$gcmd]} )) && hash ${gcmd[2,-1]}=${commands[$gcmd]}

      #
      # This method generates wrapper functions.
      # It will override shell builtins.
      #
      # (( ${+commands[$gcmd]} )) && \
      # eval "function $gcmd[2,-1]() { \"${prefix}/${gcmd//"["/"\\["}\" \"\$@\"; }"

      #
      # This method is inflexible since the aliases are at risk of being
      # overriden resulting in the BSD coreutils being called.
      #
      # (( ${+commands[$gcmd]} )) && \
      # alias "$gcmd[2,-1]"="${prefix}/${gcmd//"["/"\\["}"
    done

    return 0
  }
  __gnu_utils;

  function hash() {
    if [[ "$*" =~ "-(r|f)" ]]; then
      builtin hash "$@"
      __gnu_utils
    else
      builtin hash "$@"
    fi
  }

  function rehash() {
    if [[ "$*" =~ "-f" ]]; then
      builtin rehash "$@"
      __gnu_utils
    else
      builtin rehash "$@"
    fi
  }
fi


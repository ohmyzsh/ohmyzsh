# ------------------------------------------------------------------------------
#          FILE:  gnu-utils.plugin.zsh
#   DESCRIPTION:  oh-my-zsh plugin file.
#        AUTHOR:  Sorin Ionescu <sorin.ionescu@gmail.com>
#       VERSION:  1.0.1
# ------------------------------------------------------------------------------


if (( $+commands[gwhoami] )); then
  function __gnu_utils() {
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
    gcmds+=('ggrep' 'gsed' 'gtar' 'gtime')

    for gcmd in "$gcmds[@]"; do
      #
      # This method allows for builtin commands to be primary but it's
      # lost if hash -r or rehash -f is executed. Thus, those two
      # functions have to be wrapped.
      #
      if (( $+commands[$gcmd] )); then
        hash "$gcmd[2,-1]"="$commands[$gcmd]"
      fi
    done

    return 0
  }
  __gnu_utils;

  function hash() {
    if (( $+argv[(er)-r] )) || (( $+argv[(er)-f] )); then
      builtin hash "$@"
      __gnu_utils
    else
      builtin hash "$@"
    fi
  }

  function rehash() {
    hash -r "$@"
  }
fi


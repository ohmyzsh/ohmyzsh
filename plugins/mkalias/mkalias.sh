#!/bin/bash

mkalias(){

    local loc_alias_bin=~/.config/mkalias.location
    local loc_alias_src=~/.config/mkalias.source

    touch $loc_alias_bin $loc_alias_src

    local alias_bin=$(cat $loc_alias_bin)

    [ "$alias_bin" = "" ] && echo "mkalias not set at: $loc_alias_bin" && return -1

    # install in profiles if not there
    loc_alias_src=$(readlink -f $loc_alias_src)
    local src_command=". $loc_alias_src"

    #echo "$src_command"

    [ "`grep -c \"$src_command\" ~/.zshrc`"  = "0" ] && echo "$src_command" >> ~/.zshrc
    [ "`grep -c \"$src_command\" ~/.bashrc`" = "0" ] && echo "$src_command" >> ~/.bashrc

    local out_command=$( $alias_bin ${@:1} )

    # safety
    case $out_command in
	"alias "*);&
	"unalias "*)
	    eval $out_command;
	    ;;
    esac
}

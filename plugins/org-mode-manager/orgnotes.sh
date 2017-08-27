#!/bin/bash

org(){
    local org_loc=~/.config/org_notes.location
    
    if ! [ -e $org_loc ] || [ "$(cat $org_loc)" = "" ];then
	echo "Cannot find orgnotes git location. Please set the location in the file:
  $org_loc
or run the install script."
	return -1
    fi

    local org_dir=$(cat $org_loc)
    
    local file=$1
    local delete=$2

    case $file in
	"")
	    #tree $(cat $org_loc) | grep -v '~' | sed "s||";
	    tree -CD -I '*~' -rt $org_dir\
		| sed "s|${org_dir}|\nYou have the following org-mode notes:\n|"\
		| sed -r 's|([^[].*)\s(\[.*\])\s(.*)|\t\2\t\1\3|'

	    return -1;
	    ;;
	-h);;
	--help)
	    echo "
     `basename $0` <filename> [--delete]

Generates an org-notes file in a folder location set in the $org_loc file
";
	    return -1;
	    ;;
    esac

    if [[ "$delete" =~ "--" ]]; then
	[ "$delete" != "--delete" ] && echo "Unable to parse: $delete" && return -1
    fi

    local ext=$( echo $file | awk -F'.' '{print $NF}' )
    
    [ "$ext" != ".org" ] && file=${file}.org
    
    if [ "$delete" = "--delete" ]; then
	local eloc=$org_dir/$file
	
	if [ -e $eloc ]; then
	    echo -n "Remove $file? [y/n] "; read ans;
	    [ "$ans" = "y" ] && rm $eloc && echo "Deleted."
	else
	    echo "Cannot find $file. Aborting."
	fi
    else
	local dirn=`dirname $file`
	mkdir -p $org_dir/$dirn
	
	emacs $org_dir/$file
    fi
}

#fpath=(~/.zsh/completion $fpath)
autoload -U compinit
compinit

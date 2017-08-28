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
	    tree -CD -P '*.org' -rt $org_dir\
		| sed "s|${org_dir}|\nYou have the following org-mode notes:\n|"\
		| sed -r 's|([^[].*)\s(\[.*\])\s(.*)|\t\2\t\1\3|'

	    return -1;
	    ;;
	-h);&
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
	    if [ "$ans" = "y" ]; then
		rm `dirname ${eloc}`/\#`basename ${eloc}`\# ${eloc}\~ 2>/dev/null # remove temp files
		rm ${eloc} && echo "Deleted."

		# cleanup
		# - Remove unused directories
		local stack_count=6  # can't expect more than 6 nested dirs, surely...
		while [ $stack_count -gt 0 ]; do
		    stack_count=$(( $stack_count - 1 ))
		    find ${org_dir} -type d -exec rmdir {} \; 2>/dev/null
		done
	    fi
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

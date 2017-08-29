#!/bin/bash

__cleanup_org(){
    local file=$1
    local dir=$2

    [ "$file" = "" ] || [ "$dir" = "" ] && echo "nothing to clean up." && return 0

    rm `dirname ${file}`/\#`basename ${file}`\# ${file}\~ 2>/dev/null # remove temp files
    
    # cleanup
    # - Remove unused directories
    local stack_count=6  # can't expect more than 6 nested dirs, surely...
    while [ $stack_count -gt 0 ]; do
	stack_count=$(( $stack_count - 1 ))
	find ${dir} -type d -exec rmdir {} \; 2>/dev/null
    done
}


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
    local command=$2

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
     `basename $0` <filename> [--delete] [--move=<dest>]

Generates an org-notes file in a folder location set in the $org_loc file
";
	    return -1;
	    ;;
    esac

    if [ "$command" = "--delete" ] || [[ "$command" =~ "--move=" ]]; then
    else
	echo "Unable to parse: $command"
	return -1
    fi

    local ext=$( echo $file | awk -F'.' '{print $NF}' )   
    [ "$ext" != ".org" ] && file=${file}.org

    local eloc=$org_dir/$file
	
    if [ "$command" != "" ]; then
	if [ -e $eloc ]; then

            case $command in
		"--delete")
		    echo -n "Remove $file? [y/n] "; read ans;
		    if [ "$ans" = "y" ]; then
			rm ${eloc} && echo "Deleted."
			__cleanup_org $eloc $org_dir 
			return 0
		    fi
		    ;;

		"--move="*)
		    local dest=`echo $command | sed 's|--move=||'`
		    echo -n "Move $file to $dest ? [y/n] "; read ans;
		    if [ "$ans" = "y" ]; then
			local ext1=$( echo $dest | awk -F'.' '{print $NF}' )   
			[ "$ext1" != ".org" ] && dest=${dest}.org

			local edest=$org_dir/$dest
			mkdir -p $org_dir/`dirname $dest`
			mv $eloc $edest && echo "Moved: $file --> $dest"
			__cleanup_org $eloc $org_dir 
			return 0
		    fi
		    ;;
	    esac
	else
	    echo "Cannot find $file. Aborting."
	    return -1
	fi
    else
	# no command, just create

	local dirn=`dirname $file`
	mkdir -p $org_dir/$dirn
	
	emacs $org_dir/$file
	return 0
    fi
}

#fpath=(~/.zsh/completion $fpath)
autoload -U compinit
compinit

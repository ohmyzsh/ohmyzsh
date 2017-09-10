#!/bin/bash

__cleanup_org(){
    local file=$1
    local dir=$2

    [ "$file" = "" ] || [ "$dir" = "" ] && echo "nothing to clean up." >&2 && return 0

    rm `dirname ${file}`/\#`basename ${file}`\# ${file}\~ 2>/dev/null # remove temp files
    
    # cleanup
    # - Remove unused directories
    local stack_count=6  # can't expect more than 6 nested dirs, surely...
    while [ $stack_count -gt 0 ]; do
	stack_count=$(( $stack_count - 1 ))
	find ${dir} -type d -exec rmdir {} \; 2>/dev/null
    done
}

__org_get_pass(){
    # password set?
    local org_pass=~/.config/org_notes.passmd5
    local pass=""
    
    if ! [ -e $org_pass ] || [ "$(cat $org_pass)" = "" ];then
	echo "org-mode password not set. Please set one below:" >&2; read -s pass1;
	echo "and again:" >&2; read -s pass2;

	[ "$pass1" != "$pass2" ] && echo  "Passwords do not match -- please try again." >&2 && echo -1 && return -1

	mkdir -p `dirname $org_pass`
	echo $pass1 | md5sum | cut -f 1 -d' ' > $org_pass
	echo "Set." >&2
	pass=$pass1
    fi

    
    if [ "$pass" = "" ]; then
	echo "Please type your org-mode password:" >&2; read -s pass
	local set_md5=$(cat $org_pass)
	local cur_md5=$(echo $pass | md5sum | cut -f 1 -d' ')
	[ "$set_md5" != "$cur_md5" ] && echo "Incorrect." >&2 && echo -1 && return -1
    fi

    echo $pass
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

    # Is file an existing subfolder?
    local sub_dir=""
    if [ -d ${org_dir}/$file ]; then
	sub_dir=$file
	file=""
    fi
	
    case $file in
	"") # applies to subdirs too
	    local title="You have the following org-mode notes:"
	    if [ "$sub_dir" != "" ]; then
		title=`echo $title | sed "s|:| [${sub_dir}]:|"`
	    fi

	    local root_dir=${org_dir}/${sub_dir}
	    
	    tree -CD -P '*.org' -rt ${root_dir} -L 3\
		| sed "s|${root_dir}|\n${title}\n|"\
		| sed -r 's|([^[].*)\s(\[.*\])\s(.*)|\t\2\t\1\3|'

	    return -1;
	    ;;
	-h);&
	--help)
	    echo "
     `basename $0` [--help] [--sync] [sub-folder] <filename [--delete] [--move=<dest>] [--encrypt] [--decrypt]>

Generates an org-notes file in a folder location set in the $org_loc file, or a given sub-folder
";
	    return -1;
	    ;;
	--sync)
	    cd ${org_dir};
	    git pull;
	    local updates=`git status ./ -s`;
	    if [ "$updates" != "" ]; then
		echo "$updates"
		git add ./ &&
		git commit -m "update at `date +%Y.%m.%d-%H.%M`" &&
		git push -u origin master
	    fi
	    cd - >/dev/null
	    return 0;;
    esac

    if [ "$command" != "" ];then
	if [ "$command" = "--delete" ] || [[ "$command" =~ "--move=" ]] || [ "$command" = "--encrypt" ] || [ "$command" = "--decrypt" ]; then
	else
	    echo "Unable to parse: $command"
	    return -1
	fi
    fi

    local ext=$( echo $file | awk -F'.' '{print $NF}' )   
    [ "$ext" != ".org" ] && file=${file}.org

    local eloc=$org_dir/$file
	
    if [ "$command" != "" ]; then
	if [ -e $eloc ]; then

            case $command in
		"--encrypt")
		    ! [ -e ${eloc} ] && echo "File does not yet exist." && return -1
		    [ "`echo $eloc | grep -oP '.crypt.org$'`" != "" ] && echo "File is already encrypted." && return -1
			
		    echo -n "Encrypt $file? [y/n] "; read ans;
		    if [ "$ans" = "y" ]; then

			local pass=$(__org_get_pass)
			[ $pass = -1 ] && return $pass # exit code
			
			new_eloc=`dirname $eloc`/`basename $eloc .org`.crypt.org
			openssl enc -aes-256-cbc -salt -in ${eloc} -out ${new_eloc} -k $pass &&
			mv $eloc /tmp/ &&
			echo "`basename $eloc` -> `basename $new_eloc`"
		    fi
		    ;;

		"--decrypt")
		    ! [ -e ${eloc} ] && echo "File does not yet exist." && return -1
		    [ "`echo $eloc | grep -oP '.crypt.org$'`" = "" ] && echo "File is already plain-text." && return -1
			
		    echo -n "Decrypt $file? [y/n]"; read ans;
		    if [ "$ans" = "y" ]; then

			local pass=$(__org_get_pass)
			[ $pass = -1 ] && return $pass # exit code
			
			new_eloc=`dirname $eloc`/`basename $eloc .crypt.org`.org
			openssl enc -aes-256-cbc -d -in ${eloc} -out ${new_eloc} -k $pass &&
			mv $eloc /tmp/ &&
			echo "`basename $eloc` -> `basename $new_eloc`"
		    fi
		    ;;
		
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
	# no command, just create or open

	local eloc=${org_dir}/$file
	local dirn=`dirname $file`

	mkdir -p $org_dir/$dirn
	
	# decrypt first if neccesary
	if [ "`echo $file | grep -oP '.crypt.org$'`" != "" ];then
	    local pass=$(__org_get_pass)
	    [ $pass = -1 ] && return $pass # exit code

	    local new_eloc=`mktemp`.org
	    #echo -en "\n\t-> decrypting";
	    openssl enc -aes-256-cbc -d -in ${eloc} -out ${new_eloc} -k ${pass}
	    emacs $new_eloc
	    #echo -en "\t -> re-encrypting";
    	    openssl enc -aes-256-cbc -salt -in ${new_eloc} -out ${eloc} -k ${pass}
	else
	    emacs $eloc
	fi
	return 0
    fi
}

#fpath=(~/.zsh/completion $fpath)
autoload -U compinit
compinit

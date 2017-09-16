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
    local org_loc=~/.config/org_notes.conf
    local switch="$1"

    ## SWITCHES that do NOT rely on valid settings
    case $switch in
	--help)
       	    local name_padding=$(cat `basename $0` | sed 's/.*/ /g')
	    
	    echo "
     `basename $0` <filename> [--delete] [--move=<dest>] [--encrypt] [--decrypt]
or   $name_padding [subfolder] [--all]
or   $name_padding [--help] [--sync] [--create-config]

Generates an org-notes file in a folder location set in the $org_loc file, or a given sub-folder";
	    return 0
	    ;;

	--create-config)	    
	    if [ -e $org_loc ]; then
		echo -n "Config already exists at $org_loc. Overwrite? [y/N] "; read ans;
		[ "$ans" != "y" ] && echo "Leaving untouched." && return -1
	    fi

	    mkdir -p `dirname $org_loc` 2>/dev/null
	    cat << EOF > $org_loc
location = /path/to/your/notes     
# Preferably a path within a git folder for the '--sync' parameter to work

maxlist = 15                      
# The max number of lines to print when displaying tree structure. Leave blank to show all.

maxnest = 3
# The max levels of subdirectories to recurse down into when displaying tree structure.
# Leave blank for all.
EOF
	    echo -e "\nCreated config at $org_loc.\nPlease modify to suit your preferences.\n"
	    sleep 2
	    emacs $org_loc
	    return 0
	    ;;
    esac
    ## End SWITCHES that do NOT rely on valid settings


    #### All below are switches that rely on a valid location file
    if ! [ -e $org_loc ] || [ "$(grep ^location $org_loc)" = "" ]; then
	echo "Cannot find orgnotes location file, or location is not set within the file. Please run:

	`basename $0` --create-config
	"
	return -1
    fi

    #### Now discover org dir settings
    local regex_extract="\s*=\s*(.*)"
    
    local org_dir=$(grep "^location" $org_loc    | sed -r "s|^location$regex_extract|\1|")
    local org_maxlist=$(grep "^maxlist" $org_loc | sed -r "s|^maxlist$regex_extract|\1|")
    local org_maxnest=$(grep "^maxnest" $org_loc | sed -r "s|^maxnest$regex_extract|\1|")

    ## SWITCHES that rely on valid settings
    if [ "$switch" = "--sync" ]; then    
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
	return 0
    fi
    ## End SWITCHES that rely on valid settings
    ## End all SWITCHES
    unset switch

    ## FILES or SUBDIRECTORIES   
    local fileorsub_wo_ext=$1
    local command=$2

    # Is file an existing subfolder?
    local sub_dirtree=""
    local file_wo_ext=""

    # Root directory for blank, or --all
    case $fileorsub_wo_ext in
	"")
	    sub_dirtree=""
	    file_wo_ext=""
	    ;;
	"--all")            # First argument as --all occurs when root directory is implied
	    sub_dirtree=""  #
	    file_wo_ext=""  #
	    command="--all" # shift to next argument
	    ;;
	*)
	    # Ensure that fileorsub has no extension, give just the absolute husk
	    #       e.g. /root/to/org/anime/naruto  <-- no ext
	    #
	    fileorsub_wo_ext=`dirname $fileorsub_wo_ext`/`basename $fileorsub_wo_ext .org`
	    local abshusk=${org_dir}/${fileorsub_wo_ext}
    
	    if [ -d $abshusk ]; then
		# Is there ALSO a filename with this start?
		#  - Not, then definitely a subdirectory
		if [ -f ${abshusk}.org ]; then
		    sub_dirtree=""
		    file_wo_ext=${fileorsub_wo_ext}
		else
		    sub_dirtree=${fileorsub_wo_ext}
		    file_wo_ext=""	    
		fi
	    else
		sub_dirtree=""
		file_wo_ext=${fileorsub_wo_ext}
	    fi
	    unset abshusk;		
	    ;;
    esac

    ## Not a file, print subdir tree
    ## SUBDIRECTORY section
    if [ "$file_wo_ext" = "" ]; then
	local title="You have the following org-mode notes:"

	# Give title for subdirectories (root dir does not need one)
	if [ "$sub_dir" != "" ]; then
	    title=`echo $title | sed "s|:| [${sub_dir}]:|"`
	fi

	# --all switch for showing all files in a subdir
	local file_filter="-P '*.org'"
	[ "$command" = "--all" ] && file_filter=""
	
	local root_dir=${org_dir}/${sub_dirtree}
	
	[ "$org_maxnest" = "" ] && org_maxnest=10
	[ "$org_maxlist" = "" ] && org_maxlist=1000

	org_maxlist=$(( $org_maxlist + 3 )) # offset: top two lines are text, and bottom blank
	
	local output=`eval tree -CD ${file_filter} -rt ${root_dir} -L ${org_maxnest}\
	    | sed "s|${root_dir}|\n${title}\n|"\
	    | sed -r 's|([^[].*)\s(\[.*\])\s(.*)|\t\2\t\1\3|'\
	    | sed 's/.org//'`

	# Print the tree, blank, and then report
	echo -e "$output" | head -n -1 | head -${org_maxlist}
	echo ""
	echo -e "$output" | tail -1

	return -1;
    fi
    ## End SUBDIRECTORY section


    ## FILE section
    # Prettify file_wo_ext to remove './' prefix
    file_wo_ext=$(echo $file_wo_ext | sed 's|^./||')
    
    local eloc=$org_dir/${file_wo_ext}.org
    
    # Handle command switches	
    if [ "$command" != "" ]; then
	if [ -e $eloc ]; then
            case $command in
		"--encrypt")
		    ! [ -e ${eloc} ] && echo "File does not yet exist." && return -1
		    [ "`echo $eloc | grep -oP '.crypt.org$'`" != "" ] && echo "File is already encrypted." && return -1
			
		    echo -n "Encrypt ${file_wo_ext}? [y/n] "; read ans;
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
			
		    echo -n "Decrypt ${file_wo_ext}? [y/n]"; read ans;
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
		    echo -n "Remove ${file_wo_ext}? [y/n] "; read ans;
		    if [ "$ans" = "y" ]; then
			rm ${eloc} && echo "Deleted."
			__cleanup_org $eloc $org_dir
			return 0
		    fi
		    ;;

		"--move="*)
		    local dest=`echo $command | sed 's|--move=||'`
		    echo -n "Move ${file_wo_ext} to $dest ? [y/n] "; read ans;
		    if [ "$ans" = "y" ]; then
			local ext1=$( echo $dest | awk -F'.' '{print $NF}' )   
			[ "$ext1" != ".org" ] && dest=${dest}.org

			local edest=$org_dir/$dest
			mkdir -p $org_dir/`dirname $dest`
			mv $eloc $edest && echo "Moved: ${file_wo_ext} --> $dest"
			__cleanup_org $eloc $org_dir 
			return 0
		    fi
		    ;;
		*)
		    echo "Unable to parse: $command"
		    return -1
		    ;;		    
	    esac
	else
	    echo "Cannot find ${file_wo_ext}. Aborting."
	    return -1
	fi
    else	
	# no command, just create or open
	local dirn=`dirname $eloc`
	mkdir -p $dirn
	
	# decrypt first if neccesary
	if [ "`echo $(basename $eloc) | grep -oP '.crypt.org$'`" != "" ];then
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

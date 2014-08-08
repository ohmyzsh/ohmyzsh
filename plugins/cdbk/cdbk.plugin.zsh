# -----------------------------------------------------------------------------
#
#       Program: cdbk.zsh (cd bookmarking for zsh)
#
#         Usage: cdbk {-a,-r,-d} <name> [path] (run with no paramaters for info)
#
#  Requirements: Needs to be sourced from a zsh startup file, or use oh-my-zsh
# 
#    Revision #: 1.0
# Last modified: 2014-08-08 13:23
#
#    Decription: cdbk() is a simple zsh function to make management of zsh
#                named directories easier.  It keeps all named directories in a
#                file and uses grep, sed, echo, and perl to parse and modify 
#                this file in order to add, change or remove bookmarks.
#        
#                Because it uses the zsh named directory function, full zsh path
#                completion is possible.  Further, very simple cdbk completion is
#                included to make replacing and deleting bookmarks easier.
#
#                This program was heavily inspired by Stan Angeloff's function 
#                of the same name found here:
#                http://blog.angeloff.name/post/1027007406/cd-with-bookmarks-and-auto-completion-for-zsh
#
#                This file also provides the function folder_name(), which returns
#                a formatted list of the names of the current folder for use in 
#                a prompt. To include the folder name in your prompt use e.g.:
#                export PROMPT=$PROMPT $(folder_name)
#
#          Bugs: None that I know of
#
#    Created by: Mike Dacre 
#    Created on: 19-11-11
#
#       License: MIT License - Open Source. Use as you wish
#    
# -----------------------------------------------------------------------------

# Define location of bookmark file and source it every time this file is sourced
ZSH_BOOKMARKS="$HOME/.zshbookmarks";

if [ -e $ZSH_BOOKMARKS ]; then
  source $ZSH_BOOKMARKS;
else
  touch $ZSH_BOOKMARKS;
fi

# ----------------------
# Main Function
# ----------------------
function cdbk () {
  source $ZSH_BOOKMARKS;

  # Create local variables for function and global bkmk functions
  local BKMKNAME;
  local BKMKPATH;
  local MYPATH;
  CURBKMKS=(`grep -e "^hash -d" $ZSH_BOOKMARKS | sed 's#hash -d ##' | sed 's#=\(.*\)# \1#' `)
  GLBLBKMKS=(`grep -e "^ *hash -d" $HOME/.zshrc | sed 's#hash -d ##' | sed 's#=\(.*\)# \1#' `)

  local GLBLTEST=GLBLBKMKS;
  local HOSTTEST=HOSTBKMKS;

  # Define usage
  local USAGE="-------------------------------------------------------------------------------
     cdbk is a simple management tool for the built in zsh named directories

   cdbk -a <name> [<path>] : Create bookmark (uses current dir if no path)
   cdbk -r <name> [<path>] : Replace bookmark (uses current dir if no path)
   cdbk -d <name>          : Delete bookmark\n\n";

  # Check first if bookmark file exists
  if [[ ! -e $ZSH_BOOKMARKS ]]; then
    touch $ZSH_BOOKMARKS;
    printf "Bookmark file %s created\n" $ZSH_BOOKMARKS;
  fi

  # Check if there are enough arguments
  if [[ $# -lt 2 ]]; then
    
    # If no arguments, display all bookmarks and brief help
    printf "$USAGE   Current bookmarks:\n";
    print -aC 2 ${(kv)CURBKMKS} | sed 's/^/     /' | sort;
    if [ $GLBLTEST ]; then
      printf "\n   Global Bookmarks:\n";
      print -aC 2 ${(kv)GLBLBKMKS} | sed 's/^/     /' | sort;
    fi
    if [ $HOSTTEST ]; then
      printf "\n   Host Specific Global Bookmarks:\n";
      print -aC 2 ${(kv)HOSTBKMKS} | sed 's/^/     /' | sort;
    fi
    printf "\n--------------------------------------------------------------------------------\n";

  else

    # Look for existing version of query
    BKMKNAME=$(grep "hash -d $2=" "$ZSH_BOOKMARKS" | sed 's#^hash -d ##' | sed 's#=.*$##');
    BKMKPATH=$(grep "hash -d $2=" "$ZSH_BOOKMARKS" | sed 's#^hash -d [^=]*=##');

    # Add new bookmark
    if [[ $1 == "-a" ]]; then

      # Check if path included, if not use current working directory
      if [[ $# -eq 3 ]]; then
        MYPATH=$3;
      else
        MYPATH=$PWD;
      fi

      # Check that bookmark isn't in either global file
      if [ $GLBLNAME ]; then
        printf "Bookmark %s is already taken by global bookmark:\n    %s\n\nYou need to remove this manually first.\n" $2 $GLBLNAME;
      else

        # Check that name isn't already taken
        if [ $BKMKNAME ]; then
          printf "Bookmark %s is already taken (at %s), please use cdbk -r %s <PATH> to replace.\n" $2 $BKMKPATH $2;
        else

          # Check that path provided is actually a valid directory
          if [ -d $MYPATH ]; then

            # Write bookmark to file, and do once off creation (will show error on fail)
            echo "hash -d $2=$MYPATH" >> $ZSH_BOOKMARKS;
            hash -d $2=$MYPATH;
            printf "Bookmark %s created for %s\n" $2 $MYPATH;
          else
            printf "%s is not a valid path, please double-check\n" $3;
          fi
        fi
      fi

    # Replace entry
    elif  [[ $1 == "-r" ]]; then 

      # Check if path included, if not use current working directory
      if [[ $# -eq 3 ]]; then
        MYPATH=$3;
      else
        MYPATH=$PWD;
      fi
      
      # Check that bookmark isn't in either global file
      if [ $GLBLNAME ]; then
        printf "Bookmark %s is a global bookmark and cannot be replaced:\n    %s\n\nYou need to remove this manually first.\n" $2 $GLBLNAME;
      else
            
        # Check that name definitely exists before proceeding
        if [ $BKMKNAME ]; then
        
          # Check that path provided is actually a valid directory
          if [ -d $MYPATH ]; then

            # Remove bookmark entry with perl and do once off manual rehash
            unhash -d $2;
            perl -pi -e "s#(hash -d $2=).*#\$1$MYPATH#g" $ZSH_BOOKMARKS;
            hash -d $2=$MYPATH;
            printf "Changed %s from %s to %s\n" $2 $BKMKPATH $MYPATH;
          fi

        # If bookmark doesn't already exist, then just create a new one
        else

          # Check that path provided is actually a valid directory
          if [ -d $MYPATH ]; then
            echo "hash -d $2=$MYPATH" >> $ZSH_BOOKMARKS;
            hash -d $2=$MYPATH;
            printf "Can't replace, because %s isn't in the bookmark file! Creating new...\n\n" $2;
            printf "Bookmark %s created for %s\n" $2 $MYPATH; 
          else
            printf "%s is not a valid directory, and %s isn't already in bookmark file\n" $MYPATH $2;
          fi
        fi
      fi
     
    # Delete unwanted entry 
    elif  [[ $1 == "-d" ]]; then 
      
      # Check that name definitely exists before proceeding
      if [ $BKMKNAME ]; then
      
        while true; do                                   
        echo "Do you really want to delete $2? (Y/n)";
          read YN_CHOICE;
          case $YN_CHOICE in
            [Yy]* ) # Remove bookmark entry with perl and do once off manual unhash
                    perl -pi -e "s#^hash -d $2=.*[\n\r]+##g" $ZSH_BOOKMARKS;
                    unhash -d $2;
                    printf "Deleted %s\n" $2;
                    break;;
            [Nn]* ) printf "Did not delete %s\n" $2; break;;
                * ) echo "Please answer yes or no.";;
          esac
        done  
      else
        printf "Can't delete, because %s isn't in the bookmark file!\n" $2;
        printf "Current bookmarks:\n\n";
        print -aC 2 ${(kv)CURBKMKS} | sed 's/^/     /';
      fi

    # If first argument isn't -a or -d then print help
    else
      printf "First argument must be either -a or -r or -d\n";
      printf "To add a bookmark use cdbk -a <name> <path>\n";
      printf "To replace a bookmark use cdbk -r <name> <path>\n";
      printf "To delete a bookmark, use cdbk -d <name>\n";
      printf "Current bookmarks:\n\n";
      print -aC 2 ${(kv)CURBKMKS} | sed 's/^/     /';
    fi

  fi
}

# ----------------------
# Auto-complete function
# ----------------------
function _cdbk() {
  reply=($(cat "$ZSH_BOOKMARKS" | sed -e 's#^hash -d \(.*\)=.*$#\1#g') $(cat "$HOME/.zshrc" | grep "^hash -d" | sed -e 's#^hash -d \(.*\)=.*$#\1#g'));
}

compctl -K _cdbk cdbk

# ---------------------------------------
# folder_name function for custom prompt
# ---------------------- ----------------
function folder_name {
  FOLDERNAME=$(grep -e "hash -d.*=\"*\'*$PWD\"*\'*"$ {"$ZSH_BOOKMARKS","$HOME"/.zshrc} | sed 's#^.*hash -d \([^=]*\)=.*$#~\1#' | xargs echo);
  if [ $FOLDERNAME ]; then
    echo "${PR_LIGHT_CYAN}(${PR_LIGHT_WHITE}$FOLDERNAME${PR_LIGHT_CYAN})%{${reset_color}%}";
  elif [[ "$PWD" == "$MYZSH" ]]; then
    echo "${PR_LIGHT_CYAN}(${PR_LIGHT_WHITE}~zsh${PR_LIGHT_CYAN})%{${reset_color}%}";
  elif [[ "$PWD" == "$HOME/.vim" ]]; then
    echo "${PR_LIGHT_CYAN}(${PR_LIGHT_WHITE}~vim${PR_LIGHT_CYAN})%{${reset_color}%}";
  else
    echo "";
  fi
}


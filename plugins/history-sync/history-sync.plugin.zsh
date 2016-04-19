###
# James Fraser
# <wulfgar.pro@gmail.com>
###

autoload -U colors
colors

ZSH_HISTORY_FILE=$HOME/.zsh_history
ZSH_HISTORY_PROJ=$HOME/.zsh_history_proj
ZSH_HISTORY_FILE_ENC=$ZSH_HISTORY_PROJ/zsh_history
GIT_COMMIT_MSG="latest $(date)"

function print_git_error_msg() {
echo "$bold_color$fg[red]Fix your git repo...${reset_color}";
}

function print_gpg_encrypt_error_msg() {
echo "$bold_color$fg[red]GPG failed to encrypt history file... exiting.${reset_color}"; 
}

function print_gpg_decrypt_error_msg() {
echo "$bold_color$fg[red]GPG failed to decrypt history file... exiting.${reset_color}"; 
}

function usage() { 
echo "$bold_color$fg[red]Usage: $0 [-r <string> -r <string>...]${reset_color}" 1>&2; return; 
}

# Pull current master, decrypt, and merge with .zsh_history
function history_sync_pull() {
  # Backup
  cp -a $HOME/{.zsh_history,.zsh_history.backup}
  DIR=$CWD
  # Pull
  cd $ZSH_HISTORY_PROJ && git pull
  if [[ $? != 0 ]]; then
    print_git_error_msg
    cd $DIR
    return
  fi

  # Decrypt
  gpg --output zsh_history_decrypted --decrypt zsh_history
  if [[ $? != 0 ]]; then
    print_gpg_decrypt_error_msg
    cd $DIR
    return
  fi

  # Merge
  cat $HOME/.zsh_history zsh_history_decrypted | sort -u > $HOME/.zsh_history 
  rm zsh_history_decrypted
  cd $DIR
}

# Encrypt and push current history to master
function history_sync_push() {
  # Get option recipients
  local recipients=()
  while getopts -r: opt; do
    case "$opt" in
      r)
        recipients+="$OPTARG"
        ;;
      *)
        usage
        return
        ;;
    esac
  done

  echo $recipients

  # Encrypt
  if ! [[ ${#recipients[@]} > 0 ]]; then      
    echo -n "Please enter GPG recipient name: "
    read name
    recipients+=$name
  fi

  ENCRYPT_CMD="gpg -v "
  for r in $recipients; do
    ENCRYPT_CMD+="-r \"$r\" "
  done

  if [[ $ENCRYPT_CMD =~ '.(-r).+.' ]]; then 
    ENCRYPT_CMD+="--encrypt --sign --armor --output $ZSH_HISTORY_FILE_ENC $ZSH_HISTORY_FILE"
    eval ${ENCRYPT_CMD}
    if [[ $? != 0 ]]; then
      print_gpg_encrypt_error_msg
      return
    fi

    echo -n "$bold_color$fg[yellow]Do you want to commit current local history file? ${reset_color}"
    read commit    
    if [[ -n $commit ]]; then
      case $commit in
        [Yy]* ) 
          DIR=$CWD
          cd $ZSH_HISTORY_PROJ && git add * && git commit -am $GIT_COMMIT_MSG
          echo -n "$bold_color$fg[yellow]Do you want to push to remote? ${reset_color}"
          read push
          if [[ -n $push ]]; then
            case $push in
              [Yy]* )
                git push                            
                if [[ $? != 0 ]]; then 
                  print_git_error_msg
                  cd $DIR
                  return
                fi
                cd $DIR
                ;;
            esac
          fi

          if [[ $? != 0 ]]; then 
            print_git_error_msg
            cd $DIR
            return
          fi
          ;;
        [Nn]* )
          ;;
        * )
          ;;
      esac          
    fi
  fi
}

alias zhpl=history_sync_pull
alias zhps=history_sync_push
alias zhsync="history_sync_pull && history_sync_push"

: ${FPM_DIR:=/etc/php5/fpm}

if [ $use_sudo -eq 1 ]; then
    sudo="sudo"
else
    sudo=""
fi

_fpm_get_possible_pool_list () {
    cat /etc/passwd | awk -F : '{print $1 }'
}

_fpm_pool () {
    compadd `_fpm_get_possible_pool_list`
    
}

pool () {
    while getopts ":lh" option
    do
      case $option in
        l ) ls $FPM_DIR/pool.d; return ;;
        h ) _pool_usage; return ;;
       * ) _pool_usage; return ;; # Default.
      esac
    done
    
    if [ ! $1 ]; then
      user=$USER
    else
      user=$1
    fi
    
    _pool_generate $user
}
compdef _fpm_pool pool

_pool_usage () {
    echo "Usage: pool [options] [user]"
    echo
    echo "Options"
    echo "  -l   Lists fpm pools"
    echo "  -h   Get this help message"
    return
}

_pool_generate () {
    user=$(cat /etc/passwd | grep $1 | awk -F : '{print $1 }')
    
    if [ ! $user ]; then
      echo "User \033[31m$1\033[0m doesn't have an account on \033[33m$HOST\033[0m"
      return
    fi

    group=$(groups $user | cut -d " " -f 3)
    
    echo "Generating pool for \033[33m$user\033[0m user with \033[33m$group\033[0m group"
        
    user_id=$(cat /etc/passwd | grep $1 | awk -F : '{print $3 }')
    pool_port=1$user_id
    : ${FPM_POOL_TEMPLATE:=$ZSH/plugins/php-fpm/templates/pool}
    
    conf=$(sed -e 's/{user}/'$user'/g' -e 's/{group}/'$group'/g' -e 's/{pool_port}/'$pool_port'/g' $FPM_POOL_TEMPLATE )
    
    echo $conf > $user.conf
    $sudo mv $user.conf $FPM_DIR/pool.d/$user.conf
    
    if [ -e $FPM_DIR/pool.d/$user.conf ]; then
        echo "Pool for \033[32m$user\033[0m user has been successfully created"
    else
        echo "An error occured during the creating of pool for \033[31m$user\033[0m user"
    fi
}

alias fpmr="$sudo service php5-fpm restart"

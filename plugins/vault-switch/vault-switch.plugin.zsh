autoload -U add-zsh-hook
add-zsh-hook precmd _restore_cache

FILE_CREDENTIALS="${HOME}/.vault-switch/credentials"

_restore_cache(){
    [ ! -d ${HOME}/.vault-switch ] && mkdir -p ${HOME}/.vault-switch
    [ ! -f $FILE_CREDENTIALS ] && touch ${FILE_CREDENTIALS}
    source ${FILE_CREDENTIALS}
}

_get-nodes(){
    IFS=";" read -A NODES <<< ${VAULT_NODES}
}

_set-color(){
    echo "\e[1;32m$1\e[0m"
}

_list-nodes(){
    INDEX=1
    for i in  ${NODES[@]}
    do
        NODE=$(echo $i | cut -d "," -f 1)
        [[ "${NODE}" == "${VAULT_SELECT_NODE}" ]] && ASTERISK="*"
        echo "${INDEX}) ${NODE} $(_set-color ${ASTERISK})"
        INDEX=$[$INDEX+1]
        unset ASTERISK
    done
}

_set-work-node(){
    if  [ $1 -gt ${#NODES[@]} ]
    then
        echo "Number of node not found"
    else
        VAULT_SELECT_NODE=$(echo ${NODES[$1]} | cut -d "," -f 1)
        VAULT_ADDR=$(echo ${NODES[$1]} | cut -d "," -f 2)
        VAULT_TOKEN=$(echo ${NODES[$1]} | cut -d "," -f 3)
        VAULT_SKIP_VERIFY=$(echo ${NODES[$1]} | cut -d "," -f 4)

        echo > ${FILE_CREDENTIALS}
        echo "export VAULT_SELECT_NODE=${VAULT_SELECT_NODE}" >> ${FILE_CREDENTIALS}
        echo "export VAULT_ADDR=${VAULT_ADDR}" >> ${FILE_CREDENTIALS}
        echo "export VAULT_TOKEN=${VAULT_TOKEN}" >> ${FILE_CREDENTIALS}
        [[ $VAULT_SKIP_VERIFY ]] && echo "export VAULT_SKIP_VERIFY=true" >> ${FILE_CREDENTIALS}

        _list-nodes
    fi

}

vault-switch() {
    _get-nodes
    [ ! $1 ] && _list-nodes
    [ $1 ] && _set-work-node $1
}

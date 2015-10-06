encode64(){ 
    if [ $# -eq 0 ]; then
        cat | base64
    else
        echo -n "$*" | base64
    fi
}

decode64(){ 
    if [ $# -eq 0 ]; then
        cat | base64 --decode
    else
        echo -n "$*" | base64 --decode
    fi
}
alias e64=encode64
alias d64=decode64

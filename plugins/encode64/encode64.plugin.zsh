<<<<<<< HEAD
encode64(){ echo -n $1 | base64 }
decode64(){ echo -n $1 | base64 --decode }
=======
encode64() {
    if [[ $# -eq 0 ]]; then
        cat | base64
    else
        printf '%s' $1 | base64
    fi
}

decode64() {
    if [[ $# -eq 0 ]]; then
        cat | base64 --decode
    else
        printf '%s' $1 | base64 --decode
    fi
}
>>>>>>> 4d9e5ce9a7d8db3c3aadcae81580a5c3ff5a0e8b
alias e64=encode64
alias d64=decode64

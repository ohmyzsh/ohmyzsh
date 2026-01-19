
x(){(
    @info(){
        printf "%s\n" "$@"
    }

    if [ -e "$HOME/.x-cmd.root/X" ]; then
        . "$HOME/.x-cmd.root/X"
        ___x_cmd "$@"
        return $?
    fi
    
    local cmdstr=""
    if command -v curl 2>/dev/null; then
        cmdstr='eval "$(curl -s https://get.x-cmd.com)"'
    elif command -v wget 2>/dev/null; then
        cmdstr='eval "$(wget -O- https://get.x-cmd.com)"'
    fi

    @info "X-CMD is not installed. Do you want to install x-cmd ?"
    @info "Command using is -> $cmdstr" 
        
    local answer=""
    read -q "Please press y for yes, n for no. Ctrl-C will also abort the setup." answer || {
        @info "Received intrrupt. Exit with error code 130."
        return 130
    }
        
    case "$answer" in
        n|N|no)
            @info "Received $answer. Exit the setup immediately."
            return 0
            ;;
        y|Y|yes)      
            @info "Received $answer. Setup is going now."
            eval "$cmdstr"
            return 0
            ;;
        *)
            @info "Received unknown $answer."
            return 1
            ;;
    esac
)}



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
    if command -v curl >/dev/null 2>&1; then
        cmdstr='eval "$(curl -s https://get.x-cmd.com)"'
    elif command -v wget >/dev/null 2>&1; then
        cmdstr='eval "$(wget -O- https://get.x-cmd.com)"'
    fi

    @info "X-CMD is not installed. Do you want to install x-cmd ?"
    @info "Command using is -> $cmdstr" 
        
    local answer=""
    read -q "answer?Please press y for yes. Ctrl-C will also abort the setup. " 
    case "$answer" in
        y|Y|yes)      
            echo "Setup is going now."
            eval "$cmdstr"
            return 0
            ;;
        *)
           echo ""
            ;;
    esac
)}


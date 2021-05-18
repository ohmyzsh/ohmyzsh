#
# Completion for the NordVPN Linux Client
# Correct as at NordVPN Version 3.0.1-1
#
compdef _nordvpn nordvpn
declare line

function _nordvpn {

    _arguments -C \
        "1: :((account\:'Shows account information'
               cities\:'Shows a list of cities where servers are available'
               connect\:'Connects you to VPN'
               countries\:'Shows a list of countries where servers are available'
               disconnect\:'Disconnects you from VPN'
               groups\:'Shows a list of available server groups'
               rate\:'Rate your last connection quality (1-5)'
	           register\:'Registers a new user account'
               login\:'Logs you in'
               logout\:'Logs you out'
               set\:'Sets a configuration option'
               settings\:'Shows current settings'
               status\:'Shows connection status'
               whitelist\:'Adds or removes an option from a whitelist'
               help\:'Shows a list of commands or help for one command'))"  \
        "--help:Show help" \
        "-h:Show help" \
        "--version:print the version" \
        "-v:print the version" \
        "*::arg:->args"

    case $line[1] in
        cities)
            _cities
        ;;
        connect)
            _connect 1
        ;;
        rate)
            _rate
        ;;
        login)
            _login
        ;;
        set)
            _set
        ;;
        whitelist)
            _whitelist
        ;;
        *)
            _show_help
        ;;
    esac
}

function _cities {
    countries=$(nordvpn countries |  tr -cs '[:alnum:]_' ' ' | tail -c +2 | head -c -1)
    _arguments \
        "1: :($countries)" \
        "--help:Show help" \
        "-h:Show help" 
}

function _connect {
    index=$1
    countries=$(nordvpn countries | tr -cs '[:alnum:]_' ' ' | tail -c +2 | sed "s/ /\\\:'Country' /g")
    groups=$(nordvpn groups | tr -cs '[:alnum:]_' ' ' | tail -c +2 | sed "s/ /\\\:'Group' /g")

    _arguments \
        "$index: :(($countries $groups))" \
        "--help:Show help" \
        "-h:Show help"

    ((index++))

    country="$line[$index]"
    cities_cmd=$(nordvpn cities $country)
    ret=$?

    if [[ "$country" != "--help" && $ret -eq 0 ]]; then
        cities=$(echo $cities_cmd |  tr -cs '[:alnum:]_' ' ' | tail -c +2 | head -c -1)
        _arguments "$index: :($cities)"
    fi

}

function _rate {
    _arguments "1: :((NUM\:'the rating on a scale of 1 (poor) through 5 (great)'))" \
               "--help:Show help" \
               "-h:Show help"
}

function _login {
    _arguments \
        '--username[Specify a user account]'\
        '-u[Specify a user account]'\
        '--password[Specify the password for the user specified in --username]'\
        '-p[Specify the password for the user specified in --username]' \
        '-h[Show help]' \
        '--help[Show help]'
}

function _set {
    _arguments \
        "1: :((autoconnect\:'Enables or disables auto-connect. When enabled, this feature will automatically try to connect to VPN on operating system startup.'
               cybersec\:'Enables or disables CyberSec. When enabled, the CyberSec feature will automatically block suspicious websites.'
               defaults\:'Restores settings to their default values.'
               dns\:'Sets custom DNS servers'
               firewall\:'Enables or disables use of the firewall.'
               killswitch\:'Enables or disables Kill Switch. This security feature blocks your device from accessing the Internet outside the secure VPN tunnel.'
               notify\:'Enables or disables notifications'
               obfuscate\:'Enables or disables obfuscation. When enabled, this feature allows to bypass network traffic sensors which aim to detect usage of the protocol and log, throttle or block it.'
               protocol\:'Sets the protocol'
               technology\:'Sets the technology'))"  \
        "--help:Show help" \
        "-h:Show help"

    case $line[2] in
        autoconnect)
            _arguments "2: :((off\:'Disables auto-connect.' on\:'Enables auto-connect.'))"

            case $line[3] in
                on)
                    _connect 3
                ;;
            esac
        ;;
        cybersec)
            _describe 'cybersec-setting' '(on off)'
        ;;
        dns)
             _describe 'dns-setting' '(off)'
        ;;
        firewall)
             _describe 'firewall-setting' '(enabled 1 true enable on disabled 0 false disable off)'
        ;;
        killswitch)
            _describe 'killswitch-setting' '(on off)'
        ;;
        notify)
            _describe 'notify-setting' '(on off)'
        ;;
        obfuscate)
            _describe 'obfuscate-setting' '(on off)'
        ;;
        technology)
            _describe 'technology-setting' '(OpenVPN NordLynx)'
        ;;
        protocol)
            _describe 'protocol-setting' '(TCP UDP)'
        ;;
    esac
}

function _whitelist {
    _arguments \
        "1: :((add\:'Adds an option to a whitelist.'
               remove\:'Removes an option from a whitelist'))"  \
        "--help:Show help" \
        "-h:Show help"

    if [[ -n ${line[2]} ]]; then
        _arguments \
            "2: :((port\:'${line[2]}s port to a whitelist'
                   ports\:'${line[2]}s port range to a whitelist'
                   subnet\:'${line[2]}s subnet to a whitelist'))"
    fi

    case $line[3] in
        port)
            _arguments "3: :((NUM\:'the port number to ${line[2]}'))"

            if [[ -n ${line[4]} ]]; then
                    _describe 'protocol-setting' "(TCP UDP)"
            fi
        ;;
        ports)
            _arguments "3: :((NUM\:'the beginning port number to ${line[2]}'))"
            
            if [[ -n ${line[4]} ]]; then
                    _arguments "4: :((NUM\:'the ending port number to ${line[2]}'))"
            fi  
        
            if [[ -n ${line[5]} ]]; then
                    _describe 'protocol-setting' "(TCP UDP)"
            fi  
        ;;
        subnet)
            _arguments "3: :((CIDR\:'the address in CIDR notation to ${line[2]}'))"
        ;;
    esac

}

function _show_help {
    _arguments \
        "--help:Show help" \
        "-h:Show help"
}

#
# Aliases
#
alias nord="nordvpn"
alias nordl="nordvpn login"
alias nordlo="nordvpn logout"
alias nordc="nordvpn connect"
alias nordd="nordvpn disconnect"
alias nordwh="nordvpn whitelist"
alias nordst="nordvpn status"
alias nordset="nordvpn set"
alias nordsettings="nordvpn settings"
alias nordh="nordvpn help"
alias nordcout="nordvpn countries"
alias nordcit="nordvpn cities"
alias nordgrp="nordvpn groups"

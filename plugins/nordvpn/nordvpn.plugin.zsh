#
# Completion for the NordVPN Linux Client
# Correct as at NordVPN Version 3.0.1-1
#
compdef _nordvpn nordvpn
declare line

function _nordvpn {

    _arguments -C \
        "1: :((cities\:'Shows a list of cities where servers are available'
               connect\:'Connects you to VPN'
               countries\:'Shows a list of countries where servers are available'
               disconnect\:'Disconnects you from VPN'
               groups\:'Shows a list of available server groups'
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
        countries)
            _countries
        ;;
        disconnect)
            _disconnect
        ;;
        groups)
            _groups
        ;;
        login)
            _login
        ;;
        logout)
            _logout
        ;;
        set)
            _set
        ;;
        settings)
            _settings
        ;;
        status)
            _status
        ;;
        whitelist)
            _whitelist
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

function _countries {
    _arguments \
        "--help:Show help" \
        "-h:Show help" 
}

function _disconnect {
    _arguments \
        "--help:Show help" \
        "-h:Show help" 
}

function _groups {
    _arguments \
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

function _logout {
    _arguments \
        "--help:Show help" \
        "-h:Show help"
}

function _set {
    _arguments \
        "1: :((autoconnect\:'Enables or disables auto-connect. When enabled, this feature will automatically try to connect to VPN on operating system startup.'
               cybersec\:'Enables or disables CyberSec. When enabled, the CyberSec feature will automatically block suspicious websites.'
               dns\:'Sets custom DNS servers'
               killswitch\:'Enables or disables Kill Switch. This security feature blocks your device from accessing the Internet outside the secure VPN tunnel.'
               notify\:'Enables or disables notifications'
               obfuscate\:'Enables or disables obfuscation. When enabled, this feature allows to bypass network traffic sensors which aim to detect usage of the protocol and log, throttle or block it.'
               protocol\:'Sets the protocol'))"  \
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
        killswitch)
            _describe 'killswitch-setting' '(on off)'
        ;;
        notify)
            _describe 'notify-setting' '(on off)'
        ;;
        obfuscate)
            _describe 'obfuscate-setting' '(on off)'
        ;;
        protocol)
            _describe 'protocol-setting' '(TCP UDP)'
        ;;
    esac
}

function _settings {
    _arguments \
        "--help:Show help" \
        "-h:Show help"
}

function _status {
    _arguments \
        "--help:Show help" \
        "-h:Show help"
}

function _whitelist {
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
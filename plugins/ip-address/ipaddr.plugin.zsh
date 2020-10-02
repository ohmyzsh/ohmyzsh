# Code to grab public and private IP addreses 

# Author
#   - github.com/getsec

CURL=$(which curl) 
JQ=$(which jq)

if ! type "$CURL" > /dev/null; then
    echo "$CURL was not found, please install curl and ensure it's in the PATH"
    echo "current path: $PATH"
fi

if ! type "$JQ" > /dev/null; then
    echo "$JQ was not found, please install curl and ensure it's in the PATH"
    echo "current path: $PATH"
fi


public_ip (){
    DATA=$($CURL --silent ipinfo.io)

    IP=$(echo $DATA | $JQ .ip | sed -e 's:"::g')
    hostname=$(echo $DATA | $JQ .hostname| sed -e 's:"::g')
    city=$(echo $DATA | $JQ .city| sed -e 's:"::g')
    region=$(echo $DATA | $JQ .region| sed -e 's:"::g')
    country=$(echo $DATA | $JQ .country| sed -e 's:"::g')

    echo " → $IP ($city, $region, $country)"
}




private_ips (){
    for i in `ifconfig -l`; do 

        IP_ADDR=$(ipconfig getifaddr $i)
        
        if  ! [ -z "$IP_ADDR" ]
        then
            echo " → $i: $IP_ADDR"
        fi

    done 
    
}

display_all(){
    echo "Public IP: "
    public_ip
    echo "Private IP(s): "
    private_ips
}

alias ipa=display_all
alias ippub='$CURL --silent ipinfo.io/ip'
alias allpub='$CURL --silent ipinfo.io'

###########################################
# Programming Quotes plugin for oh-my-zsh  #
# Available only for Mac Users as of now  #
# Original Author: Dennis Murage (murageden) #
# Email: muragemd@gmail.com              #
###########################################

export PRO_Q_HOME=~/.proquotes
mkdir -p $PRO_Q_HOME
file_name="$PRO_Q_HOME/quote.txt"
local _res
local _lng
_lngEN="lang/en"
_lngSR="lang/sr"
_api="programming-quotes-api.herokuapp.com"

# check language
lang=$(osascript -e 'user locale of (get system info)')
if [[ $lang == *"sr"* || $lang == *"SR"* ]] then # Serbian
    _lng=$_lngSR
else # English
    _lng=$_lngEN
fi

# check internet
nc -z -w 5 8.8.8.8 53  >/dev/null 2>&1
online=$?
if [ $online -eq 0 ]; then # online
    _res=`curl -s https://$_api/quotes/random/$_lng`
    echo $_res >| $file_name
else # offline
    if [ -f $file_name ]; then # file found
        _res=$(<$file_name)
    else # no file
        echo "ERR: proquotes run into an error. See you in the next zsh session ~ Dennis Murage"
        return
    fi
fi

# process quote
_qt=`print $_res | python -c 'import json,sys; obj=json.load(sys.stdin);print obj["en"].encode("ascii", "ignore");'`
_aut=`print $_res | sed -e 's/[{}]/''/g' | sed s/\"//g | awk -v RS=',' -F: '$1=="author"{print $2}'`
echo "${_qt}" \~ "${_aut}"


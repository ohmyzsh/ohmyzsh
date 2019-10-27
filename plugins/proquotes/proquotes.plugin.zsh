###########################################
# Programming Quotes plugin for oh-my-zsh  #
# Available only for Mac Users as of now; in two languges EN, SR  #
# Original Author: Dennis Murage (murageden) #
# Email: muragemd@gmail.com              #
###########################################

export PRO_Q_HOME=~/.proquotes
mkdir -p $PRO_Q_HOME
file_name="$PRO_Q_HOME/quote.txt"

_lngEN="lang/en"
_lngSR="lang/sr"
_api="programming-quotes-api.herokuapp.com"

# check language
lang=$(osascript -e 'user locale of (get system info)')
if [[ $lang == *"sr"* || $lang == *"SR"* ]] then # Serbian
    _lng=$_lngSR
    _lkey="sr"
else # English
    _lng=$_lngEN
    _lkey="en"
fi

# check http connectivity
case "$(curl -s --max-time 2 -I http://google.com | sed 's/^[^ ]*  *\([0-9]\).*/\1/; 1q')" in
[23]) online=0;; # ok
5) online=1;; # proxy declined connection
*) online=1;; # connection is down or slow
esac

if [ $online -eq 0 ]; then # online
    _res=`curl -s https://$_api/quotes/random/$_lng`
    echo $_res >| $file_name
else # offline
    if [ -f $file_name ]; then # file found
        _res=$(<$file_name)
        if [[ ! $_res == *"$_lkey"* ]]; then # lang not found
            echo "ERR: proquotes ran into an error. See you in the next zsh session ~ Dennis Murage"
            return
        fi
    else # no file
        echo "ERR: proquotes ran into an error. See you in the next zsh session ~ Dennis Murage"
        return
    fi
fi

# process quote
if [[ $_lkey == "en" ]]; then # English
    _qt=`print $_res | python -c 'import json,sys; obj=json.load(sys.stdin);print obj["en"].encode("ascii", "ignore");'`
    else # Sr
        _qt=`print $_res | python -c 'import json,sys; obj=json.load(sys.stdin);print obj["sr"].encode("ascii", "ignore");'`
fi

_aut=`print $_res | sed -e 's/[{}]/''/g' | sed s/\"//g | awk -v RS=',' -F: '$1=="author"{print $2}'`

# output
echo "${_qt}" \~ "${_aut}"

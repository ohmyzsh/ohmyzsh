# Get a random quote fron the sitehttp://www.quotationspage.com/random.php3
# Created by Eduardo San Martin Morote aka Posva
# www.killdaducks.com
# Sat May 18 16:28:43 CEST 2013 
# Don't remove this header, thank you

if [[ -x `which curl` ]]; then
    function quote()
    {
        Q=$(curl -s --connect-timeout 2 "http://www.quotationspage.com/random.php3" | grep -m 1 "dt ")
        TXT=$(echo "$Q" | sed -e 's/<\/dt>.*//g' -e 's/.*html//g' -e 's/^[^a-zA-Z]*//' -e 's/<\/a..*$//g')
        W=$(echo "$Q" | sed -e 's/.*\/quotes\///g' -e 's/<.*//g' -e 's/.*">//g')
        echo "\e[0;33m${W}\033[0\e[0;30m: \e[0;35m“${TXT}”\e[m"
    }
    #quote&
fi

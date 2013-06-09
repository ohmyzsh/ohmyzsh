# Get a random quote fron the site http://www.quotationspage.com/random.php3
# Created by Eduardo San Martin Morote aka Posva
# http://posva.github.io
# Sun Jun 09 10:59:36 CEST 2013 
# Don't remove this header, thank you
# Usage: quote

if [[ -x `which curl` ]]; then
    function quote()
    {
        Q=$(curl -s --connect-timeout 2 "http://www.quotationspage.com/random.php3" | grep -m 1 "dt ")
        TXT=$(echo "$Q" | sed -e 's/<\/dt>.*//g' -e 's/.*html//g' -e 's/^[^a-zA-Z]*//' -e 's/<\/a..*$//g')
        W=$(echo "$Q" | sed -e 's/.*\/quotes\///g' -e 's/<.*//g' -e 's/.*">//g')
        echo "\e[0;33m${W}\e[0;30m: \e[0;35m“${TXT}”\e[m"
    }
    #quote
fi

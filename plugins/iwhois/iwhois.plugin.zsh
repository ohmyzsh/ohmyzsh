# provide a whois command with a more accurate and up to date list of whois
# servers using CNAMES via whois.geek.nz

function iwhois() {
    resolver="whois.geek.nz"
    tld=`echo ${@: -1} | awk -F "." '{print $NF}'`
    whois -h ${tld}.${resolver} "$@" ;
}

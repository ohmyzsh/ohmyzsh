# IP/ASN lookup by using cymru's whois server
#>whois 8.8.8.8
#AS      | IP               | AS Name
#15169   | 8.8.8.8          | GOOGLE - Google Inc., US
#>cwhois as15169
#AS Name
#GOOGLE - Google Inc., US

function cwhois() {
    whois -h whois.cymru.com "$@" ;
}

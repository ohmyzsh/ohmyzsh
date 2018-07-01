# provide a command to find out your current external ip
# using opendns resolver

function myip() {
    resolver="@resolver1.opendns.com"
    ip="myip.opendns.com"
    dig +short ${ip} ${resolver}
}

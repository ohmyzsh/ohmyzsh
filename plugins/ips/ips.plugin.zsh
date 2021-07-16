# easy get ip - internal & external
alias ipe="curl -s ipv4.icanhazip.com"
alias ipi="ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*'| grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1'"

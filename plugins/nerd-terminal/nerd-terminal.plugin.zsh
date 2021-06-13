# nerd-terminal: several aliases for nerd terminal apps
#                this plugin requires telnet and curl

# functions
excuse() { echo $(telnet bofh.jeffballard.us 666 2>/dev/null) | grep --color -o "Your excuse is:.*$" ; }
starwars() { telnet towel.blinkenlights.nl ; }
starwars6() { telnet -6 towel.blinkenlights.nl ; }
weather() { curl wttr.in/$1 ; }

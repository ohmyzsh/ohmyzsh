# Some useful nmap aliases for scan modes

# Nmap options are:
#  -sS - TCP SYN scan
#  -v - verbose
#  -T1 - timing of scan. Options are paranoid (0), sneaky (1), polite (2), normal (3), aggressive (4), and insane (5)
#  -sF - FIN scan (can sneak through non-stateful firewalls)
#  -PE - ICMP echo discovery probe
#  -PP - timestamp discovery probe
#  -PY - SCTP init ping
#  -g - use given number as source port
#  -A - enable OS detection, version detection, script scanning, and traceroute (aggressive)
#  -O - enable OS detection
#  -sA - TCP ACK scan
#  -F - fast scan
#  --script=vulscan - also access vulnerabilities in target

alias nmap_open_ports="nmap --open"
alias nmap_list_interfaces="nmap --iflist"
alias nmap_slow="nmap -sS -v -T1"
alias nmap_fin="nmap -sF -v"
alias nmap_full="nmap -sS -T4 -PE -PP -PS80,443 -PY -g 53 -A -p1-65535 -v"
alias nmap_check_for_firewall="nmap -sA -p1-65535 -v -T4"
alias nmap_ping_through_firewall="nmap -PS -PA"
alias nmap_fast="nmap -F -T5 --top-ports 300"
alias nmap_detect_versions="nmap -sV -p1-65535 -O --osscan-guess -T4 -Pn"
alias nmap_check_for_vulns="nmap --script=vulscan"


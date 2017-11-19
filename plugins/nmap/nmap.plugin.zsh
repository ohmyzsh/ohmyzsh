# Some useful nmap aliases for scan modes

# Nmap options:
#  -sS - TCP SYN scan
#  -v - verbose
#  -f - fragment tcp packets
#  --spoof-mac - clone mac address, try to find hosts of trust and clone their mac
#  -D - create Decoys, slower but difficult to trace real ip. Try to decoy real ip addresses
#  --data-length - increase or decrease data length to avoid IDS
#  -n - skip DNS resolution
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
#  -sn - disable port scan
#  -Pn - treat host as UP, skip host discovery.
#  --open - show only open (not filtered) ports. Good for quick recon.
#  -g - change source port, for firewall evasion, (port 53 = dns queries, port 67 = DHCP).
#  
#  Nmap Scripts:
#  --script=vulscan - also access vulnerabilities in target
#  --script='smb-vuln* and not smb-vuln-regsvc-dos' - check for smb vulns but discard unsafe D.o.S.
#  --script=dns-brute - check for dns entries.
#  --script=http-sql-injection - check for SQL injection, watch for false positives.
#  --script=http-vhosts - search for common virtual hosts.
#  --script=auth - check for badly configure devices, common/empty passwords, etc.

alias nmap_open_ports="nmap --open"
alias nmap_list_interfaces="nmap --iflist"
alias nmap_slow="nmap -sS -v -T1"
alias nmap_fin="nmap -sF -v"
alias nmap_full="nmap -sS -T4 -PE -PP -PS80,443 -PY -g 53 -A -p1-65535 -v"
alias nmap_check_for_firewall="nmap -sA -p1-65535 -v -T4"
alias nmap_ping_through_firewall="nmap -PS -PA"
alias nmap_fast="nmap -F -T5 --version-light --top-ports 300"
alias nmap_detect_versions="nmap -sV -p1-65535 -O --osscan-guess -T4 -Pn"
alias nmap_check_for_vulns="nmap --script=vulscan"
alias nmap_full_udp="nmap -sS -sU -T4 -A -v -PE -PS22,25,80 -PA21,23,80,443,3389 "
alias nmap_traceroute="nmap -sP -PE -PS22,25,80 -PA21,23,80,3389 -PU -PO --traceroute "
alias nmap_full_with_scripts="sudo nmap -sS -sU -T4 -A -v -PE -PP -PS21,22,23,25,80,113,31339 -PA80,113,443,10042 -PO --script all " 
alias nmap_web_safe_osscan="sudo nmap -p 80,443 -O -v --osscan-guess --fuzzy "
alias nmap_dns_brute="sudo nmap --script=dns-brute -T3 "
alias nmap_dns_brute_noscan="sudo nmap -sn -Pn --script=dns-brute -T3 "
alias nmap_check_smb_vuln="sudo nmap --script='smb-vuln* and not smb-vuln-regsvc-dos' -p445,139 --open "
alias nmap_find_sqli="sudo nmap --script=http-sql-injection "
alias nmap_fast_auth="sudo nmap --script=auth -Pn -n -g53 -T4 -F "
alias nmap_find_vhosts="sudo nmap --script=http-vhosts "
# use 3 decoys, 53 as source port, normal speed, change data length, spoof a cisco MAC addr, never ping, never dns resolution.
alias nmap_firewall_bypass="sudo nmap --script=firewall-bypass -D RND:3,ME -g53 -f -T3 --data-length 72 --spoof-mac cisco -n -Pn "
# Nmap aliases plugin

Adds some useful aliases for nmap similar to the profiles in zenmap.

Nmap options are:
 * -sS - TCP SYN scan
 * -v - verbose
 * -T1 - timing of scan. Options are paranoid (0), sneaky (1), polite (2), normal (3), aggressive (4), and insane (5)
 * -sF - FIN scan (can sneak through non-stateful firewalls)
 * -PE - ICMP echo discovery probe
 * -PP - timestamp discovery probe
 * -PY - SCTP init ping
 * -g - use given number as source port
 * -A - enable OS detection, version detection, script scanning, and traceroute (aggressive)
 * -O - enable OS detection
 * -sA - TCP ACK scan
 * -F - fast scan
 * --script=vulscan - also access vulnerabilities in target

## Aliases explained

 * nmap_open_ports - scan for open ports on target
 * nmap_list_interfaces - list all network interfaces on host where the command runs
 * nmap_slow - slow scan that avoids to spam the targets logs
 * nmap_fin - scan to see if hosts are up with TCP FIN scan
 * nmap_full - aggressive full scan that scans all ports, tries to determine OS and service versions
 * nmap_check_for_firewall - TCP ACK scan to check for firewall existence
 * nmap_ping_through_firewall - Host discovery with SYN and ACK probes instead of just pings to avoid firewall
   restrictions
 * nmap_fast - Fast scan of the top 300 popular ports
 * nmap_detect_versions - detects versions of services and OS, runs on all ports
 * nmap_check_for_vulns - uses vulscan script to check target services for vulnerabilities

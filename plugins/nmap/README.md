<<<<<<< HEAD
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
=======
# Nmap plugin

Adds some useful aliases for [Nmap](https://nmap.org/) similar to the profiles in zenmap.

To use it, add `nmap` to the plugins array in your zshrc file:

```zsh
plugins=(... nmap)
```

## Aliases

- `nmap_open_ports`: scan for open ports on target.
- `nmap_list_interfaces`: list all network interfaces on host where the command runs.
- `nmap_slow`: slow scan that avoids to spam the targets logs.
- `nmap_fin`: scan to see if hosts are up with TCP FIN scan.
- `nmap_full`: aggressive full scan that scans all ports, tries to determine OS and service versions.
- `nmap_check_for_firewall`: TCP ACK scan to check for firewall existence.
- `nmap_ping_through_firewall`: host discovery with SYN and ACK probes instead of just pings to avoid firewall restrictions.
- `nmap_fast`: fast scan of the top 300 popular ports.
- `nmap_detect_versions`: detects versions of services and OS, runs on all ports.
- `nmap_check_for_vulns`: uses vulscan script to check target services for vulnerabilities.
- `nmap_full_udp`: same as full but via UDP.
- `nmap_traceroute`: try to traceroute using the most common ports.
- `nmap_full_with_scripts`: same as nmap_full but also runs all the scripts.
- `nmap_web_safe_osscan`: little "safer" scan for OS version  as connecting to only HTTP and HTTPS ports doesn't look so attacking.
- `nmap_ping_scan`: ICMP scan for active hosts.
>>>>>>> 4d9e5ce9a7d8db3c3aadcae81580a5c3ff5a0e8b

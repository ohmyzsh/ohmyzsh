# Nmap Plugin 

## Overview

This plugin provides a comprehensive set of aliases for [Nmap](https://nmap.org/), the powerful network scanning tool. These aliases cover common scanning scenarios similar to the profiles in Zenmap, making network reconnaissance and security testing more efficient.

## Installation

To use this plugin, add `nmap` to the plugins array in your zshrc file:

```zsh
plugins=(... nmap)
```

Make sure Nmap is installed on your system. You can install it on most systems with:

- **macOS**: `brew install nmap`
- **Ubuntu/Debian**: `sudo apt install nmap`
- **Fedora/RHEL**: `sudo dnf install nmap`
- **Arch Linux**: `sudo pacman -S nmap`

## Alias Categories

### 1. Basic Scans

| Alias | Command | Description |
|-------|---------|-------------|
| `nmap_open_ports` | `nmap --open` | Shows only open ports on target hosts |
| `nmap_quick` | `nmap -T4 -F` | Quick scan using default scripts at timing template 4 |
| `nmap_ping_scan` | `nmap -n -sP` | Simple ping scan to discover hosts |
| `nmap_net` | `nmap -sn` | Network discovery without port scanning |
| `nmap_tcp` | `nmap -sT` | Basic TCP connect scan |
| `nmap_all_ports` | `nmap -p-` | Scan all 65535 ports |
| `nmap_ports` | `nmap -p` | Scan specific ports (requires port numbers as argument) |

### 2. Host and Interface Discovery

| Alias | Command | Description |
|-------|---------|-------------|
| `nmap_list_interfaces` | `nmap --iflist` | Lists all network interfaces on the host |
| `nmap_ping_through_firewall` | `nmap -PS -PA` | Host discovery with SYN/ACK probes to bypass firewall restrictions |
| `nmap_ping_tcp` | `nmap -PS` | TCP SYN ping discovery |
| `nmap_ping_ack` | `nmap -PA` | TCP ACK ping discovery |
| `nmap_ping_udp` | `sudo nmap -PU` | UDP ping discovery (requires root) |
| `nmap_no_ping` | `nmap -Pn` | Skip ping discovery (treat all hosts as online) |

### 3. Performance Scans

| Alias | Command | Description |
|-------|---------|-------------|
| `nmap_fast` | `nmap -F -T5 --version-light --top-ports 300` | Fast scan of the top 300 popular ports |
| `nmap_slow` | `sudo nmap -sS -v -T1` | Slow, stealthy scan that avoids triggering IDS/IPS |

### 4. Comprehensive Scans

| Alias | Command | Description |
|-------|---------|-------------|
| `nmap_full` | `sudo nmap -sS -T4 -PE -PP -PS80,443 -PY -g 53 -A -p1-65535 -v` | Aggressive full scan that examines all ports with service detection and OS identification |
| `nmap_full_udp` | `sudo nmap -sS -sU -T4 -A -v -PE -PS22,25,80 -PA21,23,80,443,3389` | Full TCP and UDP scan with version detection |
| `nmap_full_with_scripts` | `sudo nmap -sS -sU -T4 -A -v -PE -PP -PS21,22,23,25,80,113,31339 -PA80,113,443,10042 -PO --script all` | Exhaustive scan with all scripts |
| `nmap_detect_versions` | `sudo nmap -sV -p1-65535 -O --osscan-guess -T4 -Pn` | Detects versions of services and OS on all ports |
| `nmap_aggressive` | `sudo nmap -A -T4 -v` | Aggressive scan with OS and version detection, script scanning, and traceroute |

### 5. Stealth and Evasion Techniques

| Alias | Command | Description |
|-------|---------|-------------|
| `nmap_stealth` | `sudo nmap -sS -T2` | Stealthy SYN scan at slower timing for IDS evasion |
| `nmap_fin` | `sudo nmap -sF -v` | FIN scan to check if hosts are up (may bypass some firewalls) |
| `nmap_null` | `sudo nmap -sN` | TCP NULL scan (no flags set) |
| `nmap_xmas` | `sudo nmap -sX` | TCP XMAS scan (FIN, PSH, URG flags) |
| `nmap_ack` | `sudo nmap -sA` | TCP ACK scan |
| `nmap_window` | `sudo nmap -sW` | TCP Window scan |
| `nmap_mainmon` | `sudo nmap -sM` | TCP Maimon scan |
| `nmap_fragment` | `sudo nmap -f` | Fragment packets to evade detection |
| `nmap_evasion` | `sudo nmap -D RND:10` | Decoy scan with 10 random IP addresses |

### 6. Advanced Techniques

| Alias | Command | Description |
|-------|---------|-------------|
| `nmap_idle` | `sudo nmap -sI` | Idle scan (requires zombie IP as argument) |
| `nmap_ftp_bounce` | `sudo nmap -b` | FTP bounce scan (requires FTP server as argument) |
| `nmap_sctp` | `sudo nmap -sY` | SCTP INIT scan for SCTP services |
| `nmap_traceroute` | `sudo nmap -sP -PE -PS22,25,80 -PA21,23,80,3389 -PU -PO --traceroute` | Performs traceroute using most common ports |
| `nmap_ipv6` | `nmap -6` | Enables IPv6 scanning |

### 7. Specialized Scans

| Alias | Command | Description |
|-------|---------|-------------|
| `nmap_os` | `sudo nmap -O` | Operating system detection |
| `nmap_web_safe_osscan` | `sudo nmap -p 80,443 -O -v --osscan-guess --fuzzy` | "Safer" OS scan by connecting only to HTTP/HTTPS ports |
| `nmap_check_for_firewall` | `sudo nmap -sA -p1-65535 -v -T4` | TCP ACK scan to detect firewall presence and rules |
| `nmap_udp` | `sudo nmap -sU` | UDP port scan |

### 8. Script-Based Scans

| Alias | Command | Description |
|-------|---------|-------------|
| `nmap_check_for_vulns` | `nmap --script=vuln` | Scans for known vulnerabilities |
| `nmap_brute` | `nmap --script=brute` | Attempts brute force authentication against services |
| `nmap_discovery` | `nmap --script=discovery` | Uses discovery scripts to gather information |
| `nmap_safe` | `nmap --script=safe` | Runs scripts considered safe and non-intrusive |
| `nmap_malware` | `nmap --script=malware` | Checks for backdoors and malware |
| `nmap_auth` | `nmap --script=auth` | Attempts to bypass authentication |

## Usage Examples

### Basic Host Discovery
```
# Find all active hosts on a network
nmap_net 192.168.1.0/24

# Scan a single host for open ports
nmap_open_ports 192.168.1.100
```

### Security Assessments
```
# Full vulnerability scan of a web server
nmap_check_for_vulns 192.168.1.100

# Comprehensive scan of a server
nmap_full 192.168.1.100
```

### Stealth Operations
```
# Evasive scan through a firewall
nmap_stealth 192.168.1.100

# Decoy scan with spoofed IP addresses
nmap_evasion 192.168.1.100
```

### Performance Options
```
# Quick network inventory
nmap_fast 192.168.1.0/24

# Thorough but slow scan for sensitive environments
nmap_slow 192.168.1.100
```

## Notes

- Aliases prefixed with `sudo` require root privileges to run properly
- For more information about specific Nmap options, refer to `man nmap` or visit the [Nmap documentation](https://nmap.org/book/man.html)
- Use these tools responsibly and only on networks you have permission to scan

## License

This plugin is available under the same license as Oh My Zsh.

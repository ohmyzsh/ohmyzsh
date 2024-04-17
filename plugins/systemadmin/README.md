# Systemadmin plugin

This plugin adds a series of aliases and functions which make a System Administrator's life easier.

To use it, add `systemadmin` to the plugins array in your zshrc file:

```zsh
plugins=(... systemadmin)
```

## Aliases

| Alias   | Command                                                                    | Description                                                        |
|---------|----------------------------------------------------------------------------|--------------------------------------------------------------------|
| ping    | `ping -c 5`                                                                | Sends only 5 ICMP Messages                                         |
| clr     | `clear; echo Currently logged in on $TTY, as $USERNAME in directory $PWD.` | Clears the screen and prints the current user, TTY, and directory  |
| path    | `print -l $path`                                                           | Displays PATH with each entry on a separate line                   |
| mkdir   | `mkdir -pv`                                                                | Automatically create parent directories and display verbose output |
| psmem   | `ps -e -orss=,args= \| sort -b -k1 -nr`                                    | Display the processes using the most memory                        |
| psmem10 | `ps -e -orss=,args= \| sort -b -k1 -nr \| head -n 10`                      | Display the top 10 processes using the most memory                 |
| pscpu   | `ps -e -o pcpu,cpu,nice,state,cputime,args \|sort -k1 -nr`                 | Display the top processes using the most CPU                       |
| pscpu10 | `ps -e -o pcpu,cpu,nice,state,cputime,args \|sort -k1 -nr \| head -n 10`   | Display the top 10 processes using the most CPU                    |
| hist10  | `print -l ${(o)history%% *} \| uniq -c \| sort -nr \| head -n 10`          | Display the top 10 most used commands in the history               |

## Functions

| Function    |  Description                                                                                                          |
|-------------|-----------------------------------------------------------------------------------------------------------------------|
| dls         | List only directories in the current directory                                                                        |
| psgrep      | List all processes that match the pattern input after the command                                                     |
| killit      | Kills any process that matches a regular expression passed to it                                                      |
| tree        | List contents of directories in a tree-like format (if tree isn't installed)                                          |
| sortcons    | Sort connections by state                                                                                             |
| con80       | View all 80 Port Connections                                                                                          |
| sortconip   | On the connected IP sorted by the number of connections                                                               |
| req20       | List the top 20 requests on port 80                                                                                   |
| http20      | List the top 20 connections to port 80 based on tcpdump data                                                          |
| timewait20  | List the top 20 time_wait connections                                                                                 |
| syn20       | List the top 20 SYN connections                                                                                       |
| port_pro    | Output all processes according to the port number                                                                     |
| accessip10  | List the top 10 accesses to the ip address in the nginx/access.log file or another log file if specified              |
| visitpage20 | List the top 20 most visited files or pages in the nginx/access.log file or another log file if specified             |
| consume100  | List the 100 most time-consuming Page lists (more than 60 seconds) as well as the corresponding number of occurrences |
| webtraffic  | List website traffic statistics in GB from the nginx/access.log file or another log file if specified                 |
| c404        | List statistics on 404 connections in the nginx/access.log file or another log file if specified                      |
| httpstatus  | List statistics based on http status in the nginx/access.log file or another log file if specified                    |
| d0          | Delete 0 byte files recursively in the current directory or another if specified                                      |
| geteip      | Gather information regarding an external IP address using [icanhazip.com](https://icanhazip.com)                      |
| getip       | Determine the local IP Address with `ip addr` or `ifconfig`                                                           |
| clrz        | Clear zombie processes                                                                                                |
| conssec     | Show number of concurrent connections per second based on ngnix/access.log file or another log file if specified      |

# ------------------------------------------------------------------------------
# Description
# -----------
#
# This is one for the system administrator, operation and maintenance.
#
# ------------------------------------------------------------------------------
# Authors
# -------
#
# * Dongweiming <ciici123@gmail.com>
#
# ------------------------------------------------------------------------------

function retlog() {
    if [[ -z $1 ]];then
        echo '/var/log/nginx/access.log'
    else
        echo $1
    fi
}

alias ping='ping -c 5'
alias clr='clear; echo Currently logged in on $TTY, as $USERNAME in directory $PWD.'
alias path='print -l $path'
alias mkdir='mkdir -pv'
# get top process eating memory
alias psmem='ps -e -orss=,args= | sort -b -k1 -nr'
alias psmem10='ps -e -orss=,args= | sort -b -k1 -nr | head -n 10'
# get top process eating cpu if not work try execute : export LC_ALL='C'
alias pscpu='ps -e -o pcpu,cpu,nice,state,cputime,args|sort -k1,1n -nr'
alias pscpu10='ps -e -o pcpu,cpu,nice,state,cputime,args|sort -k1,1n -nr | head -n 10'
# top10 of the history
alias hist10='print -l ${(o)history%% *} | uniq -c | sort -nr | head -n 10'

function ip() {
    if [ -t 1 ]; then
        command ip -color "$@"
    else
        command ip "$@"
    fi
}

# directory LS
function dls() {
    print -l *(/)
}
function psgrep() {
    ps aux | grep "${1:-.}" | grep -v grep
}
# Kills any process that matches a regexp passed to it
function killit() {
    ps aux | grep -v "grep" | grep "$@" | awk '{print $2}' | xargs sudo kill
}

# list contents of directories in a tree-like format
if ! (( $+commands[tree] )); then
    function tree() {
        find $@ -print | sed -e 's;[^/]*/;|____;g;s;____|; |;g'
    }
fi

# Sort connection state
function sortcons() {
    netstat -nat |awk '{print $6}'|sort|uniq -c|sort -rn
}

# View all 80 Port Connections
function con80() {
    netstat -nat|grep -i ":80"|wc -l
}

# On the connected IP sorted by the number of connections
function sortconip() {
    netstat -ntu | awk '{print $5}' | cut -d: -f1 | sort | uniq -c | sort -n
}

# top20 of Find the number of requests on 80 port
function req20() {
    netstat -anlp|grep 80|grep tcp|awk '{print $5}'|awk -F: '{print $1}'|sort|uniq -c|sort -nr|head -n20
}

# top20 of Using tcpdump port 80 access to view
function http20() {
    sudo tcpdump -i eth0 -tnn dst port 80 -c 1000 | awk -F"." '{print $1"."$2"."$3"."$4}' | sort | uniq -c | sort -nr |head -n 20
}

# top20 of Find time_wait connection
function timewait20() {
    netstat -n|grep TIME_WAIT|awk '{print $5}'|sort|uniq -c|sort -rn|head -n20
}

# top20 of Find SYN connection
function syn20() {
    netstat -an | grep SYN | awk '{print $5}' | awk -F: '{print $1}' | sort | uniq -c | sort -nr|head -n20
}

# Printing process according to the port number
function port_pro() {
    netstat -ntlp | grep "${1:-.}" | awk '{print $7}' | cut -d/ -f1
}

# top10 of gain access to the ip address
function accessip10() {
    awk '{counts[$(11)]+=1}; END {for(url in counts) print counts[url], url}' "$(retlog)"
}

# top20 of Most Visited file or page
function visitpage20() {
    awk '{print $11}' "$(retlog)"|sort|uniq -c|sort -nr|head -n 20
}

# top100 of Page lists the most time-consuming (more than 60 seconds) as well as the corresponding page number of occurrences
function consume100() {
    awk '($NF > 60 && $7~/\.php/){print $7}' "$(retlog)" |sort -n|uniq -c|sort -nr|head -n 100
    # if django website or other website make by no suffix language
    # awk '{print $7}' "$(retlog)" |sort -n|uniq -c|sort -nr|head -n 100
}

# Website traffic statistics (G)
function webtraffic() {
    awk "{sum+=$10} END {print sum/1024/1024/1024}" "$(retlog)"
}

# Statistical connections 404
function c404() {
    awk '($9 ~/404/)' "$(retlog)" | awk '{print $9,$7}' | sort
}

# Statistical http status.
function httpstatus() {
    awk '{counts[$(9)]+=1}; END {for(code in counts) print code, counts[code]}' "$(retlog)"
}

# Delete 0 byte file
function d0() {
    find "${1:-.}" -type f -size 0 -exec rm -rf {} \;
}

# gather external ip address
function geteip() {
    curl -s -S -4 https://icanhazip.com
    curl -s -S -6 https://icanhazip.com
}

# determine local IP address(es)
function getip() {
    if (( ${+commands[ip]} )); then
        ip addr | awk '/inet /{print $2}' | command grep -v 127.0.0.1
    else
        ifconfig | awk '/inet /{print $2}' | command grep -v 127.0.0.1
    fi
}

# Clear zombie processes
function clrz() {
    ps -eal | awk '{ if ($2 == "Z") {print $4}}' | kill -9
}

# Second concurrent
function conssec() {
    awk '{if($9~/200|30|404/)COUNT[$4]++}END{for( a in COUNT) print a,COUNT[a]}' "$(retlog)"|sort -k 2 -nr|head -n10
}

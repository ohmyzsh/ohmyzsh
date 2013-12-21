function zsh_stats() {
  op=$(history | awk '{CMD[$2]++;count++;}END { for (a in CMD)print CMD[a] " " CMD[a]/count*100 "% " a;}' | grep -v "./" | column -c3 -s " " -t | sort -nr | nl |  head -n20 )
  echo "$op"
}

function uninstall_oh_my_zsh() {
  /usr/bin/env ZSH=$ZSH /bin/sh $ZSH/tools/uninstall.sh
}

function upgrade_oh_my_zsh() {
  /usr/bin/env ZSH=$ZSH /bin/sh $ZSH/tools/upgrade.sh
}

function take() {
  mkdir -p $1
  cd $1
}


per(){
    ls -l | awk '{k=0;for(i=0;i<=8;i++)k+=((substr($1,i+2,1)~/[rwx]/) \
                 *2^(8-i));if(k)printf("%0o ",k);print}'
}

flush(){
#Script to unload and reload mDNS as it is a bit crappy
sudo launchctl unload /System/Library/LaunchDaemons/com.apple.mDNSResponder.plist
echo "mDNS unloaded"
sleep 5
sudo launchctl load /System/Library/LaunchDaemons/com.apple.mDNSResponder.plist
echo "mDNS loaded"
sleep 5
echo "Hopefully you can get on with browsing again"
}


dt() {
result=$(defaults read com.apple.finder CreateDesktop)
if [[ "$result" == 1 ]]
then
		defaults write com.apple.finder CreateDesktop 0
        echo Hide desktop
fi

if [[ "$result" == 0 ]]
then
		defaults write com.apple.finder CreateDesktop 1
        echo Show desktop
		
fi
killall Finder
}
work(){
    echo 'vjW5zWfXLMBDxnj9gJ7F\n'
    ssh andrew@69.194.130.58
}



vis() {
 
 
        # check if hidden files are visible and store result in a variable
        isVisible=$(defaults read com.apple.finder AppleShowAllFiles)
        if [ "$isVisible" = "FALSE" ]
        then
        echo Hidden Viewing On
        defaults write com.apple.finder AppleShowAllFiles TRUE
        else
        echo Hidden Videwing Off
        defaults write com.apple.finder AppleShowAllFiles FALSE
        fi
        # force changes by restarting Finder
        killall Finder
}

dl(){
    python ~/Desktop/musicdl.py `pbpaste`
}

webserv(){
  python -m SimpleHTTPServer
}

lsext()
{
find \( ! -name . -prune \) -type f -iname '*.'${1}'' -exec ls $LS_OPTIONS -hF {} \; ;
}

rpass() {
        cat /dev/urandom | LC_CTYPE=C tr -dc A-Za-z0-9_\!\@\#\$\%\^\&\*\(\)-+= | head -c ${1:-12}
}

genpass() {
        local l=$1
        [ "$l" == "" ] && l=8
        LC_CTYPE=C tr -dc A-Za-z0-9_\!\@\#\$\%\^\&\*\(\)-+= < /dev/urandom | head -c ${l} | xargs
}

downloads() {
sqlite3 ~/Library/Preferences/com.apple.LaunchServices.QuarantineEventsV* 'select LSQuarantineDataURLString from LSQuarantineEvent' |more
}
hide(){
  chflags hidden $1
}
unhide(){
  chflags nohidden $1
}
connected(){
lsof -i | grep ESTABLISHED
}
look(){
  qlmanage -p "$1"
}


mach()
{
    echo -e "\nMachine information:" ; uname -a
    echo -e "\nUsers logged on:" ; w -h
    echo -e "\nCurrent date :" ; date
    echo -e "\nMachine status :" ; uptime
    echo -e "\nFilesystem status :"; df -h
    echo -e "\nMemory status :" ; top -l 1 | grep ^PhysMem
  echo -e "\nIP Information: "; curl ifconfig.me
}
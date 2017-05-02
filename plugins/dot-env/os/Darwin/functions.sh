# cdf: cd's to frontmost window of Finder
cdf () {
	currFolderPath=$( /usr/bin/osascript <<"EOT"
	  tell application "Finder"
	    try
	      set currFolder to (folder of the front window as alias)
	    on error
	      set currFolder to (path to desktop folder as alias)
	    end try
	    POSIX path of currFolder
	  end tell
EOT
	)
	echo "cd to \"$currFolderPath\""
	cd "$currFolderPath"
}

# File Finders
# ff:  to find a file under the current directory
ff () { /usr/bin/find . -name "$@" ; }
# ffs: to find a file whose name starts with a given string
ffs () { /usr/bin/find . -name "$@"'*' ; }
# ffe: to find a file whose name ends with a given string
ffe () { /usr/bin/find . -name '*'"$@" ; }

# SPOTLIGHT
# locatemd: to search for a file using Spotlight's metadata
function locatemd { mdfind "kMDItemDisplayName == '$@'wc"; }
# locaterecent: to search for files created since yesterday using Spotlight
# This is an illustration of using $time in a query
# See: http://developer.apple.com/documentation/Carbon/Conceptual/SpotlightQuery/index.html
function locaterecent { mdfind 'kMDItemFSCreationDate >= $time.yesterday'; }

# list_all_apps: list all applications on the system
list_all_apps() { mdfind 'kMDItemContentTypeTree == "com.apple.application"c' ; }

# find_larger: find files larger than a certain size (in bytes)
find_larger() { find . -type f -size +${1}c ; }

#------------
# Processes:
#------------
alias pstree='/usr/local/bin/pstree -g 2 -w'

# findPid: find out the pid of a specified process
#    Note that the command name can be specified via a regex
#    E.g. findPid '/d$/' finds pids of all processes with names ending in 'd'
#    Without the 'sudo' it will only find processes of the current user
findPid () { sudo /usr/sbin/lsof -t -c "$@" ; }

# to find memory hogs:
alias mem_hogs_top='top -l 1 -o rsize -n 10'
alias mem_hogs_ps='ps wwaxm -o pid,stat,vsize,rss,time,command | head -10'

# to find CPU hogs
alias cpu_hogs='ps wwaxr -o pid,stat,%cpu,time,command | head -10'

# continual 'top' listing (every 10 seconds) showing top 15 CPU consumers
alias topforever='top -l 0 -s 10 -o cpu -n 15'

# recommended 'top' invocation to minimize resources in thie macosxhints article
# http://www.macosxhints.com/article.php?story=20060816123853639
# exec /usr/bin/top -R -F -s 10 -o rsize

# diskwho: to show processes reading/writing to disk
alias diskwho='sudo iotop'

#------------
# Networking:
#------------
# lsock: to display open sockets (the -P option to lsof disables port names)
alias lsock='sudo /usr/sbin/lsof -i -P'

# airportMtu: set the MTU on Airport to be a value that makes SMTP to DSL work
# (I determined the value empirically by using 'ping -s' to the SMTP server)
alias airportMtu='sudo ifconfig en1 mtu 1364'

# airport: Apple's command-line tool. For status info, use -I, for help use -h
# See: http://www.macosxhints.com/article.php?story=20050715001815547
alias airport='/System/Library/PrivateFrameworks/Apple80211.framework/Versions/A/Resources/airport'
# Note also the tool that I compiled: airport_info (in my Tools dir)

# ip_info: to get info on DHCP server, router, DNS server, etc (for en0 or en1)
alias ip_info='ipconfig getpacket en1'

# browse_bonjour: browse services advertised via Bonjour
# Note: need to supply a "type" argument- e.g. "_http._tcp"
# See http://www.dns-sd.org/ServiceTypes.html for more types
# Optionally supply a "domain" argument
alias browse_bonjour='dns-sd -B'

# hostname_lookup: interactive debugging mode for lookupd (use tab-completion)
alias hostname_lookup='lookupd -d'

# debug_http: download a web page and show info on what took time
debug_http () { /usr/bin/curl $@ -o /dev/null -w "dns: %{time_namelookup} connect: %{time_connect} pretransfer: %{time_pretransfer} starttransfer: %{time_starttransfer} total: %{time_total}\n" ; }

# http_headers: get just the HTTP headers from a web page (and its redirects)
http_headers () { /usr/bin/curl -I -L $@ ; }

# Note: 'active_net_iface' is my script that echos the active net interface
# pkt_trace: for use in the following aliases
alias pkt_trace='sudo tcpflow -i `active_net_iface` -c'

# smtp_trace: to show all SMTP packets
alias smtp_trace='pkt_trace port smtp'

# http_trace: to show all HTTP packets
alias http_trace='pkt_trace port 80'

# tcp_trace: to show all TCP packets
alias tcp_trace='pkt_trace tcp'

# udp_trace: to show all UDP packets
alias udp_trace='pkt_trace udp'

# ip_trace: to show all IP packets
alias ip_trace='pkt_trace ip'

# can use 'scselect' to find out current network "location"
# can use 'scutil' for other system config stuff

# to do socket programming in bash, redirect to /dev/tcp/$host/$port
# Example:
osaClient ()
{
    exec 5<> /dev/tcp/localhost/4321
    cat $1 >&5
    echo "-- end of file" >&5
    cat <&5
    exec 5>&-
}


#------
# Misc:
#------
# epochtime: report number of seconds since the Epoch
alias epochtime='date +%s'

# screensaverdesktop: run a screensaver on the Desktop
alias screensaverdesktop='/System/Library/Frameworks/ScreenSaver.framework/Resources/ScreenSaverEngine.app/Contents/MacOS/ScreenSaverEngine -background'

# consoleapp: launch the Console app from Terminal
alias consoleapp='/Applications/Utilities/Console.app/Contents/MacOS/Console &'

#---------------------------
# System operations & info:
#---------------------------
# repairpermissions
alias repairpermissions='sudo diskutil repairpermissions /'

# install all software updates from the command line
alias software_update_cmd='COMMAND_LINE_INSTALL=1 export COMMAND_LINE_INSTALL; sudo softwareupdate -i -a'

# third_party_kexts: to check for non-Apple kernel extensions
alias third_party_kexts='kextstat | grep -v com.apple'

# show_optical_disk_info - e.g. what type of CD & DVD media is supported
alias show_optical_disk_info='drutil info'

# remove_disk: spin down unneeded disk
# diskutil eject /dev/disk1s3
alias nd0='diskutil eject /dev/disk0s3'
alias nd1='diskutil eject /dev/disk1s3'

# mount_read_write: for use when booted into single-user
alias mount_read_write='/sbin/mount -uw /'

# herr: shows the most recent lines from the HTTP error log
alias herr='tail /var/log/httpd/error_log'

# use vsdbutil to show/change the permissions ignoring on external drives
# To ignore ownerships on a volume, do: sudo vsdbutil -d /VolumeName
# To restore ownerships on a volume, do: sudo vsdbutil -a /VolumeName
# To check the status of ownerships, do: sudo vsdbutil -c /VolumeName
alias ignore_permissions='sudo vsdbutil -d'

# to change the password on anencrypted disk image:
# hdiutil chpass /path/to/the/diskimage

# netparams: to show values of network parameters in the kernel
alias netparams='sysctl -a | grep net'

# swapinfo: to display info on swap
alias swapinfo='sysctl vm.swapusage'

# get info about system via AppleScript
# Note: this is rather slow - it is faster to run 'system_profiler'
# Note: to get computer name use:  computer name of (system info)
applescript_info ()
{
    info=$( /usr/bin/osascript <<"    EOT"
        system info
    EOT
    )
    echo $info
}

# to mount a read-only disk image as read-write:
# hdiutil attach example.dmg -shadow /tmp/example.shadow -noverify

# mounting a removable drive (of type msdos or hfs)
# mkdir /Volumes/Foo
# ls /dev/disk*   to find out the device to use in the mount command)
# mount -t msdos /dev/disk1s1 /Volumes/Foo
# mount -t hfs /dev/disk1s1 /Volumes/Foo

# to create a file of a given size: /usr/sbin/mkfile or /usr/bin/hdiutil
# e.g.: mkfile 10m 10MB.dat
# e.g.: hdiutil create -size 10m 10MB.dmg
# the above create files that are almost all zeros - if random bytes are desired
# then use: ~/Dev/Perl/randBytes 1048576 > 10MB.dat

# making a hard-link backup of a directory
# rsync -a --delete --link-dest=$DIR $DIR /backup/path/for/dir

# starting AFP file sharing
alias startFileSharing='sudo /usr/sbin/AppleFileServer'

# hidden command line utilities: networksetup & systemsetup
alias networksetup='/System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Support/networksetup'
alias systemsetup='/System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Support/systemsetup'
alias ardkickstart='/System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart'


#--------
# Finder:
#---------
# show hidden files in Finder
alias finderShowHidden='defaults write com.apple.finder ShowAllFiles TRUE'
alias finderHideHidden='defaults write com.apple.finder ShowAllFiles FALSE'

# finderTurnOffDesktop: turn off display of files on the Desktop
alias finderTurnOffDesktop='defaults write com.apple.finder CreateDesktop FALSE'

# to stop Finder writing .DS_Store files on network volumes
# defaults write com.apple.desktopservices DSDontWriteNetworkStores true

# lsregister: utility for looking at the Launch Services database
# e.g. 'lsregister -dump' to display database contents
# use 'lsregister -h' to get usage info
alias lsregister='/System/Library/Frameworks/ApplicationServices.framework/Frameworks/LaunchServices.framework/Support/lsregister'

# disable and re-enable Dashboard Widgets
alias disableDashboard='defaults write com.apple.dashboard mcx-disabled -bool YES; killall Dock'
alias enableDashboard='defaults delete com.apple.dashboard mcx-disabled; killAll Dock'

# ql: show a "Quick Look" view of files
ql () { /usr/bin/qlmanage -p "$@" >& /dev/null & }

# locateql: search using Spotlight and show a "Quick Look" of matching files
locateql ()
{
    locatemd "$@" | enquote | xargs qlmanage -p >& /dev/null &
}

#--------
# Safari:
#--------
# cleanup_favicons: clean up Safari favicons
alias cleanup_favicons='find $HOME/Library/Safari/Icons -type f -atime +30 -name "*.cache" -print -delete'


#-----------------
# Misc Reminders:
#-----------------

# To find idle time: look for HIDIdleTime in output of 'ioreg -c IOHIDSystem'

# to set the delay for drag & drop of text (integer number of milliseconds)
# defaults write -g NSDragAndDropTextDelay -int 100

# URL for a man page (example): x-man-page://3/malloc

# to read a single key press:
alias keypress='read -s -n1 keypress; echo $keypress'

# to compile an AppleScript file to a resource-fork in the source file:
osacompile_rsrc () { osacompile -x -r scpt:128 -o $1 $1; }

# alternative to the use of 'basename' for usage statements: ${0##*/}

# graphical operations, image manipulation: sips

# numerical user id: 'id -u'
# e.g.: ls -l /private/var/tmp/mds/$(id -u)


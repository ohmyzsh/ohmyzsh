##some functions
###############
##--Daemons--##
###############
# starts, stops, restarts and check status of daemons

dstart() {
	for arg in $@
	do
		sudo /etc/rc.d/$arg start
	done
}
dstop() {
	for arg in $@
	do
		sudo /etc/rc.d/$arg stop
	done
}
drestart() {
	for arg in $@
	do
		sudo /etc/rc.d/$arg restart
	done
}
dstatus() {
	for	arg in $@
	do
		sudo /etc/rc.d/$arg status
	done
}


###Alias
## checks if pacman-color is installed 
## pcman var  is needed because for some reason using pacman-color with sudo in an alias doesnt work
if which pacman-color &>/dev/null; then
	 pcman='pacman-color'
else 
	pcman='pacman'
fi

alias pacman='$pcman'
alias pacupd='_ $pcman -Syu' ##syncs and updates 
alias pacser='$pcman -Ss' ##search repos for pkgs
alias pacins='_ $pcman -S' ##install pkgs
alias pacinf='$pcman -Qi' ##info of installed pkgs
alias paciss='$pcman -Qs' ##search installed pkgs
alias pacrm='_ $pcman -R' ##uninstalls pkgs
alias pacrmd='_ $pcman -Rs' ##remove a package and deps which are not required by any other installed package
alias pacrma='_ $pcman -Rsn' ##remove a package and deps and .pacsave files
alias pacclc='_ S $pcman -Scc' ## cleans pkgs cache and repos db
##makepkg alias
alias mksource='makepkg --source -f'
alias mkp='makepkg -sf ;alert'
alias mkpi='makepkg -sfi '
alias mkall='makepkg -sf && makepkg --source -f '
alias mkalli='makepkg -sfi && makepkg --source -f '

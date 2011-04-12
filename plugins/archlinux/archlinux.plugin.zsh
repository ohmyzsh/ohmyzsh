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
alias pacupd='_ $pcman -Syu' 		##syncs, updates & upgrades
alias pacsy='_ $pcman -Sy'               	## Sync & Update  
alias paclu='$pcman -Qu'                    	## List upgradeable
alias pacser='$pcman -Ss' 		##search repos for pkgs
alias pacins='_ $pcman -S' 		##install pkgs
alias pacnd='_ $pcman -Sdd'              	## Install a package but ignore deps
alias pacinf='$pcman -Qi' 		##info of installed pkgs
alias paciss='$pcman -Qs' 		##search installed pkgs
alias pacrm='_ $pcman -Rd' 		##uninstalls pkgs but ignore deps
alias pacrmd='_ $pcman -Rs' 		##remove a package and deps which are not required by any other installed package
alias pacrma='_ $pcman -Rsn' 		##remove a package and deps and .pacsave files
alias pacclc='_  $pcman -Scc' 		## cleans pkgs cache and repos db
alias paclcl='_ $pcman -U' 		##Installs / upgrades local pkg
alias pacui='$pcman -Qm'			## List localy built packages
alias pacfi='$pcman -Qo'			## Which package file belongs to
alias paccl='_ $pcman -Scc'		## Fully clean the package cache
alias pacdl='_ $pcman -Sw'		## Download a package without installing
alias paclo='$pcman -Qdt'			## List package orphans
alias paclog='$pcman -Qc'			## Package changelog


##makepkg alias
alias mksource='makepkg --source -f'  		##creates pkgbuild source tar if existing same ver of source pkg overwritte it
alias mkp='makepkg -sf ' 				## check for needed deps in main repos install them and build pkg if existing same version of pkg overwrittes it
alias mkpi='makepkg -sfi' 			##  same as above but this one also installs it
alias mkall='makepkg -sf && makepkg --source -f ' 	##create pkg and source pkg if existing same version of pkg overwrittes it
alias mkalli='makepkg -sfi && makepkg --source -f ' 	##same as above but this one also installs it


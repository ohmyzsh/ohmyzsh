#
# Just some utilities for use in ecm development.
#

setopt rmstarsilent

HOME="/home/carlos"
ECM_WS="$HOME/totvs/ws"
ECM_JBOSS="$HOME/Public/ecm/JBoss-7.1.1"
ECM_PORT="8080"
VOLDEMORT=$ECM_WS/voldemort
ECM=$ECM_WS/ecm
INSTALLER="n"

# fuckin aliases
alias ecmu=ecmup
alias ecmb=ecmbuild
alias ecmc=ecmclean
alias ecms=ecmstart
alias ecmo=ecmstop
alias ecm=goecm


# update ecm
ecmup() {
	echo "update all the things!"
	cd $VOLDEMORT && svn up
	cd $ECM && svn up
}

# build it!
ecmbuild() {
	vared -p 'build? no problem sir, do you want a installer? (y/N) ' INSTALLER
	cd $VOLDEMORT && mvncie
	cd $VOLDEMORT/social-ecm
	cd $VOLDEMORT/wcm && mvncie
	cd $ECM/ecm/wecmpackage && mvncie
	cd $VOLDEMORT/ecm && mvncie
	if [[ $INSTALLER -eq 'y' ]]; then
		cd $VOLDEMORT/ecm/installer
		mvnci -am -Drun=installer -DLinux64=true -DappServer=jboss
	else
		cd $VOLDEMORT/ecm/build && mvnci
		cd $VOLDEMORT/social-ecm/build && mvnci
	fi
}

# clean jboss trash folders
ecmclean() {
	echo "cleaning jboss shit"
	rm -rf $ECM_JBOSS/standalone/{deployments/*,log,tmp} 2> /dev/null
}

# start jboss server
ecmstart() {
	echo "starting jboss"
	JAVA_OPTS="-Xmx2048m -XX:MaxPermSize=512m -DzkRun -Dbootstrap_conf=true" $ECM_JBOSS/bin/standalone.sh
}

# stop jboss (usually on 8080)
ecmstop() {
	echo "kill jboss (or whatever you are running on 8080"
	fuser -k $ECM_PORT/tcp
}

# do all the things
goecm() {
	echo "serious business here. let's have a coffee.."
	ecmstop
	ecmclean
	ecmup
	ecmbuild && ecmstart
}



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
DRY_CLEAN="n"

# fuckin aliases
alias ecmu=ecmup
alias ecmb=ecmbuild
alias ecmc=ecmclean
alias ecms=ecmstart
alias ecmo=ecmstop
alias ecmi=ecminstall
alias ecmri=ecmruninstall
alias ecm=ecmfull

# update ecm
ecmup() {
	echo "update all the things!"
	cd $VOLDEMORT && svn up
	cd $ECM && svn up
}

# build it!
ecmbuild() {
	echo "build? no problem sir..."
	cd $VOLDEMORT && mvncie && \
	cd $VOLDEMORT/social-ecm && \
	cd $VOLDEMORT/wcm && mvncie && \
	cd $ECM/wecmpackage && mvncie && \
	cd $VOLDEMORT/ecm && mvncie && \
	ecminstall
}

# gen installer or cp wars...
ecminstall() {
	case $@ in
	-*i*)
		INSTALLER=y
		;;
	esac	
  if [[ "$INSTALLER" == "y" ]]; then
  	echo "generating installer..."
    cd $VOLDEMORT/ecm/installer
          mvnci -am -Drun=installer -DLinux64=true -DappServer=jboss
  else
		echo "cpying wars..."
    cd $VOLDEMORT/ecm/build && mvnci && \
		cd $VOLDEMORT/wcm/build && mvnci && \
    cd $VOLDEMORT/social-ecm/build && mvnci
	fi
}

# clean jboss trash folders
ecmclean() {
	echo "cleaning jboss shit"
	case $@ in
	-*d*)
		DRY_CLEAN="y"
		;;
	esac
	if [[ "$DRY_CLEAN" == "y" ]]; then
		rm -rf $ECM_JBOSS/standalone/deployments/*.{failed,deployed,dodeploy,deploying}
	else
		rm -rf $ECM_JBOSS/standalone/deployments/*
	fi
	rm -rf $ECM_JBOSS/standalone/{log,tmp,data}
	rm -rf $ECM_JBOSS/solr/zoo_data
}

# start jboss server
ecmstart() {
	# why shall I start server if i just gen a installer?
	if [[ "$INSTALLER" == "y" ]]; then
		ecmruninstall
	else
		echo "starting jboss"
		cd $ECM_JBOSS/bin
		JAVA_OPTS="-Xmx2048m -XX:MaxPermSize=512m -DzkRun -Dbootstrap_conf=true" ./standalone.sh
	fi
}

ecmruninstall() {
	echo "ok, lets install this crap :)"
	cd $VOLDEMORT/ecm/installer/izpack/target
	if [[ -f ECM-Linux64.zip ]]; then
		mkdir -p /tmp/ecmi
		rm -rf /tmp/ecmi/*
		unzip ECM-Linux64 -d /tmp/ecmi/
		cd /tmp/ecmi/
		chmod a+x ECM-Installer-64.sh
		./ECM-Installer-64.sh
	else
		echo "uhoh, installer doesnt exist ($VOLDEMORT/ecm/installer/izpack/target/ECM-Linux64.zip)"
	fi
}

# stop jboss (usually on 8080)
ecmstop() {
	echo "kill jboss (or whatever you are running on 8080"
	fuser -k $ECM_PORT/tcp
}

# do all the things
ecmfull() {
	echo "serious business here. let's have a coffee.."
	ecmstop
	ecmclean
	ecmup
	ecmbuild && ecmstart
}



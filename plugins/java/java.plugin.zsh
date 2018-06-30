function setjdk() {
	if [ $# -ne 0 ]; then
		removeFromPath '/System/Library/Frameworks/JavaVM.framework/Home/bin'
		if [ -n "${JAVA_HOME+x}" ]; then
			removeFromPath $JAVA_HOME
		fi
		export JAVA_HOME=`/usr/libexec/java_home -v $@`
		export PATH=$JAVA_HOME/bin:$PATH
		echo "JAVA_HOME = $JAVA_HOME"
		java -version
	fi
}
 
function removeFromPath() {
  	export PATH=$(echo $PATH | sed -E -e "s;:$1;;" -e "s;$1:?;;")
}

function listjdk() {
	/usr/libexec/java_home -V
}

alias jdk="listjdk"
alias jdk6="setjdk 1.6"
alias jdk7="setjdk 1.7"
alias jdk8="setjdk 1.8"
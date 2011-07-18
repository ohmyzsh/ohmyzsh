# Set this to 1 if you want to cache the tasks
cacheTaskList=1

# Cache filename
cacheFile='.cake-task-cache'

_cake_does_target_list_need_generating () {

	if [ $cacheTaskList -eq 0 ]; then
		return 1;
	fi

	if [ ! -f $cacheFile ]; then return 0;
	else
		accurate=$(stat -f%m $cacheFile)
		changed=$(stat -f%m Cakefile)
		return $(expr $accurate '>=' $changed)
	fi
}

_cake () {
	if [ -f Cakefile ]; then
		if _cake_does_target_list_need_generating; then
			cake | sed -e "s/cake \([^ ]*\) .*/\1/" | grep -v '^$' > $cacheFile
			compadd `cat $cacheFile`
		else
			compadd `cake | sed -e "s/cake \([^ ]*\) .*/\1/" | grep -v '^$'`
		fi
	fi
}

compdef _cake cake

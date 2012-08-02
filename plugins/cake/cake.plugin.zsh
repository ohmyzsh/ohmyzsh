# Set this to 1 if you want to cache the tasks
cache_task_list=1

# Cache filename
cache_file='.cake_task_cache'

_cake_does_target_list_need_generating () {

	if [ $cache_task_list -eq 0 ]; then
		return 1;
	fi

	if [ ! -f $cache_file ]; then return 0;
	else
		accurate=$(stat -f%m $cache_file)
		changed=$(stat -f%m Cakefile)
		return $(expr $accurate '>=' $changed)
	fi
}

_cake () {
	if [ -f Cakefile ]; then
		if _cake_does_target_list_need_generating; then
			cake | sed -e "s/cake \([^ ]*\) .*/\1/" | grep -v '^$' > $cache_file
			compadd `cat $cache_file`
		else
			compadd `cake | sed -e "s/cake \([^ ]*\) .*/\1/" | grep -v '^$'`
		fi
	fi
}

compdef _cake cake

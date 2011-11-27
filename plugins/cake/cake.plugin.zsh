# Set this to 1 if you want to cache the tasks
_cake_cache_task_list=1

# Cache filename
_cake_task_cache_file='.cake_task_cache'

_cake_get_target_list () {
	cake | grep '^cake ' | sed -e "s/cake \([^ ]*\) .*/\1/" | grep -v '^$'
}

_cake_does_target_list_need_generating () {

	if [ ${_cake_cache_task_list} -eq 0 ]; then
		return 1;
	fi

	if [ ! -f ${_cake_task_cache_file} ]; then return 0;
	else
		accurate=$(stat -f%m $_cake_task_cache_file)
		changed=$(stat -f%m Cakefile)
		return $(expr $accurate '>=' $changed)
	fi
}

_cake () {
	if [ -f Cakefile ]; then
		if _cake_does_target_list_need_generating; then
			_cake_get_target_list > ${_cake_task_cache_file}
			compadd `cat ${_cake_task_cache_file}`
		else
			compadd `_cake_get_target_list`
		fi
	fi
}

compdef _cake cake
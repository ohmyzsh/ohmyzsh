# 
# Functions
#
# timestamp to date Or date to timestamp
#
tt () {
	if [[ $1 =~ "-" ]]
	then
		if [[ $1 =~ " " ]]
		then
			date -j -f "%Y-%m-%d %H:%M:%S" "$1" +%s 2> /dev/null
		else
			date -j -f "%Y-%m-%d %H:%M:%S" "$1 00:00:00" +%s 2> /dev/null
		fi
	elif [[ $1 = "" ]]
	then
		date +%s
	else
		date -r $1 "+%Y-%m-%d %H:%M:%S"
	fi
}

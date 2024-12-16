#!/bin/zsh

OUT=kafka.zsh
COMMANDS=("kafka-acls" "kafka-avro-console-consumer" "kafka-avro-console-producer"
"kafka-broker-api-versions" "kafka-configs" "kafka-console-consumer" 
"kafka-console-producer" "kafka-consumer-groups" "kafka-consumer-perf-test" 
"kafka-delegation-tokens" "kafka-topics" "kafka-producer-perf-test"
"kafka-dump-log" "kafka-log-dirs" "kafka-verifiable-consumer"
"kafka-verifiable-producer" "kafka-streams-application-reset"
"kafka-mirror-maker" "kafka-delete-records" "replicator"
)

function kafka_retrieve_help_command() {
	cmd=$1
	option=""
	desc=""
	help_output=`$cmd 2>&1`
	arg_name="_$(echo $cmd | tr - _)_args"
	start_desc_column=`echo $help_output | grep Description | head -n 1`

	# If a "Description" column is present 
	# look for the offset to truncate the 
	# description of the options.
	#
	# This as some tools usage use a table with 2
	# column with the format
	# Option    Description
	# --blbla   this is 
	#           useful! 
	if [[ ! -z $start_desc_column ]]; then
		searchstring="Description"
	  rest=${start_desc_column##*$searchstring}
		start_desc_column=$(( ${#start_desc_column} - ${#rest} - ${#searchstring} ))
	else
		start_desc_column=1
	fi

	echo "declare -a $arg_name"  >> $OUT
	echo "$arg_name=()" >> $OUT

	# Iterate over each line to check for options 
	# after check the iteration, truncate over the 
	# offset and iterate word by word to build the
	# description 
	IFS=$'\n'
	for line in `echo $help_output`; do
		first_part_line=`echo $line | cut -c -$start_desc_column | tr '\t' ' '`
		second_part_line=`echo $line | cut -c $start_desc_column- | tr '\t' ' '`
		if [[ $first_part_line =~ "^[ \t]*--[a-z][a-z\-\.]+" ]]; then
			if [ ! -z $option ]; then
				echo "$arg_name+=('$option:${desc//\'/''}')" >> $OUT
			fi	

			option=`echo $first_part_line | sed -E 's/^\s*(--[a-z\.\\\-]+).*$/\1/'`
			desc=""
		fi
		IFS=" "
		for word in `echo $second_part_line`; do
			desc="$desc $word"
		done
		IFS=$'\n'
	done

	unset IFS

	if [ ! -z $option ]; then
		echo "$arg_name+=('$option:${desc//\'/''}')" >> $OUT
	fi	
}

function kafka-command() {
	cmd=$1
	echo "compdef \"_kafka-command $cmd\" $cmd" >> $OUT
}

cat << EOF > $OUT
#!/bin/sh
#
# DISCLAIMER: THIS FILE HAS BEEN AUTOMATICALLY GENERATED
# PLEASE DO NOT TOUCH!!!
# IF YOU NEED TO DO ANY MODIFICATION, EDIT GENERATE.ZSH
# FOR MORE INFORMATION https://github.com/Dabz/kafka-zsh-completions
#

function _kafka-command() {
	cmd=\$1
	arg_name="_\$(echo \$cmd | tr - _)_args"
	typeset -a options
	eval _describe 'values' \$arg_name
}

EOF

for cmd in ${COMMANDS[@]}; do
	kafka_retrieve_help_command $cmd
	kafka-command $cmd
done

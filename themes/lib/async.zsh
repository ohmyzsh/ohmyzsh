#!/usr/bin/env zsh

#
# zsh-async
#
# version: v1.8.5
# author: Mathias Fredriksson
# url: https://github.com/mafredri/zsh-async
#

typeset -g ASYNC_VERSION=1.8.5
# Produce debug output from zsh-async when set to 1.
typeset -g ASYNC_DEBUG=${ASYNC_DEBUG:-0}

# Execute commands that can manipulate the environment inside the async worker. Return output via callback.
_async_eval() {
	local ASYNC_JOB_NAME
	# Rename job to _async_eval and redirect all eval output to cat running
	# in _async_job. Here, stdout and stderr are not separated for
	# simplicity, this could be improved in the future.
	{
		eval "$@"
	} &> >(ASYNC_JOB_NAME=[async/eval] _async_job 'command -p cat')
}

# Wrapper for jobs executed by the async worker, gives output in parseable format with execution time
_async_job() {
	# Disable xtrace as it would mangle the output.
	setopt localoptions noxtrace

	# Store start time for job.
	float -F duration=$EPOCHREALTIME

	# Run the command and capture both stdout (`eval`) and stderr (`cat`) in
	# separate subshells. When the command is complete, we grab write lock
	# (mutex token) and output everything except stderr inside the command
	# block, after the command block has completed, the stdin for `cat` is
	# closed, causing stderr to be appended with a $'\0' at the end to mark the
	# end of output from this job.
	local jobname=${ASYNC_JOB_NAME:-$1} out
	out="$(
		local stdout stderr ret tok
		{
			stdout=$(eval "$@")
			ret=$?
			duration=$(( EPOCHREALTIME - duration ))  # Calculate duration.

			print -r -n - $'\0'${(q)jobname} $ret ${(q)stdout} $duration
		} 2> >(stderr=$(command -p cat) && print -r -n - " "${(q)stderr}$'\0')
	)"
	if [[ $out != $'\0'*$'\0' ]]; then
		# Corrupted output (aborted job?), skipping.
		return
	fi

	# Grab mutex lock, stalls until token is available.
	read -r -k 1 -p tok || return 1

	# Return output (<job_name> <return_code> <stdout> <duration> <stderr>).
	print -r -n - "$out"

	# Unlock mutex by inserting a token.
	print -n -p $tok
}

# The background worker manages all tasks and runs them without interfering with other processes
_async_worker() {
	# Reset all options to defaults inside async worker.
	emulate -R zsh

	# Make sure monitor is unset to avoid printing the
	# pids of child processes.
	unsetopt monitor

	# Redirect stderr to `/dev/null` in case unforseen errors produced by the
	# worker. For example: `fork failed: resource temporarily unavailable`.
	# Some older versions of zsh might also print malloc errors (know to happen
	# on at least zsh 5.0.2 and 5.0.8) likely due to kill signals.
	exec 2>/dev/null

	# When a zpty is deleted (using -d) all the zpty instances created before
	# the one being deleted receive a SIGHUP, unless we catch it, the async
	# worker would simply exit (stop working) even though visible in the list
	# of zpty's (zpty -L). This has been fixed around the time of Zsh 5.4
	# (not released).
	if ! is-at-least 5.4.1; then
		TRAPHUP() {
			return 0  # Return 0, indicating signal was handled.
		}
	fi

	local -A storage
	local unique=0
	local notify_parent=0
	local parent_pid=0
	local coproc_pid=0
	local processing=0

	local -a zsh_hooks zsh_hook_functions
	zsh_hooks=(chpwd periodic precmd preexec zshexit zshaddhistory)
	zsh_hook_functions=(${^zsh_hooks}_functions)
	unfunction $zsh_hooks &>/dev/null   # Deactivate all zsh hooks inside the worker.
	unset $zsh_hook_functions           # And hooks with registered functions.
	unset zsh_hooks zsh_hook_functions  # Cleanup.

	close_idle_coproc() {
		local -a pids
		pids=(${${(v)jobstates##*:*:}%\=*})

		# If coproc (cat) is the only child running, we close it to avoid
		# leaving it running indefinitely and cluttering the process tree.
		if  (( ! processing )) && [[ $#pids = 1 ]] && [[ $coproc_pid = $pids[1] ]]; then
			coproc :
			coproc_pid=0
		fi
	}

	child_exit() {
		close_idle_coproc

		# On older version of zsh (pre 5.2) we notify the parent through a
		# SIGWINCH signal because `zpty` did not return a file descriptor (fd)
		# prior to that.
		if (( notify_parent )); then
			# We use SIGWINCH for compatibility with older versions of zsh
			# (pre 5.1.1) where other signals (INFO, ALRM, USR1, etc.) could
			# cause a deadlock in the shell under certain circumstances.
			kill -WINCH $parent_pid
		fi
	}

	# Register a SIGCHLD trap to handle the completion of child processes.
	trap child_exit CHLD

	# Process option parameters passed to worker.
	while getopts "np:uz" opt; do
		case $opt in
			n) notify_parent=1;;
			p) parent_pid=$OPTARG;;
			u) unique=1;;
			z) notify_parent=0;;  # Uses ZLE watcher instead.
		esac
	done

	# Terminate all running jobs, note that this function does not
	# reinstall the child trap.
	terminate_jobs() {
		trap - CHLD   # Ignore child exits during kill.
		coproc :      # Quit coproc.
		coproc_pid=0  # Reset pid.

		if is-at-least 5.4.1; then
			trap '' HUP    # Catch the HUP sent to this process.
			kill -HUP -$$  # Send to entire process group.
			trap - HUP     # Disable HUP trap.
		else
			# We already handle HUP for Zsh < 5.4.1.
			kill -HUP -$$  # Send to entire process group.
		fi
	}

	killjobs() {
		local tok
		local -a pids
		pids=(${${(v)jobstates##*:*:}%\=*})

		# No need to send SIGHUP if no jobs are running.
		(( $#pids == 0 )) && continue
		(( $#pids == 1 )) && [[ $coproc_pid = $pids[1] ]] && continue

		# Grab lock to prevent half-written output in case a child
		# process is in the middle of writing to stdin during kill.
		(( coproc_pid )) && read -r -k 1 -p tok

		terminate_jobs
		trap child_exit CHLD  # Reinstall child trap.
	}

	local request do_eval=0
	local -a cmd
	while :; do
		# Wait for jobs sent by async_job.
		read -r -d $'\0' request || {
			# Unknown error occurred while reading from stdin, the zpty
			# worker is likely in a broken state, so we shut down.
			terminate_jobs

			# Stdin is broken and in case this was an unintended
			# crash, we try to report it as a last hurrah.
			print -r -n $'\0'"'[async]'" $(( 127 + 3 )) "''" 0 "'$0:$LINENO: zpty fd died, exiting'"$'\0'

			# We use `return` to abort here because using `exit` may
			# result in an infinite loop that never exits and, as a
			# result, high CPU utilization.
			return $(( 127 + 1 ))
		}

		# We need to clean the input here because sometimes when a zpty
		# has died and been respawned, messages will be prefixed with a
		# carraige return (\r, or \C-M).
		request=${request#$'\C-M'}

		# Check for non-job commands sent to worker
		case $request in
			_killjobs)    killjobs; continue;;
			_async_eval*) do_eval=1;;
		esac

		# Parse the request using shell parsing (z) to allow commands
		# to be parsed from single strings and multi-args alike.
		cmd=("${(z)request}")

		# Name of the job (first argument).
		local job=$cmd[1]

		# Check if a worker should perform unique jobs, unless
		# this is an eval since they run synchronously.
		if (( !do_eval )) && (( unique )); then
			# Check if a previous job is still running, if yes,
			# skip this job and let the previous one finish.
			for pid in ${${(v)jobstates##*:*:}%\=*}; do
				if [[ ${storage[$job]} == $pid ]]; then
					continue 2
				fi
			done
		fi

		# Guard against closing coproc from trap before command has started.
		processing=1

		# Because we close the coproc after the last job has completed, we must
		# recreate it when there are no other jobs running.
		if (( ! coproc_pid )); then
			# Use coproc as a mutex for synchronized output between children.
			coproc command -p cat
			coproc_pid="$!"
			# Insert token into coproc
			print -n -p "t"
		fi

		if (( do_eval )); then
			shift cmd  # Strip _async_eval from cmd.
			_async_eval $cmd
		else
			# Run job in background, completed jobs are printed to stdout.
			_async_job $cmd &
			# Store pid because zsh job manager is extremely unflexible (show jobname as non-unique '$job')...
			storage[$job]="$!"
		fi

		processing=0  # Disable guard.

		if (( do_eval )); then
			do_eval=0

			# When there are no active jobs we can't rely on the CHLD trap to
			# manage the coproc lifetime.
			close_idle_coproc
		fi
	done
}

#
# Get results from finished jobs and pass it to the to callback function. This is the only way to reliably return the
# job name, return code, output and execution time and with minimal effort.
#
# If the async process buffer becomes corrupt, the callback will be invoked with the first argument being `[async]` (job
# name), non-zero return code and fifth argument describing the error (stderr).
#
# usage:
# 	async_process_results <worker_name> <callback_function>
#
# callback_function is called with the following parameters:
# 	$1 = job name, e.g. the function passed to async_job
# 	$2 = return code
# 	$3 = resulting stdout from execution
# 	$4 = execution time, floating point e.g. 2.05 seconds
# 	$5 = resulting stderr from execution
#	$6 = has next result in buffer (0 = buffer empty, 1 = yes)
#
async_process_results() {
	setopt localoptions unset noshwordsplit noksharrays noposixidentifiers noposixstrings

	local worker=$1
	local callback=$2
	local caller=$3
	local -a items
	local null=$'\0' data
	integer -l len pos num_processed has_next

	typeset -gA ASYNC_PROCESS_BUFFER

	# Read output from zpty and parse it if available.
	while zpty -r -t $worker data 2>/dev/null; do
		ASYNC_PROCESS_BUFFER[$worker]+=$data
		len=${#ASYNC_PROCESS_BUFFER[$worker]}
		pos=${ASYNC_PROCESS_BUFFER[$worker][(i)$null]}  # Get index of NULL-character (delimiter).

		# Keep going until we find a NULL-character.
		if (( ! len )) || (( pos > len )); then
			continue
		fi

		while (( pos <= len )); do
			# Take the content from the beginning, until the NULL-character and
			# perform shell parsing (z) and unquoting (Q) as an array (@).
			items=("${(@Q)${(z)ASYNC_PROCESS_BUFFER[$worker][1,$pos-1]}}")

			# Remove the extracted items from the buffer.
			ASYNC_PROCESS_BUFFER[$worker]=${ASYNC_PROCESS_BUFFER[$worker][$pos+1,$len]}

			len=${#ASYNC_PROCESS_BUFFER[$worker]}
			if (( len > 1 )); then
				pos=${ASYNC_PROCESS_BUFFER[$worker][(i)$null]}  # Get index of NULL-character (delimiter).
			fi

			has_next=$(( len != 0 ))
			if (( $#items == 5 )); then
				items+=($has_next)
				$callback "${(@)items}"  # Send all parsed items to the callback.
				(( num_processed++ ))
			elif [[ -z $items ]]; then
				# Empty items occur between results due to double-null ($'\0\0')
				# caused by commands being both pre and suffixed with null.
			else
				# In case of corrupt data, invoke callback with *async* as job
				# name, non-zero exit status and an error message on stderr.
				$callback "[async]" 1 "" 0 "$0:$LINENO: error: bad format, got ${#items} items (${(q)items})" $has_next
			fi
		done
	done

	(( num_processed )) && return 0

	# Avoid printing exit value when `setopt printexitvalue` is active.`
	[[ $caller = trap || $caller = watcher ]] && return 0

	# No results were processed
	return 1
}

# Watch worker for output
_async_zle_watcher() {
	setopt localoptions noshwordsplit
	typeset -gA ASYNC_PTYS ASYNC_CALLBACKS
	local worker=$ASYNC_PTYS[$1]
	local callback=$ASYNC_CALLBACKS[$worker]

	if [[ -n $2 ]]; then
		# from man zshzle(1):
		# `hup' for a disconnect, `nval' for a closed or otherwise
		# invalid descriptor, or `err' for any other condition.
		# Systems that support only the `select' system call always use
		# `err'.

		# this has the side effect to unregister the broken file descriptor
		async_stop_worker $worker

		if [[ -n $callback ]]; then
			$callback '[async]' 2 "" 0 "$0:$LINENO: error: fd for $worker failed: zle -F $1 returned error $2" 0
		fi
		return
	fi;

	if [[ -n $callback ]]; then
		async_process_results $worker $callback watcher
	fi
}

_async_send_job() {
	setopt localoptions noshwordsplit noksharrays noposixidentifiers noposixstrings

	local caller=$1
	local worker=$2
	shift 2

	zpty -t $worker &>/dev/null || {
		typeset -gA ASYNC_CALLBACKS
		local callback=$ASYNC_CALLBACKS[$worker]

		if [[ -n $callback ]]; then
			$callback '[async]' 3 "" 0 "$0:$LINENO: error: no such worker: $worker" 0
		else
			print -u2 "$caller: no such async worker: $worker"
		fi
		return 1
	}

	zpty -w $worker "$@"$'\0'
}

#
# Start a new asynchronous job on specified worker, assumes the worker is running.
#
# Note if you are using a function for the job, it must have been defined before the worker was
# started or you will get a `command not found` error.
#
# usage:
# 	async_job <worker_name> <my_function> [<function_params>]
#
async_job() {
	setopt localoptions noshwordsplit noksharrays noposixidentifiers noposixstrings

	local worker=$1; shift

	local -a cmd
	cmd=("$@")
	if (( $#cmd > 1 )); then
		cmd=(${(q)cmd})  # Quote special characters in multi argument commands.
	fi

	_async_send_job $0 $worker "$cmd"
}

#
# Evaluate a command (like async_job) inside the async worker, then worker environment can be manipulated. For example,
# issuing a cd command will change the PWD of the worker which will then be inherited by all future async jobs.
#
# Output will be returned via callback, job name will be [async/eval].
#
# usage:
# 	async_worker_eval <worker_name> <my_function> [<function_params>]
#
async_worker_eval() {
	setopt localoptions noshwordsplit noksharrays noposixidentifiers noposixstrings

	local worker=$1; shift

	local -a cmd
	cmd=("$@")
	if (( $#cmd > 1 )); then
		cmd=(${(q)cmd})  # Quote special characters in multi argument commands.
	fi

	# Quote the cmd in case RC_EXPAND_PARAM is set.
	_async_send_job $0 $worker "_async_eval $cmd"
}

# This function traps notification signals and calls all registered callbacks
_async_notify_trap() {
	setopt localoptions noshwordsplit

	local k
	for k in ${(k)ASYNC_CALLBACKS}; do
		async_process_results $k ${ASYNC_CALLBACKS[$k]} trap
	done
}

#
# Register a callback for completed jobs. As soon as a job is finnished, async_process_results will be called with the
# specified callback function. This requires that a worker is initialized with the -n (notify) option.
#
# usage:
# 	async_register_callback <worker_name> <callback_function>
#
async_register_callback() {
	setopt localoptions noshwordsplit nolocaltraps

	typeset -gA ASYNC_PTYS ASYNC_CALLBACKS
	local worker=$1; shift

	ASYNC_CALLBACKS[$worker]="$*"

	# Enable trap when the ZLE watcher is unavailable, allows
	# workers to notify (via -n) when a job is done.
	if [[ ! -o interactive ]] || [[ ! -o zle ]]; then
		trap '_async_notify_trap' WINCH
	elif [[ -o interactive ]] && [[ -o zle ]]; then
		local fd w
		for fd w in ${(@kv)ASYNC_PTYS}; do
			if [[ $w == $worker ]]; then
				zle -F $fd _async_zle_watcher  # Register the ZLE handler.
				break
			fi
		done
	fi
}

#
# Unregister the callback for a specific worker.
#
# usage:
# 	async_unregister_callback <worker_name>
#
async_unregister_callback() {
	typeset -gA ASYNC_CALLBACKS

	unset "ASYNC_CALLBACKS[$1]"
}

#
# Flush all current jobs running on a worker. This will terminate any and all running processes under the worker, use
# with caution.
#
# usage:
# 	async_flush_jobs <worker_name>
#
async_flush_jobs() {
	setopt localoptions noshwordsplit

	local worker=$1; shift

	# Check if the worker exists
	zpty -t $worker &>/dev/null || return 1

	# Send kill command to worker
	async_job $worker "_killjobs"

	# Clear the zpty buffer.
	local junk
	if zpty -r -t $worker junk '*'; then
		(( ASYNC_DEBUG )) && print -n "async_flush_jobs $worker: ${(V)junk}"
		while zpty -r -t $worker junk '*'; do
			(( ASYNC_DEBUG )) && print -n "${(V)junk}"
		done
		(( ASYNC_DEBUG )) && print
	fi

	# Finally, clear the process buffer in case of partially parsed responses.
	typeset -gA ASYNC_PROCESS_BUFFER
	unset "ASYNC_PROCESS_BUFFER[$worker]"
}

#
# Start a new async worker with optional parameters, a worker can be told to only run unique tasks and to notify a
# process when tasks are complete.
#
# usage:
# 	async_start_worker <worker_name> [-u] [-n] [-p <pid>]
#
# opts:
# 	-u unique (only unique job names can run)
# 	-n notify through SIGWINCH signal
# 	-p pid to notify (defaults to current pid)
#
async_start_worker() {
	setopt localoptions noshwordsplit noclobber

	local worker=$1; shift
	local -a args
	args=("$@")
	zpty -t $worker &>/dev/null && return

	typeset -gA ASYNC_PTYS
	typeset -h REPLY
	typeset has_xtrace=0

	if [[ -o interactive ]] && [[ -o zle ]]; then
		# Inform the worker to ignore the notify flag and that we're
		# using a ZLE watcher instead.
		args+=(-z)

		if (( ! ASYNC_ZPTY_RETURNS_FD )); then
			# When zpty doesn't return a file descriptor (on older versions of zsh)
			# we try to guess it anyway.
			integer -l zptyfd
			exec {zptyfd}>&1  # Open a new file descriptor (above 10).
			exec {zptyfd}>&-  # Close it so it's free to be used by zpty.
		fi
	fi

	# Workaround for stderr in the main shell sometimes (incorrectly) being
	# reassigned to /dev/null by the reassignment done inside the async
	# worker.
	# See https://github.com/mafredri/zsh-async/issues/35.
	integer errfd=-1

	# Redirect of errfd is broken on zsh 5.0.2.
	if is-at-least 5.0.8; then
		exec {errfd}>&2
	fi

	# Make sure async worker is started without xtrace
	# (the trace output interferes with the worker).
	[[ -o xtrace ]] && {
		has_xtrace=1
		unsetopt xtrace
	}

	if (( errfd != -1 )); then
		zpty -b $worker _async_worker -p $$ $args 2>&$errfd
	else
		zpty -b $worker _async_worker -p $$ $args
	fi
	local ret=$?

	# Re-enable it if it was enabled, for debugging.
	(( has_xtrace )) && setopt xtrace
	(( errfd != -1 )) && exec {errfd}>& -

	if (( ret )); then
		async_stop_worker $worker
		return 1
	fi

	if ! is-at-least 5.0.8; then
		# For ZSH versions older than 5.0.8 we delay a bit to give
		# time for the worker to start before issuing commands,
		# otherwise it will not be ready to receive them.
		sleep 0.001
	fi

	if [[ -o interactive ]] && [[ -o zle ]]; then
		if (( ! ASYNC_ZPTY_RETURNS_FD )); then
			REPLY=$zptyfd  # Use the guessed value for the file desciptor.
		fi

		ASYNC_PTYS[$REPLY]=$worker  # Map the file desciptor to the worker.
	fi
}

#
# Stop one or multiple workers that are running, all unfetched and incomplete work will be lost.
#
# usage:
# 	async_stop_worker <worker_name_1> [<worker_name_2>]
#
async_stop_worker() {
	setopt localoptions noshwordsplit

	local ret=0 worker k v
	for worker in $@; do
		# Find and unregister the zle handler for the worker
		for k v in ${(@kv)ASYNC_PTYS}; do
			if [[ $v == $worker ]]; then
				zle -F $k
				unset "ASYNC_PTYS[$k]"
			fi
		done
		async_unregister_callback $worker
		zpty -d $worker 2>/dev/null || ret=$?

		# Clear any partial buffers.
		typeset -gA ASYNC_PROCESS_BUFFER
		unset "ASYNC_PROCESS_BUFFER[$worker]"
	done

	return $ret
}

#
# Initialize the required modules for zsh-async. To be called before using the zsh-async library.
#
# usage:
# 	async_init
#
async_init() {
	(( ASYNC_INIT_DONE )) && return
	typeset -g ASYNC_INIT_DONE=1

	zmodload zsh/zpty
	zmodload zsh/datetime

	# Load is-at-least for reliable version check.
	autoload -Uz is-at-least

	# Check if zsh/zpty returns a file descriptor or not,
	# shell must also be interactive with zle enabled.
	typeset -g ASYNC_ZPTY_RETURNS_FD=0
	[[ -o interactive ]] && [[ -o zle ]] && {
		typeset -h REPLY
		zpty _async_test :
		(( REPLY )) && ASYNC_ZPTY_RETURNS_FD=1
		zpty -d _async_test
	}
}

async() {
	async_init
}

async "$@"

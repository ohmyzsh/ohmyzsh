# https://github.com/NormanTUD/ohmyzsh


# Aliases ###################################################################

if command -v squeue; then
	alias sq="squeue -u $USER"
fi

# Functions #################################################################

function treesizethis {
	du -k --max-depth=1 | sort -nr | awk '
	     BEGIN {
		split("KB,MB,GB,TB", Units, ",");
	     }
	     {
		u = 1;
		while ($1 >= 1024) {
		   $1 = $1 / 1024;
		   u += 1
		}
		$1 = sprintf("%.1f %s", $1, Units[u]);
		print $0;
	     }
	'
}

if command -v scontrol; then
	function slurmlogpath {
		if command -v scontrol &> /dev/null; then
			if command -v grep &> /dev/null; then
				if command -v sed &> /dev/null; then
					debug_code "scontrol show job $1 | grep StdOut | sed -e 's/^\\s*StdOut=//'"
					scontrol show job $1 | grep StdOut | sed -e 's/^\s*StdOut=//'
				else
					red_text "sed not found"
				fi
			else
				red_text "grep not found"
			fi
		else
			red_text "scontrol not found"
		fi
	}
fi

function pretty_csv {                                                                           
	perl -pe 's/((?<=,)|(?<=^)),/ ,/g;' "$@" | column -t -s, | less  -F -S -X -K
}

if command -v squeue; then
	if command -v whypending; then
		function showmyjobsstatus {
			if [ $# -eq 0 ]; then
				for i in $(squeue -u $USER | grep -v JOBID | sed -e 's/^\s*//' | sed -e 's/\s.*//'); do
					echo ">>>>>> $i"; whypending $i | egrep "(Position in)|(Estimated)";
				done
			else
				echo ">>>>>> $i"; whypending $1 | egrep "(Position in)|(Estimated)";
			fi
		}
	fi

	if command -v slurmlogpath; then
		function ftails {
		    if [ $# -eq 0 ]; then
			SLURMID=$(squeue -u $USER | cut -d' ' -f11- | sed -e 's/\s.*//' | egrep -v "^\s*$" | sort -nr | head -n1)
			if [ ! -z $SLURMID ]; then
			    tail -f $(slurmlogpath $SLURMID)
			fi
		    else
			tail -f $(slurmlogpath $1)
		    fi
		}
	fi
fi

function countdown() {
	secs=$1
	shift
	msg=$@
	while [ $secs -gt 0 ]
	do
		printf "\r\033[KWaiting %.d seconds $msg" $((secs--))
		sleep 1
	done
	echo
}


function mongodbtojson {
	ip=$1
	port=$2
	dbname=$3
	mongo --quiet mongodb://$ip:$port/$dbname --eval "db.jobs.find().pretty().toArray();"
}

function rtest {
        set -x
        RANDOMNUMBER=$(shuf -i 1-100000 -n 1)
        while [[ -e "$HOME/test/randomtest_$RANDOMNUMBER" ]]; do
                RANDOMNUMBER=$(shuf -i 1-100000 -n 1)
        done
        mkdir -p "$HOME/test/randomtest_$RANDOMNUMBER"
        cd "$HOME/test/randomtest_$RANDOMNUMBER"
        set +x
}

mcd () {
	mkdir -p -p $1
	cd $1
}


echoerr() {
	echo "$@" 1>&2
}

function red_text {
	echoerr -e "\e[31m$1\e[0m"
}

function green_text {
	echoerr -e "\e[92m$1\e[0m"
}

function debug_code {
	echoerr -e "\e[93m$1\e[0m"
}

function warningcolors {
	echo '
window=,red
border=white,red
textbox=white,red
button=black,white
'
}


if command -v scontrol; then
	if command -v ws_list; then
		function get_filesystem_workspace {
			ws=$1
			ws_list | perl -e 'my %struct = (); my $current_id = q##; while (<>) { if(m#^id: (.*)$#) { $current_id = $1 } elsif (m#filesystem\s*name\s*:\s*(.*)?$#) { $struct{$current_id} = $1 } }; foreach my $key (keys %struct) { print "$key--->$struct{$key}\n" }' | grep "^$ws--->" | sed -e "s/^$ws--->//"
		}
	fi


	function get_job_name {
		if command -v screen &> /dev/null; then
			scontrol show job $1 | grep JobName | sed -e 's/.*JobName=//'
		else
			red_text "Program scontrol does not exist, cannot run it"
		fi
	}

	function run_commands_in_parallel {
		args=$#
		if command -v screen &> /dev/null; then
			if command -v uuidgen &> /dev/null; then
				THISSCREENCONFIGFILE=/tmp/$(uuidgen).conf
				for (( i=1; i<=$args; i+=1 )); do
					thiscommand=${@:$i:1}
					echo "screen $thiscommand" >> $THISSCREENCONFIGFILE
					echo "title '$thiscommand'" >> $THISSCREENCONFIGFILE
					if [[ $i -ne $args ]]; then
						echo "split -v" >> $THISSCREENCONFIGFILE
						echo "focus right" >> $THISSCREENCONFIGFILE
					fi
				done
				if [[ -e $THISSCREENCONFIGFILE ]]; then
					echo $THISSCREENCONFIGFILE
					cat $THISSCREENCONFIGFILE
					screen -c $THISSCREENCONFIGFILE
					rm $THISSCREENCONFIGFILE
				else
					echo "$THISSCREENCONFIGFILE not found"
				fi
			else
				echo "Command uuidgen not found, cannot execute run_commands_in_parallel"
			fi
		else
			echo "Command screen not found, cannot execute run_commands_in_parallel"
		fi
	}

	function multiple_slurm_tails {
		if command -v screen &> /dev/null; then
			if command -v uuidgen &> /dev/null; then
				THISSCREENCONFIGFILE=/tmp/$(uuidgen).conf
				for slurmid in "$@"; do
					logfile=$(slurmlogpath $slurmid)
					if [[ -e $logfile ]]; then
						echo "screen tail -f $logfile" >> $THISSCREENCONFIGFILE
						echo "title '$(get_job_name $slurmid) ($slurmid)'" >> $THISSCREENCONFIGFILE
						if [[ ${*: -1:1} -ne $slurmid ]]; then
							echo "split -v" >> $THISSCREENCONFIGFILE
							echo "focus right" >> $THISSCREENCONFIGFILE
						fi
					fi
				done
				if [[ -e $THISSCREENCONFIGFILE ]]; then
					debug_code "Screen file:"
					cat $THISSCREENCONFIGFILE
					debug_code "Screen file end"
					screen -c $THISSCREENCONFIGFILE
					rm $THISSCREENCONFIGFILE
				else
					red_text "$THISSCREENCONFIGFILE not found"
				fi
			else
				red_text "Command uuidgen not found, cannot execute multiple tails"
			fi
		else
			red_text "Command screen not found, cannot execute multiple tails"
		fi
	}



	function kill_multiple_jobs_usrsignal {
		FAILED=0
		if ! command -v squeue &> /dev/null; then
			red_text "squeue not found. Cannot execute slurminator without it"
			FAILED=1
		fi

		if ! command -v scancel &> /dev/null; then
			red_text "scancel not found. Cannot execute slurminator without it"
			FAILED=1
		fi

		if ! command -v whiptail &> /dev/null; then
			red_text "whiptail not found. Cannot execute slurminator without it"
			FAILED=1
		fi

		if [[ $FAILED == 0 ]]; then
			TJOBS=$(get_squeue_from_format_string "'%A' '%j (%t, %M)' OFF")
			chosenjobs=$(eval "whiptail --title 'Which jobs to kill with USR1?' --checklist 'Which jobs to choose USR1?' $WIDTHHEIGHT $TJOBS" 3>&1 1>&2 2>&3)
			if [[ -z $chosenjobs ]]; then
				green_text "No jobs chosen to kill"
			else
				NEWT_COLORS=$(warningcolors)
				if (whiptail --title "Really kill multiple jobs ($chosenjobs)?" --yesno --defaultno --fullbuttons "Are you sure you want to kill multiple jobs ($chosenjobs)?" 8 78); then
					debug_code "scancel --signal=USR1 --batch $chosenjobs"
					eval "scancel --signal=USR1 --batch $chosenjobs"
					NEWT_COLORS=''
					return 0
				fi
				NEWT_COLORS=''
			fi
		fi
		return 1
	}

	function kill_multiple_jobs {
		FAILED=0
		if ! command -v squeue &> /dev/null; then
			red_text "squeue not found. Cannot execute slurminator without it"
			FAILED=1
		fi

		if ! command -v scancel &> /dev/null; then
			red_text "scancel not found. Cannot execute slurminator without it"
			FAILED=1
		fi

		if ! command -v whiptail &> /dev/null; then
			red_text "whiptail not found. Cannot execute slurminator without it"
			FAILED=1
		fi

		if [[ $FAILED == 0 ]]; then
			TJOBS=$(get_squeue_from_format_string "'%A' '%j (%t, %M)' OFF")
			chosenjobs=$(eval "whiptail --title 'Which jobs to kill?' --checklist 'Which jobs to choose?' $WIDTHHEIGHT $TJOBS" 3>&1 1>&2 2>&3)
			if [[ -z $chosenjobs ]]; then
				green_text "No jobs chosen to kill"
			else
				NEWT_COLORS=$(warningcolors)
				if (whiptail --title "Really kill multiple jobs ($chosenjobs)?" --yesno --defaultno --fullbuttons "Are you sure you want to kill multiple jobs ($chosenjobs)?" 8 78); then
					debug_code "scancel $chosenjobs"
					eval "scancel $chosenjobs"
					NEWT_COLORS=''
					return 0
				fi
				NEWT_COLORS=''
			fi
		fi
		return 1
	}

	function tail_multiple_jobs {
		FAILED=0
		AUTOON=OFF

		if [[ $1 == 'ON' ]]; then
			AUTOON=ON
		fi

		if ! command -v squeue &> /dev/null; then
			red_text "squeue not found. Cannot execute slurminator without it"
			FAILED=1
		fi

		if ! command -v tail &> /dev/null; then
			red_text "tail not found. Cannot execute slurminator without it"
			FAILED=1
		fi

		if ! command -v whiptail &> /dev/null; then
			red_text "whiptail not found. Cannot execute slurminator without it"
			FAILED=1
		fi

		if ! command -v screen &> /dev/null; then
			red_text "screen not found. Cannot execute slurminator without it"
			FAILED=1
		fi

		if [[ $FAILED == 0 ]]; then
			TJOBS=$(get_squeue_from_format_string "'%A' '%j (%t, %M)' $AUTOON")
			chosenjobs=$(eval "whiptail --title 'Which jobs to tail?' --checklist 'Which jobs to choose for tail?' $WIDTHHEIGHT $TJOBS" 3>&1 1>&2 2>&3)
			if [[ -z $chosenjobs ]]; then
				green_text "No jobs chosen to tail"
			else
				#whiptail --title "Tail for multiple jobs with screen" --msgbox "To exit, press <CTRL> <a>, then <\\>" 8 78 3>&1 1>&2 2>&3
				eval "multiple_slurm_tails $chosenjobs"
			fi
		fi
	}

	function single_job_tasks {
		chosenjob=$1
		gobacktoslurminator="$2"

		if ! command -v scontrol &> /dev/null; then
			red_text "scontrol not found. Cannot execute slurminator without it"
			FAILED=1
		fi

		if ! command -v tail &> /dev/null; then
			red_text "tail not found. Cannot execute slurminator without it"
			FAILED=1
		fi

		WHYPENDINGSTRING=""
		if command -v whypending &> /dev/null; then
			WHYPENDINGSTRING="'w)' 'whypending'"
		fi

		SCANCELSTRING=""
		if command -v scancel &> /dev/null; then
			SCANCELSTRING="'k)' 'scancel' 'c)' 'scancel with signal USR1'"
		fi

		TAILSTRING=""
		if command -v tail &> /dev/null; then
			TAILSTRING="'t)' 'tail -f'"
		else
			red_text "Tail does not seem to be installed, not showing 'tail -f' option"
		fi

		jobname=$(get_job_name $chosenjob)
		whiptailoptions="'s)' 'Show log path' $WHYPENDINGSTRING $TAILSTRING $SCANCELSTRING 'm)' 'go to main menu' 'q)' 'quit slurminator'"
		whattodo=$(eval "whiptail --title 'Slurminator >$jobname< ($chosenjob)' --menu 'What to do with job >$jobname< ($chosenjob)' $WIDTHHEIGHT $whiptailoptions" 3>&2 2>&1 1>&3)
		case $whattodo in
			"s)")
				debug_code "slurmlogpath $chosenjob"
				slurmlogpath $chosenjob
				;;
			"t)")
				chosenjobpath=$(slurmlogpath $chosenjob)
				debug_code "tail -f $chosenjobpath"
				tail -f $chosenjobpath
				;;
			"w)")
				debug_code "whypending $chosenjob"
				whypending $chosenjob
				;;
			"k)")
				NEWT_COLORS=$(warningcolors)
				if (whiptail --title "Really kill >$jobname< ($chosenjob)?" --yesno --defaultno --fullbuttons "Are you sure you want to kill >$jobname< ($chosenjob)?" 8 78); then
					debug_code "scancel $chosenjob"
					scancel $chosenjob && green_text "$jobname ($chosenjob) killed" || red_text "Error killing $jobname ($chosenjob)"
				fi
				NEWT_COLORS=""
				;;
			"m)")
				slurminator
				;;
			"c)")
				NEWT_COLORS=$(warningcolors)
				if (whiptail --title "Really kill with USR1 >$jobname< ($chosenjob)?" --yesno --defaultno --fullbuttons "Are you sure you want to kill >$jobname< ($chosenjob) with USR1?" 8 78); then
					debug_code "scancel --signal=USR1 --batch $chosenjob"
					scancel --signal=USR1 --batch $chosenjob && green_text "$chosenjob killed" || red_text "Error killing $chosenjob"
				fi
				NEWT_COLORS=""
				;;
			"q)")
				green_text "Ok, exiting"
				;;
		esac

		if [[ $gobacktoslurminator -eq '1' ]]; then
			slurminator
		fi
	}

	function get_squeue_from_format_string {
		if ! command -v squeue &> /dev/null; then
			red_text "squeue not found. Cannot execute slurminator without it"
			FAILED=1
		fi

		if [[ $FAILED == 0 ]]; then
			for line in $(squeue -u $USER --format $1 | sed '1d'); do 
				echo "$line" | tr '\n' ' '; 
			done
		fi
	}

	function show_accounting_data {
		FAILED=0
		if ! command -v sreport &> /dev/null; then
			red_text "sreport not found. Cannot execute slurminator without it"
			FAILED=1
		fi

		if ! command -v whiptail &> /dev/null; then
			red_text "whiptail not found. Cannot execute slurminator without it"
			FAILED=1
		fi

		if [[ $FAILED == 0 ]]; then
			whiptailoptions="'t)' 'Show accounting data as tree' 'o)' 'Show top user accounting' 'm)' 'Show top user accounting for this month'"
			WIDTHHEIGHT="$LINES $COLUMNS $(( $LINES - 18 ))"
			whattodo=$(eval "whiptail --title 'Accounting data' --menu 'Show accounting information' $WIDTHHEIGHT $whiptailoptions" 3>&2 2>&1 1>&3)
			NUMBEROFLINES=$(( $LINES - 5 ))
			case $whattodo in
				"t)")
					debug_code "sreport cluster AccountUtilizationByUser tree"
					sreport cluster AccountUtilizationByUser tree
					;;
				"o)")
					debug_code "sreport user top start=0101 end=0201 TopCount=$NUMBEROFLINES -t hourper --tres=cpu,gpu"
					sreport user top start=0101 end=0201 TopCount=$NUMBEROFLINES -t hourper --tres=cpu,gpu
					;;
				"m)")
					debug_code "sreport user top start=0101 end=0201 TopCount=$NUMBEROFLINES -t hourper --tres=cpu,gpu Start=`date -d "last month" +%D` End=`date -d "this month" +%D`"
					sreport user top start=0101 end=0201 TopCount=$NUMBEROFLINES -t hourper --tres=cpu,gpu Start=`date -d "last month" +%D` End=`date -d "this month" +%D`
					;;
			esac
		else
			red_text "Missing requirements, cannot run show_accounting_data"
		fi
	}

	function show_workspace_options_single_job {
		ws=$1
		gobacktomain="$2"

		EXTENDSTRING=""
		if command -v ws_extend &> /dev/null; then
			EXTENDSTRING="'e)' 'extend workspace 100 days' 'j)' 'extend workspace custom number of days'"
		fi

		RELEASESTRING=""
		if command -v ws_release &> /dev/null; then
			RELEASESTRING="'r)' 'release workspace'"
		fi

		whiptailoptions="$EXTENDSTRING $RELEASESTRING 'm)' 'go to main menu' 'q)' 'quit slurminator'"
		whattodo=$(eval "whiptail --title 'Slurminator workspace $ws' --menu 'What to do with workspace $ws' $WIDTHHEIGHT $whiptailoptions" 3>&2 2>&1 1>&3)
		case $whattodo in
			"e)")
				filesystem=$(get_filesystem_workspace $ws)
				debug_code "ws_extend -F $filesystem $ws 100"
				ws_extend -F $filesystem $ws 100
				;;
			"j)")
				filesystem=$(get_filesystem_workspace $ws)
				days=$(whiptail --inputbox "How many days to extend workspace?" 8 78 100 --title "Please enter a number of days" 3>&1 1>&2 2>&3)
				re='^[0-9]+$'
				if ! [[ $days =~ $re ]] ; then
					red_text "error: Not a number"
				else
					debug_code "ws_extend -F $filesystem $ws $days"
					ws_extend -F $filesystem $ws $days
				fi
				;;
			"r)")
				NEWT_COLORS=$(warningcolors)
				if (whiptail --title "Are you sure you want to release $ws?" --yesno --defaultno --fullbuttons "Are you sure you want to release workspace $ws?" 8 78); then
					debug_code "ws_release $ws"
					ws_release $ws
				fi
				NEWT_COLORS=""
				;;
			"m)")
				show_workspace_options
				;;
			"q)")
				green_text "Ok, exiting"
				gobacktomain=0
				;;
		esac

		if [[ $gobacktomain -eq '1' ]]; then
			show_workspace_options
		fi
	}

	function show_workspace_options {
		FAILED=0
		if ! command -v whiptail &> /dev/null; then
			red_text "whiptail not found. Cannot execute slurminator without it"
			FAILED=1
		fi

		if ! command -v ws_list &> /dev/null; then
			red_text "ws_list not found. Cannot execute slurminator without it"
			FAILED=1
		fi

		if ! command -v ws_allocate &> /dev/null; then
			red_text "ws_allocate not found. Cannot execute slurminator without it"
			FAILED=1
		fi

		if ! command -v ws_extend &> /dev/null; then
			red_text "ws_extend not found. Cannot execute slurminator without it"
			FAILED=1
		fi

		if ! command -v ws_release &> /dev/null; then
			red_text "ws_release not found. Cannot execute slurminator without it"
			FAILED=1
		fi
		if [[ $FAILED == 0 ]]; then
			existingworkspaces=$(ws_list | perl -e 'my %struct = (); my $current_id = q##; while (<>) { if(m#^id: (.*)$#) { $current_id = $1 } elsif (m#remaining time\s*:\s*(.*)?$#) { $struct{$current_id} = $1 } }; foreach my $key (keys %struct) { print qq#"$key" "$struct{$key}" # }')
			chosenjob=$(eval "whiptail --title 'Which workspaces to do something with?' --menu 'Which workspace?' $WIDTHHEIGHT $existingworkspaces 'r)' 'reload' 'm)' 'go to main menu' 'q)' 'quit slurminator'" 3>&1 1>&2 2>&3)
			if [[ $chosenjob == 'm)' ]]; then
				slurminator
			elif [[ $chosenjob == 'q)' ]]; then
				green_text "Ok, exiting"
			elif [[ $chosenjob == 'r)' ]]; then
				show_workspace_options
			else
				show_workspace_options_single_job $chosenjob 1
			fi
		else
			red_text "Cannot run show_workspace_options because of missing programs"
		fi
	}

	function slurminator {
		FAILED=0

		NEWT_COLORS=""

		if ! command -v squeue &> /dev/null; then
			red_text "squeue not found. Cannot execute slurminator without it"
			FAILED=1
		fi

		if ! command -v whiptail &> /dev/null; then
			red_text "whiptail not found. Cannot execute slurminator without it"
			FAILED=1
		fi

		if ! command -v scontrol &> /dev/null; then
			red_text "scontrol not found. Cannot execute slurminator without it"
			FAILED=1
		fi

		SCANCELSTRING=""
		if command -v scancel &> /dev/null; then
			SCANCELSTRING="'k)' 'kill multiple jobs' 'n)' 'kill multiple jobs with USR1'"
		fi

		ACCOUNTINGSTRING=""
		if command -v sreport &> /dev/null; then
			ACCOUNTINGSTRING="'a)' 'Show accounting data'"
		fi

		TAILSTRING=""
		if command -v tail &> /dev/null; then
			if command -v screen &> /dev/null; then
				TAILSTRING="'t)' 'tail multiple jobs' 'e)' 'tail multiple jobs (all enabled by default)'"
			else
				red_text "Screen could not be found, not showing 'tail multiple jobs' option"
			fi
		else
			red_text "Tail does not seem to be installed, not showing 'tail multiple jobs'"
		fi

		WORKSPACESSTRING=""
		if command -v ws_list &> /dev/null; then
			WORKSPACESSTRING="'w)' 'show options for workspaces'"
		else
			red_text "ws_list does not seem to be installed"
		fi

		FULLOPTIONSTRING="$JOBS $SCANCELSTRING $TAILSTRING $ACCOUNTINGSTRING $WORKSPACESSTRING"

		if [[ $FAILED == 0 ]]; then
			WIDTHHEIGHT="$LINES $COLUMNS $(( $LINES - 8 ))"
			JOBS=$(get_squeue_from_format_string "'%A' '%j (%t, %M)'")
			chosenjob=$(
				eval "whiptail --title 'Slurminator' --menu 'Welcome to Slurminator' $WIDTHHEIGHT $FULLOPTIONSTRING 'r)' 'reload slurminator' 'q)' 'quit slurminator'" 3>&2 2>&1 1>&3
			)

			if [[ $chosenjob == 'q)' ]]; then
				green_text "Ok, exiting"
			elif [[ $chosenjob == 'r)' ]]; then
				slurminator
			elif [[ $chosenjob == 't)' ]]; then
				tail_multiple_jobs
			elif [[ $chosenjob == 'e)' ]]; then
				tail_multiple_jobs ON
			elif [[ $chosenjob == 'n)' ]]; then
				kill_multiple_jobs_usrsignal || slurminator
			elif [[ $chosenjob == 'k)' ]]; then
				kill_multiple_jobs || slurminator
			elif [[ $chosenjob == 'a)' ]]; then
				show_accounting_data
			elif [[ $chosenjob == 'w)' ]]; then
				show_workspace_options
			else
				single_job_tasks $chosenjob 1
			fi
		else
			red_text  "Missing requirements, cannot run Slurminator"
		fi
	}
fi

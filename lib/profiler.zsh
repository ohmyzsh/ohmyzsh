
zmodload zsh/datetime



# Store the 0-based level of the measurements by the key (name)
typeset -A _level_by_keys
# Store the measurements indexed by the key (name)
typeset -A _time_by_keys
# Store the order the measurements were taken
_ordered_keys=()
# Percentage thresholds (in percent) used for report highlighting
_percentage_warning=5
_percentage_error=10
# Duration thresholds (in milliseconds) used for report highlighting
_duration_warning=10
_duration_error=100



# Return a timestamp in milliseconds
function _time_in_ms() {
    printf %.0f $(( EPOCHREALTIME * 1000 ))
}

# Start recording the elapsed time
# @param level the level of the measurement (must be greater or equal to 0)
# @param key the name that defines the measurement (must be unique)
function start_profiling() {
    [[ $ENABLE_PROFILING = "true" ]] || return

    local level="$1"
    local key="$2"
    local time_ms=$(_time_in_ms)
    _level_by_keys[$key]=$level
    _time_by_keys[$key]=$time_ms
    _ordered_keys+=($key)
}

# Stop recording the elapsed time
# @param key the name that defines the measurement (must be the same than the one used with 'start_profiling')
function stop_profiling() {
    [[ $ENABLE_PROFILING = "true" ]] || return

    local key="$1"
    local time_ms=$(_time_in_ms)

    if [[ $_time_by_keys[$key] ]]; then
        _time_by_keys[$key]=$(($time_ms - $_time_by_keys[$key]))
    else
        echo "WARNING: you must start the profiling with 'start_profiling \"$key\"')"
    fi
}

# Print all the measurements
function print_profiling() {
    [[ $ENABLE_PROFILING = "true" ]] || return

    local dots1='.................................................................'
    local dots2='......'

    echo $fg_bold[white]
    echo " ==============================================================================="
    echo " ZSH Startup Profiler Report"
    echo " ==============================================================================="
    echo $reset_color
    echo " This report can be disabled by commenting out 'ENABLE_PROFILING' in '~/.zshrc'."
    echo
    echo " This report is a very simple profiling of the active plugins and custom "
    echo " configurations, but is very useful to pinpoint slow scripts!"
    echo
    echo " This report has two colored thresholds (yellow and red) that are defined in"
    echo " the file '~/.oh-my-zsh/lib/profiler.sh' and are currently valued to:"
    echo " - warning when percentage ⩾ $_percentage_warning %"
    echo "               or duration ⩾ $_duration_warning ms"
    echo " - error when percentage ⩾ $_percentage_error %"
    echo "             or duration ⩾ $_duration_error ms"
    echo

    for key in $_ordered_keys; do
        local duration=$_time_by_keys[$key]
        local percent=$(($_time_by_keys[$key] * 100 / $_time_by_keys[TOTAL]))

        local line_color=
        local duration_color=
        local percent_color=

        if [ $_level_by_keys[$key] -le 1 ]; then
            line_color=$fg_bold[white]
        else
            if [ $percent -ge $_percentage_warning ]; then
                percent_color=$fg_bold[yellow]
            fi
            if [ $percent -ge $_percentage_error ]; then
                percent_color=$fg_bold[red]
            fi
            if [ $duration -ge $_duration_warning ]; then
                duration_color=$fg_bold[yellow]
            fi
            if [ $duration -ge $_duration_error ]; then
                duration_color=$fg_bold[red]
            fi
        fi

        local padding=$(printf "%${_level_by_keys[$key]}s %${_level_by_keys[$key]}s")
        printf "$padding"

        local length1=$(( ${#padding} + ${#key} + ${#duration} ))
        printf "${line_color}%s %s ${duration_color}%s ms${line_color} " $key ${dots1:$length1} $duration

        local length2=$(( ${#percent} ))
        printf "%s ${percent_color}%s%%${line_color}%s${reset_color}\n" ${dots2:$length2} $percent
    done

    echo $fg_bold[white]
    echo " ==============================================================================="
    echo $reset_color
}

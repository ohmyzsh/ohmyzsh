#compdef exercism

local curcontext="$curcontext" state line
typeset -A opt_args

local -a options
options=(configure:"Writes config values to a JSON file."
         download:"Downloads and saves a specified submission into the local system"
         open:"Opens a browser to exercism.io for the specified submission."
         submit:"Submits a new iteration to a problem on exercism.io."
         troubleshoot:"Outputs useful debug information."
         upgrade:"Upgrades to the latest available version."
         version:"Outputs version information."
         workspace:"Outputs the root directory for Exercism exercises."
         help:"Shows a list of commands or help for one command")

_arguments -s -S \
    {-h,--help}"[show help]"                \
    {-t,--timeout}"[override default HTTP timeout]" \
    {-v,--verbose}"[turn on verbose logging]" \
    '(-): :->command'                       \
    '(-)*:: :->option-or-argument'          \
    && return 0;

case $state in
    (command)
        _describe 'commands' options ;;
    (option-or-argument)
        case $words[1] in
            s*)
                _files
                ;;
        esac
esac

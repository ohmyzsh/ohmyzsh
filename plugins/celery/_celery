#compdef celery
#autoload

#celery zsh  completion

_celery () {
local -a _1st_arguments ifargs dopts controlargs

typeset -A opt_args

_1st_arguments=('worker' 'events' 'beat' 'shell' 'multi' 'amqp' 'status' 'inspect' \
                'control' 'purge' 'list' 'migrate' 'call' 'result' 'report')
ifargs=('--app=' '--broker=' '--loader=' '--config=' '--version')
dopts=('--detach' '--umask=' '--gid=' '--uid=' '--pidfile=' '--logfile=' '--loglevel=')
controlargs=('--timeout' '--destination')
_arguments \
        '(-A --app=)'{-A,--app}'[app instance to use (e.g. module.attr_name):APP]' \
        '(-b --broker=)'{-b,--broker}'[url to broker.  default is "amqp://guest@localhost//":BROKER]' \
        '(--loader)--loader[name of custom loader class to use.:LOADER]' \
        '(--config)--config[Name of the configuration module:CONFIG]' \
        '(--workdir)--workdir[Optional directory to change to after detaching.:WORKING_DIRECTORY]' \
        '(-q --quiet)'{-q,--quiet}'[Don"t show as much output.]' \
        '(-C --no-color)'{-C,--no-color}'[Don"t display colors.]' \
        '(--version)--version[show program"s version number and exit]' \
        '(- : *)'{-h,--help}'[show this help message and exit]' \
        '*:: :->subcmds' && return 0

if (( CURRENT == 1 )); then
    _describe -t commands "celery subcommand" _1st_arguments
    return
fi

case "$words[1]" in
    worker)
    _arguments \
    '(-C --concurrency=)'{-C,--concurrency=}'[Number of child processes processing the queue. The default is the number of CPUs.]' \
    '(--pool)--pool=:::(processes eventlet gevent threads solo)' \
    '(--purge --discard)'{--discard,--purge}'[Purges all waiting tasks before the daemon is started.]' \
    '(-f --logfile=)'{-f,--logfile=}'[Path to log file. If no logfile is specified, stderr is used.]' \
    '(--loglevel=)--loglevel=:::(critical error warning info debug)' \
    '(-N --hostname=)'{-N,--hostname=}'[Set custom hostname, e.g. "foo.example.com".]' \
    '(-B --beat)'{-B,--beat}'[Also run the celerybeat periodic task scheduler.]' \
    '(-s --schedule=)'{-s,--schedule=}'[Path to the schedule database if running with the -B option. Defaults to celerybeat-schedule.]' \
    '(-S --statedb=)'{-S,--statedb=}'[Path to the state database.Default: None]' \
    '(-E --events)'{-E,--events}'[Send events that can be captured by monitors like celeryev, celerymon, and others.]' \
    '(--time-limit=)--time-limit=[nables a hard time limit (in seconds int/float) for tasks]' \
    '(--soft-time-limit=)--soft-time-limit=[Enables a soft time limit (in seconds int/float) for tasks]' \
    '(--maxtasksperchild=)--maxtasksperchild=[Maximum number of tasks a pool worker can execute before it"s terminated and replaced by a new worker.]' \
    '(-Q --queues=)'{-Q,--queues=}'[List of queues to enable for this worker, separated by comma. By default all configured queues are enabled.]' \
    '(-I --include=)'{-I,--include=}'[Comma separated list of additional modules to import.]' \
    '(--pidfile=)--pidfile=[Optional file used to store the process pid.]' \
    '(--autoscale=)--autoscale=[Enable autoscaling by providing max_concurrency, min_concurrency.]' \
    '(--autoreload)--autoreload[Enable autoreloading.]' \
    '(--no-execv)--no-execv[Don"t do execv after multiprocessing child fork.]'
    compadd -a ifargs
    ;;
    inspect)
    _values -s \
    'active[dump active tasks (being processed)]' \
    'active_queues[dump queues being consumed from]' \
    'ping[ping worker(s)]' \
    'registered[dump of registered tasks]' \
    'report[get bugreport info]' \
    'reserved[dump reserved tasks (waiting to be processed)]' \
    'revoked[dump of revoked task ids]' \
    'scheduled[dump scheduled tasks (eta/countdown/retry)]' \
    'stats[dump worker statistics]'
    compadd -a controlargs ifargs
    ;;
    control)
    _values -s \
    'add_consumer[tell worker(s) to start consuming a queue]' \
    'autoscale[change autoscale settings]' \
    'cancel_consumer[tell worker(s) to stop consuming a queue]' \
    'disable_events[tell worker(s) to disable events]' \
    'enable_events[tell worker(s) to enable events]' \
    'pool_grow[start more pool processes]' \
    'pool_shrink[use less pool processes]' \
    'rate_limit[tell worker(s) to modify the rate limit for a task type]' \
    'time_limit[tell worker(s) to modify the time limit for a task type.]'
    compadd -a controlargs ifargs
    ;;
    multi)
    _values -s \
    '--nosplash[Don"t display program info.]' \
    '--verbose[Show more output.]' \
    '--no-color[Don"t display colors.]' \
    '--quiet[Don"t show as much output.]' \
    'start' 'restart' 'stopwait' 'stop' 'show' \
    'names' 'expand' 'get' 'kill'
    compadd -a ifargs
    ;;
    amqp)
    _values -s \
    'queue.declare' 'queue.purge' 'exchange.delete' 'basic.publish' \
    'exchange.declare' 'queue.delete' 'queue.bind' 'basic.get'
    ;;
    list)
    _values -s, 'bindings'
    ;;
    shell)
    _values -s \
    '--ipython[force iPython.]' \
    '--bpython[force bpython.]' \
    '--python[force default Python shell.]' \
    '--without-tasks[don"t add tasks to locals.]' \
    '--eventlet[use eventlet.]' \
    '--gevent[use gevent.]'
    compadd -a ifargs
    ;;
    beat)
    _arguments \
    '(-s --schedule=)'{-s,--schedule=}'[Path to the schedule database. Defaults to celerybeat-schedule.]' \
    '(-S --scheduler=)'{-S,--scheduler=}'[Scheduler class to use. Default is celery.beat.PersistentScheduler.]' \
    '(--max-interval)--max-interval[]'
    compadd -a dopts fargs
    ;;
    events)
    _arguments \
    '(-d --dump)'{-d,--dump}'[Dump events to stdout.]' \
    '(-c --camera=)'{-c,--camera=}'[Take snapshots of events using this camera.]' \
    '(-F --frequency=)'{-F,--frequency=}'[Camera: Shutter frequency.  Default is every 1.0 seconds.]' \
    '(-r --maxrate=)'{-r,--maxrate=}'[Camera: Optional shutter rate limit (e.g. 10/m).]'
    compadd -a dopts fargs
    ;;
    *)
        ;;
    esac
}

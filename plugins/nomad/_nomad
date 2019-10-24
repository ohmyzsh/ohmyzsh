#compdef nomad

local -a _nomad_cmds
_nomad_cmds=(
  'agent:Runs a Nomad agent'
  'agent-info:Display status information about the local agent'
  'alloc-status:Display allocation status information and metadata'
  'client-config:View or modify client configuration details'
  'eval-status:Display evaluation status and placement failure reasons'
  'fs:Inspect the contents of an allocation directory'
  'init:Create an example job file'
  'inspect:Inspect a submitted job'
  'logs:Streams the logs of a task.'
  'node-drain:Toggle drain mode on a given node'
  'node-status:Display status information about nodes'
  'plan:Dry-run a job update to determine its effects'
  'run:Run a new job or update an existing'
  'server-force-leave:Force a server into the left state'
  'server-join:Join server nodes together'
  'server-members:Display a list of known servers and their'
  'status:Display status information about jobs'
  'stop:Stop a running job'
  'validate:Checks if a given job specification is valid'
  'version:Prints the Nomad version'
)

__allocstatus() {
  _arguments \
    '-address=[(addr) The address of the Nomad server. Overrides the NOMAD_ADDR environment variable if set. Default = http://127.0.0.1:4646]' \
    '-region=[(region) The region of the Nomad servers to forward commands to. Overrides the NOMAD_REGION environment variable if set. Defaults to the Agent s local region.]' \
    '-no-color[Disables colored command output.]' \
    '-short[Display short output. Shows only the most recent task event.]' \
    '-stats[Display detailed resource usage statistics.]' \
    '-verbose[Show full information.]' \
    '-json[Output the allocation in its JSON format.]' \
    '-t[Format and display allocation using a Go template.]'
}

__evalstatus() {
  _arguments \
    '-address=[(addr) The address of the Nomad server. Overrides the NOMAD_ADDR environment variable if set. Default = http://127.0.0.1:4646]' \
    '-region=[(region) The region of the Nomad servers to forward commands to. Overrides the NOMAD_REGION environment variable if set. Defaults to the Agent s local region.]' \
    '-no-color[Disables colored command output.]' \
    '-monitor[Monitor an outstanding evaluation.]' \
    '-verbose[Show full information.]' \
    '-json[Output the allocation in its JSON format.]' \
    '-t[Format and display allocation using a Go template.]'
}

__inspect() {
  _arguments \
    '-address=[(addr) The address of the Nomad server. Overrides the NOMAD_ADDR environment variable if set. Default = http://127.0.0.1:4646]' \
    '-region=[(region) The region of the Nomad servers to forward commands to. Overrides the NOMAD_REGION environment variable if set. Defaults to the Agent s local region.]' \
    '-no-color[Disables colored command output.]' \
    '-json[Output the allocation in its JSON format.]' \
    '-t[Format and display allocation using a Go template.]'
}

__logs() {
  _arguments \
    '-address=[(addr) The address of the Nomad server. Overrides the NOMAD_ADDR environment variable if set. Default = http://127.0.0.1:4646]' \
    '-region=[(region) The region of the Nomad servers to forward commands to. Overrides the NOMAD_REGION environment variable if set. Defaults to the Agent s local region.]' \
    '-no-color[Disables colored command output.]' \
    '-stderr[ Display stderr logs.]' \
    '-job[<job-id> Use a random allocation from the specified job ID.]' \
    '-verbose[Show full information.]' \
    '-f[Causes the output to not stop when the end of the logs are reached, but rather to wait for additional output.]' \
    '-tail[Show the logs contents with offsets relative to the end of the logs. If no offset is given, -n is defaulted to 10.]' \
    '-n[Sets the tail location in best-efforted number of lines relative to the end of the logs.]' \
    '-c[Sets the tail location in number of bytes relative to the end of the logs.]'
}

__nodestatus() {
  _arguments \
    '-address=[(addr) The address of the Nomad server. Overrides the NOMAD_ADDR environment variable if set. Default = http://127.0.0.1:4646]' \
    '-region=[(region) The region of the Nomad servers to forward commands to. Overrides the NOMAD_REGION environment variable if set. Defaults to the Agent s local region.]' \
    '-no-color[Disables colored command output.]' \
    '-self[Query the status of the local node.]' \
    '-allocs[ Display a count of running allocations for each node.]' \
    '-short[Display short output. Shows only the most recent task event.]' \
    '-stats[Display detailed resource usage statistics.]' \
    '-verbose[Show full information.]' \
    '-json[Output the allocation in its JSON format.]' \
    '-t[Format and display allocation using a Go template.]'
}

__plan() {
  _arguments \
    '-address=[(addr) The address of the Nomad server. Overrides the NOMAD_ADDR environment variable if set. Default = http://127.0.0.1:4646]' \
    '-region=[(region) The region of the Nomad servers to forward commands to. Overrides the NOMAD_REGION environment variable if set. Defaults to the Agent s local region.]' \
    '-no-color[Disables colored command output.]' \
    '-diff[Determines whether the diff between the remote job and planned job is shown. Defaults to true.]' 
}

__run() {
  _arguments \
    '-address=[(addr) The address of the Nomad server. Overrides the NOMAD_ADDR environment variable if set. Default = http://127.0.0.1:4646]' \
    '-region=[(region) The region of the Nomad servers to forward commands to. Overrides the NOMAD_REGION environment variable if set. Defaults to the Agent s local region.]' \
    '-no-color[Disables colored command output.]' \
    '-check-index[If set, the job is only registered or updated if the the passed job modify index matches the server side version. If a check-index value of zero is passed, the job is only registered if it does not yet exist. If a non-zero value is passed, it ensures that the job is being updated from a known state. The use of this flag is most common in conjunction with plan command.]' \
    '-detach[Return immediately instead of entering monitor mode. After job submission, the evaluation ID will be printed to the screen, which can be used to examine the evaluation using the eval-status command.]' \
    '-output[Output the JSON that would be submitted to the HTTP API without submitting the job.]' \
    '-verbose[Show full information.]'
}

__status() {
  _arguments \
    '-address=[(addr) The address of the Nomad server. Overrides the NOMAD_ADDR environment variable if set. Default = http://127.0.0.1:4646]' \
    '-region=[(region) The region of the Nomad servers to forward commands to. Overrides the NOMAD_REGION environment variable if set. Defaults to the Agent s local region.]' \
    '-no-color[Disables colored command output.]' \
    '-short[Display short output. Shows only the most recent task event.]' \
    '-evals[Display the evaluations associated with the job.]' \
    '-verbose[Show full information.]'
}

__stop() {
  _arguments \
    '-address=[(addr) The address of the Nomad server. Overrides the NOMAD_ADDR environment variable if set. Default = http://127.0.0.1:4646]' \
    '-region=[(region) The region of the Nomad servers to forward commands to. Overrides the NOMAD_REGION environment variable if set. Defaults to the Agent s local region.]' \
    '-no-color[Disables colored command output.]' \
    '-detach[Return immediately instead of entering monitor mode. After the deregister command is submitted, a new evaluation ID is printed to the screen, which can be used to examine the evaluation using the eval-status command.]' \
    '-yes[Automatic yes to prompts.]' \
    '-verbose[Show full information.]'
}

_arguments '*:: :->command'

if (( CURRENT == 1 )); then
  _describe -t commands "nomad command" _nomad_cmds
  return
fi

local -a _command_args
case "$words[1]" in
  alloc-status)
    __allocstatus ;;
  eval-status)
    __evalstatus ;;
  inspect)
    __inspect ;;
  logs)
    __logs ;;
  node-status)
    __nodestatus ;;
  plan)
    __plan ;;
  run)
    __run ;;
  status)
    __status ;;
  stop)
    __stop ;;
esac

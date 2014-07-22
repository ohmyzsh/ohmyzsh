function _storm_commands() {
    local ret=1 state
    _arguments ':subcommand:->subcommand' && ret=0

    case $state in
      subcommand)
        subcommands=(
          "jar:Runs the main method of class with the specified arguments."
          "kill:Kills the topology with the name topology-name."
          "activate:Activates the specified topology’s spouts."
          "deactivate:Deactivates the specified topology’s spouts."
          "rebalance:Spread out where the workers for a topology are running."
          "repl:Opens up a Clojure REPL with the storm jars and configuration on the classpath."
          "classpath:Prints the classpath used by the storm client when running commands."
          "localconfvalue:Prints out the value for conf-name in the local Storm configs."
          "remoteconfvalue:Prints out the value for conf-name in the cluster’s Storm configs."
          "nimbus:Launches the nimbus daemon."
          "supervisor:Launches the supervisor daemon."
          "ui:Launches the UI daemon."
          "drpc:Launches a DRPC daemon. "
        )
        _describe -t subcommands 'storm subcommands' subcommands && ret=0
    esac

    return ret
}

compdef _storm_commands storm

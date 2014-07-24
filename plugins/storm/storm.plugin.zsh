function _storm_commands() {
    local ret=1 state
    _arguments ':subcommand:->subcommand' && ret=0

    case $state in
      subcommand)
        subcommands=(
          "activate:Activates the specified topology’s spouts."
          "classpath:Prints the classpath used by the storm client when running commands."
          "deactivate:Deactivates the specified topology’s spouts."
          "dev-zookeeper:Launches a fresh Zookeeper server for development/testing."
          "drpc:Launches a DRPC daemon."
          "help:Print usage."
          "jar:Runs the main method of class with the specified arguments."
          "kill:Kills the topology with the name topology-name."
          "localconfvalue:Prints out the value for conf-name in the local Storm configs."
          "logviewer:Launches the log viewer daemon."
          "rebalance:Spread out where the workers for a topology are running."
          "repl:Opens up a Clojure REPL with the storm jars and configuration on the classpath."
          "remoteconfvalue:Prints out the value for conf-name in the cluster’s Storm configs."
          "supervisor:Launches the supervisor daemon."
          "ui:Launches the UI daemon."
          "version:Print version."
        )
        _describe -t subcommands 'storm subcommands' subcommands && ret=0
    esac

    return ret
}

compdef _storm_commands storm

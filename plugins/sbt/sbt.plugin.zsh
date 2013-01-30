# ------------------------------------------------------------------------------
#          FILE:  sbt.plugin.zsh
#   DESCRIPTION:  oh-my-zsh plugin file.
#        AUTHOR:  Mirko Caserta (mirko.caserta@gmail.com)
#       VERSION:  1.0.0
# ------------------------------------------------------------------------------
 
function listSbtCompletions { 
     reply=(
        # common lifecycle
        clean compile doc gen-idea update
        # console
        console console-quick console-project
        # dist
        dist dist:clean
        # package
        package package-doc package-src
        # publish
        publish publish-local
        #
        run run-main
        # test
        test test-only test-quick test:console-quick test:run-main
    ); 
}

compctl -K listSbtCompletions sbt

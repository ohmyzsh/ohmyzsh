# ------------------------------------------------------------------------------
#          FILE:  sbt.plugin.zsh
#   DESCRIPTION:  oh-my-zsh plugin file.
#        AUTHOR:  Mirko Caserta (mirko.caserta@gmail.com)
#       VERSION:  1.0.1
# ------------------------------------------------------------------------------
 
# aliases - mnemonic: prefix is 'sb'
alias sbc='sbt compile'
alias sbco='sbt console'
alias sbcq='sbt console-quick'
alias sbcl='sbt clean'
alias sbcp='sbt console-project'
alias sbd='sbt doc'
alias sbdc='sbt dist:clean'
alias sbdi='sbt dist'
alias sbgi='sbt gen-idea'
alias sbp='sbt publish'
alias sbpl='sbt publish-local'
alias sbr='sbt run'
alias sbrm='sbt run-main'
alias sbu='sbt update'
alias sbx='sbt test'

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

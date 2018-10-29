# Some Useful CloudFoundry Aliases & Functions
alias cfl="cf login"
alias cft="cf target"
alias cfa="cf apps"
alias cfs="cf services"
alias cfm="cf marketplace"
alias cfp="cf push"
alias cfcs="cf create-service"
alias cfbs="cf bind-service"
alias cfus="cf unbind-service"
alias cfds="cf delete-service"
alias cfup="cf cups"
alias cflg="cf logs"
alias cfr="cf routes"
alias cfe="cf env"
alias cfsh="cf ssh"
alias cfsc="cf scale"
alias cfev="cf events"
alias cfdor="cf delete-orphaned-routes"
alias cfbpk="cf buildpacks"
alias cfdm="cf domains"
alias cfsp="cf spaces"
function cfap() { cf app $1 }
function cfh.() { export CF_HOME=$PWD/.cf }
function cfh~() { export CF_HOME=~/.cf }
function cfhu() { unset CF_HOME }
function cfpm() { cf push -f $1 }
function cflr() { cf logs $1 --recent }
function cfsrt() { cf start $1 }
function cfstp() { cf stop $1 }
function cfstg() { cf restage $1 }
function cfdel() { cf delete $1 }
function cfsrtall() {cf apps | awk '/stopped/ { system("cf start " $1)}'}
function cfstpall() {cf apps | awk '/started/ { system("cf stop " $1)}'}

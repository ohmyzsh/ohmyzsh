alias ts-resolve-host="tsunami variables resolve --unit-type host "

function ts-variables-show() {
  tsunami variables show $1 $2
}
function ts-variables-show-version() {
  tsunami variables history $1 $2
}

alias tsunami-resolve-host="ts-resolve-host"
alias tsunami-variables-show="ts-variables-show"
alias tsunami-variables-show-version="ts-variables-show-version"

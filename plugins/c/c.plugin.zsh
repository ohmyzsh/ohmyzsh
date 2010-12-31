function c() {
   cd ~/Dev/$1;
}

#compdef c
function _c () {
  _files -W ~/Dev -/
}

compdef _c c

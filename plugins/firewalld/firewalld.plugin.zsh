alias fw="firewall-cmd"
alias fwp="firewall-cmd --permanent"
alias fwr="firewall-cmd --reload"
alias fwrp="firewall-cmd --runtime-to-permanent"

function fwl () {
  # converts output to zsh array ()
  # @f flag split on new line
  zones=("${(@f)$(firewall-cmd --get-active-zones | grep -v interfaces)}")

  for i in $zones; do
    firewall-cmd --zone $i --list-all
  done

  echo 'Direct Rules:'
  firewall-cmd --direct --get-all-rules
}

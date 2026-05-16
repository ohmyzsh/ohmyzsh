alias fw="sudo firewall-cmd"
alias fwp="sudo firewall-cmd --permanent"
alias fwr="sudo firewall-cmd --reload"
alias fwrp="sudo firewall-cmd --runtime-to-permanent"

function fwl () {
  # converts output to zsh array ()
  # @f flag split on new line
  zones=("${(@f)$(sudo firewall-cmd --get-active-zones | grep -v 'interfaces\|sources')}")

  for i in $zones; do
    sudo firewall-cmd --zone ${i/ \(default\)} --list-all
  done

  echo 'Direct Rules:'
  sudo firewall-cmd --direct --get-all-rules
}

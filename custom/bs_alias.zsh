alias depl='ssh deploy.browserstack.com'
alias infra='ssh infra.browserstack.com'
alias repo='cd ~/Documents/work/repos'
alias snapshot='sh /Users/prashanth/Documents/work/repos/infra-automation/platform/snapshot.sh'
alias cpw='sh /Users/prashanth/Documents/work/repos/infra-automation/platform/cpw'
alias cpm='sh /Users/prashanth/Documents/work/repos/infra-automation/platform/cpm'
alias delay_numbers='sh /Users/prashanth/Documents/work/repos/infra-automation/platform/delay_numbers'

function mssh() { 
	ssh -p4022 ritesharora@$1
}

function rebootm() {
    curl http://$1:45680/r3b00t
}

function rebootw() {
    curl http://$1:4568/r3b00t
}

function bsrakes(){
        bundle exec rake terminal:manage_pool1_start &
        bundle exec rake terminal:cleanup_async &
        bundle exec rake terminal:update_terminal_statuses &
        bundle exec rake terminal:restore_from_snapshot &
        bundle exec rake terminal:check_ports_for_restored_snapshots_wtf &
}

function addmac(){
	if [[ $# -eq 0 ]]; then
  		echo "Usage - addmac <env> <ip> <tt>"
  		exit
	fi
	curl --silent --data "ip=$2&tt=$3&os=mac$3&region=us-east-1" admin:abcd@$1.browserstack.com/admin/add_mac -o /dev/null
}

function blockip(){
	if [[ $# -eq 0 ]]; then
  		echo "Usage - blockip <ip> <reason> (f)"
  		exit
	elif [[ $3 = "f" ]]; then
  		force="true"
	else
  		force="false"
	fi
	ruby /Users/prashanth/Documents/work/repos/block.rb $1 $2
}

check_port() {
  if [[ $(nc -z -G 2 $1 $2) =~ "succeeded" ]]; then
    echo "$2 - OK"
  else
    echo "$2 - FAILED"
  fi
}

function esxi_ip() {
	ssh root@$1 "python /browserstack/esxi_ip_map.py"
}

function delete_terminal() {
    if [[ $# -eq 0 ]]; then
        echo "Usage - delete_terminal <ip> <name> (f)"
        exit
    elif [[ $3 = "f" ]]; then
        force="true"
    else
        force="false"
    fi
    curl http://admin:stevejobsrocks!!@www.browserstack.com/admin/delete_terminal?ip=$1\&name=$2\&force=$force
}

function esxi_ssh() {
	`ssh root@$1`
}


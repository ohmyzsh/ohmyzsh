function __run_ansible_container {
  docker run -it --rm \
  -v $(pwd):$(pwd) \
  -v ${HOME}/.ansible:/.ansible \
  -w $(pwd) \
  -u $(id -u) \
  ${ZSH_ANSIBLE_IMAGE:-hermitmaster/ansible-runner:latest} \
  $funcstack[2] "$@"
}

function ansible {
  __run_ansible_container "$@"
}

function ansible-config {
  __run_ansible_container "$@"
}

function ansible-connection {
  __run_ansible_container "$@"
}

function ansible-doc {
  __run_ansible_container "$@"
}

function ansible-galaxy {
  __run_ansible_container "$@"
}

function ansible-inventory {
  __run_ansible_container "$@"
}

function ansible-lint {
  __run_ansible_container "$@"
}

function ansible-playbook {
  __run_ansible_container "$@"
}

function ansible-pull {
  __run_ansible_container "$@"
}

function ansible-test {
  __run_ansible_container "$@"
}

function ansible-vault {
  __run_ansible_container "$@"
}

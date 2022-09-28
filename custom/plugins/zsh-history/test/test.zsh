#!/usr/bin/env zsh

ACCESS_KEY=$1

set -e
gpg -q --quick-gen-key --yes --batch --passphrase '' $UID
git config --global user.name "James Fraser"
git config --global user.email "wulfgar.pro@gmail.com"
git clone "https://$ACCESS_KEY@github.com/wulfgarpro/history-sync-test" ~/.zsh_history_proj
set +e

function success() {
    echo $fg[green]"$1"$reset_color
}

function failure() {
    echo $fg[red]"$1"$reset_color
}

function info() {
    echo $fg[yellow]"$1"$reset_color
}

function check_fn_exists() {
    typeset -f "$1" >/dev/null
    [[ $? -eq 0 ]] || {failure "FAILURE: Function '$1' missing"; exit $?}
}

function check_alias_exists() {
    alias "$1" >/dev/null
    [[ $? -eq 0 ]] || {failure "FAILURE: Alias '$1' missing"; exit $?}
}

function check_env_exists() {
    [[ -v $1 ]]
    [[ $? -eq 0 ]] || {failure "FAILURE: Environment variable '$1' missing"; exit $?}
}

function check_history() {
    rg -U "$1" ~/.zsh_history >/dev/null
    [[ $? -eq 0 ]] || {failure "FAILURE: History did not match '$1'"; exit $?}
}

function setup() {
    set -e
    [[ -d ~/.zsh_history_proj ]]
    # Clear existing history file
    echo -n "" > ~/.zsh_history_proj/zsh_history
    set +e
}

info "TEST HISTORY-SYNC FUNCTIONS EXIST"
check_fn_exists _print_git_error_msg
check_fn_exists _print_gpg_encrypt_error_msg
check_fn_exists _print_gpg_decrypt_error_msg
check_fn_exists _usage
check_fn_exists history_sync_pull
check_fn_exists history_sync_push
success "SUCCESS"

info "TEST HISTORY-SYNC ALIASES EXIST"
check_alias_exists zhps
check_alias_exists zhpl
check_alias_exists zhsync
success "SUCCESS"

info "TEST ENVIRONMENT VARIABLES EXIST"
check_env_exists ZSH_HISTORY_PROJ
check_env_exists ZSH_HISTORY_FILE_NAME
check_env_exists ZSH_HISTORY_FILE
check_env_exists ZSH_HISTORY_FILE_ENC_NAME
check_env_exists ZSH_HISTORY_FILE_ENC
check_env_exists ZSH_HISTORY_FILE_DECRYPT_NAME
check_env_exists ZSH_HISTORY_COMMIT_MSG
success "SUCCESS"

info "TEST SYNC HISTORY BASIC 0"
setup
RAND=$RANDOM
echo "1 echo $RAND" >> ~/.zsh_history
zhps -y -r $UID && zhpl -y
check_history "^1 echo $RAND$"
success "SUCCESS"

info "TEST SYNC HISTORY BASIC 1"
setup
RAND0=$RANDOM
RAND1=$RANDOM
RAND2=$RANDOM
RAND3=$RANDOM
RAND4=$RANDOM
echo "1 echo $RAND0" >> ~/.zsh_history
echo "2 echo $RAND1" >> ~/.zsh_history
echo "3 echo $RAND2" >> ~/.zsh_history
echo "4 echo $RAND3" >> ~/.zsh_history
echo "5 echo $RAND4" >> ~/.zsh_history
zhps -y -r $UID -s $UID && zhpl -y
check_history "^1 echo $RAND0$"
check_history "^2 echo $RAND1$"
check_history "^3 echo $RAND2$"
check_history "^4 echo $RAND3$"
check_history "^5 echo $RAND4$"
success "SUCCESS"

info "TEST SYNC HISTORY MULTI-LINE 0"
setup
echo "1 for i in {1..3}; do
echo \$i
done" >> ~/.zsh_history
zhps -y -r $UID && zhpl -y
check_history "^1 for i in \{1..3\}; do\necho \\\$i\ndone$"
success "SUCCESS"

# Don't support any matching from the middle of words
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 

# We're interested in all processes, not just mine. I'm an SA
zstyle ':completion:*:*:*:*:processes' command "ps -e -o pid,user,comm -w -w"

# I don't install oh-my-zsh in the default place
zstyle ':completion::complete:*' cache-path ~/tmp/cache/

# On macs, there are lots of users we dont care about
# they all start with _
zstyle ':completion:*:*:*:users' ignored-patterns \
        $(awk -F: '/^_/ { print $1 }' /etc/passwd)

# On macs, there are lots of groups we dont care about
# they all start with _
zstyle ':completion:*:*:*:groups' ignored-patterns \
        $(awk -F: '/^_/ { print $1 }' /etc/group)

# In addition to the default /etc/hosts, ~/.ssh/known_hosts, we parse
# ~/.ssh/config and a magic file ~/.host-completion file for additional hosts
# to complete
[ -f ~/.ssh/config ] && : ${(A)ssh_config_hosts:=${${${${(@M)${(f)"$(<$HOME/.ssh/config)"}:#Host *}#Host }:#*\**}:#*\?*}}
[ -r ~/.ssh/known_hosts ] && _ssh_hosts=(${${${${(f)"$(<$HOME/.ssh/known_hosts)"}:#[\|]*}%%\ *}%%,*}) || _ssh_hosts=()
[ -r ~/.host-completion ] && : ${(A)_host_completion:=${(s: :)${(ps:\t:)${${(f)~~"$(<$HOME/.host-completion)"}%%\#*}##[:blank:]#[^[:blank:]]#}}} || _host_completion=()
[ -r /etc/hosts ] && : ${(A)_etc_hosts:=${(s: :)${(ps:\t:)${${(f)~~"$(</etc/hosts)"}%%\#*}##[:blank:]#[^[:blank:]]#}}} || _etc_hosts=()
hosts=(
  "$_ssh_config_hosts[@]"
  "$_ssh_hosts[@]"
  "$_etc_hosts[@]"
  "$_host_completion[@]"
  `hostname`
  localhost
)

zstyle ':completion:*:hosts' hosts $hosts

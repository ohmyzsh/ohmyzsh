# sshukh-zsh-plugin
*SSH Update Known Hosts*

Prompts to update `known_hosts` file for you if needed.

To install, run the following command:

```
$ git clone https://github.com/anatolykopyl/sshukh-zsh-plugin.git $HOME/.oh-my-zsh/custom/plugins/sshukh
```
To always use with ssh (recommended) add this alias to your `.zshrc`:
```
alias ssh='sshukh'
```
Zsh may tell you that the plugin is disabled until permissions are fixed. Just run the command it suggests.
```
$ compaudit | xargs chmod g-w,o-w
```

## Usage
Let's connect to an ip that changed hosts:
```
$ sshukh pi@192.168.1.54
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@    WARNING: REMOTE HOST IDENTIFICATION HAS CHANGED!     @
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
IT IS POSSIBLE THAT SOMEONE IS DOING SOMETHING NASTY!
Someone could be eavesdropping on you right now (man-in-the-middle attack)!
It is also possible that a host key has just been changed.
The fingerprint for the ECDSA key sent by the remote host is
SHA256:vOsLgBskwRk1pvSpgpALYpdi/9WZ5OGB5iI+80Zkdg8.
Please contact your system administrator.
Add correct host key in /Users/akopyl/.ssh/known_hosts to get rid of this message.
Offending ECDSA key in /Users/akopyl/.ssh/known_hosts:26
ECDSA host key for 192.168.1.54 has changed and you have requested strict checking.
Host key verification failed.
Update known_hosts? [y/n] y
# Host 192.168.1.54 found: line 26
/Users/akopyl/.ssh/known_hosts updated.
Original contents retained as /Users/akopyl/.ssh/known_hosts.old
```
There is a prompt asking if you want to remove the conflicting host from `known_hosts` and upon answering `y` ssh reruns automatically successfully.

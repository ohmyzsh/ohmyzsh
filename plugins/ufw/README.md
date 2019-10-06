# UFW
This plugin adds support for managing everybody's favorite Uncomplicated Firewall (UFW). Learn more about [`UFW`](https://wiki.ubuntu.com/UncomplicatedFirewall).

To use it, add ufw to the plugins array of your zshrc file:
```
plugins=(... ufw)
```
UFW is a simple Ubuntu interface for managing iptables. 

Some of the commands include:

* `allow <port>/<optional: protocol>` add an allow rule 
* `default` set default policy
* `delete <port>/<optional: protocol>` delete RULE
* `deny <port>/<optional: protocol>` add deny rule
* `disable` disables the firewall
* `enable` enables the firewall

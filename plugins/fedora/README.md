
DNF is a software package manager that installs, updates, and removes packages on RPM-based Linux distributions. It automatically computes dependencies and determines the actions required to install packages. DNF also makes it easier to maintain groups of machines, eliminating the need to manually update each one using rpm. Introduced in Fedora 18, it has been the default package manager since Fedora 22

To use it, add dnf to the plugins array of your zshrc file:
```
plugins=(... dnf)
```

dnf = Dandified YUM
Then install DNF typing:
	* sudo yum install dnf


dnf [options] install @<spec>...
DNF makes sure that the given packages and their dependencies are installed on the system. Each <spec> can be either a <package-spec>, or a @<group-spec>.
	
| Alias   | Command                            | Description                                                         |
|---------|------------------------------------|---------------------------------------------------------------------| 
| dnfl    | dnf list                	       | List packages
| dnfli	  | dnf list installed     	       | List installed packages
| dnfgl	  | dnf grouplist"         	       | List package groups
| dnfmc	  | dnf makecache"        	       | Generate metadata cache
| dnfp    | dnf info"           	       | Show package information
| dnfs    | dnf search"          	       | Search package
| dnfu	  | sudo dnf upgrade"    	       | Upgrade package
| dnfi	  | sudo dnf install"                  | Install package
| dnfgi	  | sudo dnf groupinstall" 	       | Install package group
| dnfr	  | sudo dnf remove"        	       | Remove package
| dnfgr   | sudo dnf groupremove"   	       | Remove package group
| dnfc	  | sudo dnf clean all"     	       | Clean cache


For a full list aliases and the functions just watch the plugins code https://github.com/robbyrussell/oh-my-zsh/blob/master/plugins/fedora/fedora.plugin.zsh.

## Contributors

- Saurav Jaiswal - sauravjaiswal999@gmail.com

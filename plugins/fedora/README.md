
DNF is a software package manager that installs, updates, and removes packages on RPM-based Linux distributions. It automatically computes dependencies and determines the actions required to install packages. DNF also makes it easier to maintain groups of machines, eliminating the need to manually update each one using rpm. Introduced in Fedora 18, it has been the default package manager since Fedora 22


dnf = Dandified YUM
Then install DNF typing:
	sudo yum install dnf


dnf [options] install @<spec>...
DNF makes sure that the given packages and their dependencies are installed on the system. Each <spec> can be either a <package-spec>, or a @<group-spec>.
	
	
| Alias   | Command                            | Description                                                         |
|---------|------------------------------------|---------------------------------------------------------------------|
| trconf  | trizen -C                          | Fix all configuration files with vimdiff                            |
| trin    | trizen -S                          | Install packages from the repositories                              |
| trins   | trizen -U                          | Install a package from a local file                                 |
| trinsd  | trizen -S --asdeps                 | Install packages as dependencies of another package                 |
| trloc   | trizen -Qi                         | Display information about a package in the local database           |
| trlocs  | trizen -Qs                         | Search for packages in the local database                           |
| trlst   | trizen -Qe                         | List installed packages including from AUR (tagged as "local")      |
| trmir   | trizen -Syy                        | Force refresh of all package lists after updating mirrorlist        |
| trorph  | trizen -Qtd                        | Remove orphans using yaourt                                         |
| trre    | trizen -R                          | Remove packages, keeping its settings and dependencies              |
| trrem   | trizen -Rns                        | Remove packages, including its settings and unneeded dependencies   |
| trrep   | trizen -Si                         | Display information about a package in the repositories             |
| trreps  | trizen -Ss                         | Search for packages in the repositories                             |
| trupd   | trizen -Sy && sudo abs && sudo aur | Update and refresh local package, ABS and AUR databases             |
| trupd   | trizen -Sy && sudo abs             | Update and refresh the local package and ABS databases              |
| trupd   | trizen -Sy && sudo aur             | Update and refresh the local package and AUR databases              |
| trupd   | trizen -Sy                         | Update and refresh the local package database                       |
| trupg   | trizen -Syua                       | Sync with repositories before upgrading all packages (from AUR too) |
| trsu    | trizen -Syua --no-confirm          | Same as `trupg`, but without confirmation                           |
| upgrade | trizen -Syu                        | Sync with repositories before upgrading packages                    |

#### TRIZEN

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


# Arch Linux plugin

This plugin adds some aliases and functions to work with Arch Linux.

To use it, add `archlinux` to the plugins array in your zshrc file:

```zsh
plugins=(... archlinux)
```

## Features

### Pacman

| Alias        | Command                                | Description                                                      |
|--------------|----------------------------------------|------------------------------------------------------------------|
| pacin        | `sudo pacman -S`                       | Install packages from the repositories                           |
| pacins       | `sudo pacman -U`                       | Install a package from a local file                              |
| pacinsd      | `sudo pacman -S --asdeps`              | Install packages as dependencies of another package              |
| pacloc       | `pacman -Qi`                           | Display information about a package in the local database        |
| paclocs      | `pacman -Qs`                           | Search for packages in the local database                        |
| paclsorphans | `sudo pacman -Qdt`                     | List all orphaned packages                                       |
| pacmir       | `sudo pacman -Syy`                     | Force refresh of all package lists after updating mirrorlist     |
| pacre        | `sudo pacman -R`                       | Remove packages, keeping its settings and dependencies           |
| pacrem       | `sudo pacman -Rns`                     | Remove packages, including its settings and dependencies         |
| pacrep       | `pacman -Si`                           | Display information about a package in the repositories          |
| pacreps      | `pacman -Ss`                           | Search for packages in the repositories                          |
| pacrmorphans | `sudo pacman -Rs $(pacman -Qtdq)`      | Delete all orphaned packages                                     |
| pacupd       | `sudo pacman -Sy`                      | Update and refresh local package, ABS and AUR databases          |
| pacupg       | `sudo pacman -Syu`                     | Sync with repositories before upgrading packages                 |
| pacfileupg   | `sudo pacman -Fy`                      | Download fresh package databases from the server                 |
| pacfiles     | `pacman -F`                            | Search package file names for matching strings                   |
| pacls        | `pacman -Ql`                           | List files in a package                                          |
| pacown       | `pacman -Qo`                           | Show which package owns a file                                   |
| upgrade[¹](#f1) | `sudo pacman -Syu`                  | Sync with repositories before upgrading packages                 |

| Function       | Description                                               |
|----------------|-----------------------------------------------------------|
| pacdisowned    | List all disowned files in your system                    |
| paclist        | List all explicitly installed packages with a description |
| pacmanallkeys  | Get all keys for developers and trusted users             |
| pacmansignkeys | Locally trust all keys passed as parameters               |
| pacweb         | Open the website of an ArchLinux package                  |

Note: paclist used to print packages with a description which are (1) explicitly installed
and (2) available for upgrade. Due to flawed scripting, it also printed all packages if no
upgrades were available. Use `pacman -Que` instead.

### AUR helpers

#### Aura

| Alias   | Command                                         | Description                                                             |
|---------|-------------------------------------------------|-------------------------------------------------------------------------|
| auin    | `sudo aura -S`                                  | Install packages from the repositories                                  |
| aurin   | `sudo aura -A`                                  | Install packages from the repositories                                  |
| auins   | `sudo aura -U`                                  | Install a package from a local file                                     |
| auinsd  | `sudo aura -S --asdeps`                         | Install packages as dependencies of another package (repositories only) |
| aurinsd | `sudo aura -A --asdeps`                         | Install packages as dependencies of another package (AUR only)          |
| auloc   | `aura -Qi`                                      | Display information about a package in the local database               |
| aulocs  | `aura -Qs`                                      | Search for packages in the local database                               |
| auls    | `aura -Qql`                                     | List all files owned by a given package                                 |
| aulst   | `aura -Qe`                                      | List installed packages including from AUR (tagged as "local")          |
| aumir   | `sudo aura -Syy`                                | Force refresh of all package lists after updating mirrorlist            |
| aurph   | `sudo aura -Oj`                                 | Remove orphans using aura                                               |
| auown   | `aura -Qqo`                                     | Search for packages that own the specified file(s)                      |
| aure    | `sudo aura -R`                                  | Remove packages, keeping its settings and dependencies                  |
| aurem   | `sudo aura -Rns`                                | Remove packages, including its settings and unneeded dependencies       |
| aurep   | `aura -Si`                                      | Display information about a package in the repositories                 |
| aurrep  | `aura -Ai`                                      | Display information about a package from AUR                            |
| aureps  | `aura -As --both`                               | Search for packages in the repositories and AUR                         |
| auras   | `aura -As --both`                               | Same as above                                                           |
| auupd   | `sudo aura -Sy`                                 | Update and refresh local package, ABS and AUR databases                 |
| auupg   | `sudo sh -c "aura -Syu              && aura -Au"` | Sync with repositories before upgrading all packages (from AUR too)   |
| ausu    | `sudo sh -c "aura -Syu --no-confirm && aura -Au --no-confirm"` | Same as `auupg`, but without confirmation                |
| upgrade[¹](#f1) | `sudo aura -Syu`                        | Sync with repositories before upgrading packages                        |

| Function        | Description                                                         |
|-----------------|---------------------------------------------------------------------|
| auownloc _file_ | Display information about a package that owns the specified file(s) |
| auownls  _file_ | List all files owned by a package that owns the specified file(s)   |

#### Pacaur

| Alias   | Command                           | Description                                                         |
|---------|-----------------------------------|---------------------------------------------------------------------|
| pain    | `pacaur -S`                       | Install packages from the repositories                              |
| pains   | `pacaur -U`                       | Install a package from a local file                                 |
| painsd  | `pacaur -S --asdeps`              | Install packages as dependencies of another package                 |
| paloc   | `pacaur -Qi`                      | Display information about a package in the local database           |
| palocs  | `pacaur -Qs`                      | Search for packages in the local database                           |
| palst   | `pacaur -Qe`                      | List installed packages including from AUR (tagged as "local")      |
| pamir   | `pacaur -Syy`                     | Force refresh of all package lists after updating mirrorlist        |
| paorph  | `pacaur -Qtd`                     | Remove orphans using pacaur                                         |
| pare    | `pacaur -R`                       | Remove packages, keeping its settings and dependencies              |
| parem   | `pacaur -Rns`                     | Remove packages, including its settings and unneeded dependencies   |
| parep   | `pacaur -Si`                      | Display information about a package in the repositories             |
| pareps  | `pacaur -Ss`                      | Search for packages in the repositories                             |
| paupd   | `pacaur -Sy`                      | Update and refresh local package, ABS and AUR databases             |
| paupg   | `pacaur -Syua`                    | Sync with repositories before upgrading all packages (from AUR too) |
| pasu    | `pacaur -Syua --no-confirm`       | Same as `paupg`, but without confirmation                           |
| upgrade[¹](#f1) | `pacaur -Syu`             | Sync with repositories before upgrading packages                    |

#### Trizen

| Alias   | Command                           | Description                                                         |
|---------|-----------------------------------|---------------------------------------------------------------------|
| trconf  | `trizen -C`                       | Fix all configuration files with vimdiff                            |
| trin    | `trizen -S`                       | Install packages from the repositories                              |
| trins   | `trizen -U`                       | Install a package from a local file                                 |
| trinsd  | `trizen -S --asdeps`              | Install packages as dependencies of another package                 |
| trloc   | `trizen -Qi`                      | Display information about a package in the local database           |
| trlocs  | `trizen -Qs`                      | Search for packages in the local database                           |
| trlst   | `trizen -Qe`                      | List installed packages including from AUR (tagged as "local")      |
| trmir   | `trizen -Syy`                     | Force refresh of all package lists after updating mirrorlist        |
| trorph  | `trizen -Qtd`                     | Remove orphans using yaourt                                         |
| trre    | `trizen -R`                       | Remove packages, keeping its settings and dependencies              |
| trrem   | `trizen -Rns`                     | Remove packages, including its settings and unneeded dependencies   |
| trrep   | `trizen -Si`                      | Display information about a package in the repositories             |
| trreps  | `trizen -Ss`                      | Search for packages in the repositories                             |
| trupd   | `trizen -Sy`                      | Update and refresh local package, ABS and AUR databases             |
| trupg   | `trizen -Syua`                    | Sync with repositories before upgrading all packages (from AUR too) |
| trsu    | `trizen -Syua --no-confirm`       | Same as `trupg`, but without confirmation                           |
| upgrade[¹](#f1) | `trizen -Syu`             | Sync with repositories before upgrading packages                    |

#### Yay

| Alias   | Command                        | Description                                                       |
|---------|--------------------------------|-------------------------------------------------------------------|
| yaconf  | `yay -Pg`                      | Print current configuration                                       |
| yain    | `yay -S`                       | Install packages from the repositories                            |
| yains   | `yay -U`                       | Install a package from a local file                               |
| yainsd  | `yay -S --asdeps`              | Install packages as dependencies of another package               |
| yaloc   | `yay -Qi`                      | Display information about a package in the local database         |
| yalocs  | `yay -Qs`                      | Search for packages in the local database                         |
| yalst   | `yay -Qe`                      | List installed packages including from AUR (tagged as "local")    |
| yamir   | `yay -Syy`                     | Force refresh of all package lists after updating mirrorlist      |
| yaorph  | `yay -Qtd`                     | Remove orphans using yay                                          |
| yare    | `yay -R`                       | Remove packages, keeping its settings and dependencies            |
| yarem   | `yay -Rns`                     | Remove packages, including its settings and unneeded dependencies |
| yarep   | `yay -Si`                      | Display information about a package in the repositories           |
| yareps  | `yay -Ss`                      | Search for packages in the repositories                           |
| yaupd   | `yay -Sy`                      | Update and refresh local package, ABS and AUR databases           |
| yaupg   | `yay -Syu`                     | Sync with repositories before upgrading packages                  |
| yasu    | `yay -Syu --no-confirm`        | Same as `yaupg`, but without confirmation                         |
| upgrade[¹](#f1) | `yay -Syu`             | Sync with repositories before upgrading packages                  |

---

<span id="f1">¹</span>
The `upgrade` alias is set for all package managers. Its value will depend on
whether the package manager is installed, checked in the following order:

1. `yay`
2. `trizen`
3. `pacaur`
4. `aura`
5. `pacman`

## Contributors

- Benjamin Boudreau - dreurmail@gmail.com
- Celso Miranda - contacto@celsomiranda.net
- ratijas (ivan tkachenko) - me@ratijas.tk
- Juraj Fiala - doctorjellyface@riseup.net
- KhasMek - Boushh@gmail.com
- Majora320 (Moses Miller) - Majora320@gmail.com
- Martin Putniorz - mputniorz@gmail.com
- MatthR3D - matthr3d@gmail.com
- ornicar - thibault.duplessis@gmail.com
- Ybalrid (Arthur Brainville) - ybalrid@ybalrid.info
- Jeff M. Hubbard - jeffmhubbard@gmail.com

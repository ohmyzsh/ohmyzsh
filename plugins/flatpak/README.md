# flatpak

### Indroduction
The (unofficial) [flatpak](https://flatpak.org) plugin that adds several aiases for managing your flatpak applications.  When executed, an alias is generated for each flatpak application installed on the system (both system and user).

### Installation
Flatpak must be installed and setup ([https://flatpak.org/setup/](https://flatpak.org/setup/))

Once flatpak is installed, add the following to your ~/.zshrc file

```plugins=(... flatpak)```

### Aliases
|Name|What|Command|
|:--:|:--:|:-----:|
|flatpaks|List all installed flatpak applications|```flatpak list --app```|
|fp-a|Show all flatpak application aliases|```alias \| grep "flatpak run"```|
|fp-alias|Show all flatpak application aliases|```fp-a```|
|fp-in|Install a flatpak application|```flatpak install```|
|fp-inu|Install a user flatpak application|```flatpak install --user```|
|fp-ls|List all installed flatpak applications|```flatpak list --app```|
|fp-lsu|List all installed user flatpak applications|```flatpak list --app --user```|
|fp-se|Search for a flatpak application|```flatpak search```|
|fp-seu|Search for a user flatpak application|```flatpak search --user```|
|fp-up|Update all flatpak applications|```flatpak update```|
|fp-upu|update user flatpak applications|```flatpak update --user```|


### Functions

#### flatpak_add_alias flatpak_application[ run_args]
Creates an alias for the application

###### Usage:
```flatpak_add_alias com.valvesoftware.Steam --user```

###### Results:
An alias named `steam` that executes ```flatpak run --user com.valvesoftware.Steam```

### Maintainer
[Robb](https://github.com/robb-randall)

[robb-randall/zsh-flatpak](https://github.com/robb-randall/zsh-flatpak)

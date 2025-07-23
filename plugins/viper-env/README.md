# Viper Env Z-Shel plugin

Automatically activates and deactivates python virtualenv upon cd in and out.

## Features

- **Automatic Activation/Deactivation:** Finds and manages virtualenvs in your project directories as you `cd`.
- **Upward Search:** Works even if you are in a subdirectory of your project.
- **Plays Well With Others:** If a `viper-env` managed environment is active and you `cd` into a new project, it will correctly deactivate the old one before activating the new one.
- **Convenient Manual Activation:** When autoloading is disabled, an `activate` alias is automatically made available in project directories, giving you explicit control.
- **State-Aware:** Only deactivates environments that it has activated, so it won't interfere when you leave a project that uses another tool.
- **Configurable Autoloading:** Easily enable or disable the automatic activation/deactivation feature.
- **Diagnostic Commands:** Supports a quiet mode and provides `list`, `status`, and `version` commands for diagnostics.

## Inspiration

Based on [blueray](https://stackoverflow.com/users/1772898/blueray)'s [answer](https://stackoverflow.com/a/63955939/11685534), I decided to go one step further and implement it as a Z-Shell plugin.

## Usage
<!-- [![asciicast](https://asciinema.org/a/4iMwcKfBS1dc1EgI1FihrDVxT.svg)](https://asciinema.org/a/4iMwcKfBS1dc1EgI1FihrDVxT) -->

![Alt text](./make_animation/assets/final.svg)

## Usage

### Automatic Mode (Default)

By default, `viper-env` is configured for a seamless experience. It uses a `precmd` hook that runs before each prompt, allowing it to activate virtual environments immediately upon creation or when you enter a project directory.

```zsh
# Create a new project and cd into it
mkdir my-project && cd my-project

# Create a virtual environment
python -m venv .venv
# -> Activating virtual environment .venv

# Go to a subdirectory
mkdir src && cd src
# -> ".venv" stays active

# Leave the project directory
cd ../..
# -> viper-env automatically deactivates ".venv"
```

## Configuration

### Using External Virtual Environments (Semi-Automatic Mode)

> [!TIP]
> For projects where you prefer to keep the virtual environment directory outside of the project folder (e.g., in `~/.virtualenvs/`), you can use the semi-automatic mode.
>
> Create a file named `.viper-env` in your project's root directory and place the **absolute path** to your virtual environment in it.
>
> ```sh
> # Example: Tell viper-env to use the 'my-project-venv' environment for this project
> echo "/home/user/.virtualenvs/my-project-venv" > .viper-env
> ```
> `viper-env` will prioritize this file over automatically discovered venvs.

### Disabling and Enabling Autoloading

If you wish to temporarily disable the automatic activation and deactivation behavior, you can use the `autoload --disable` command. This acts as a master switch.

```zsh
viper-env autoload --disable
```

With autoloading disabled, `viper-env` will not perform any actions as you change directories. You can re-enable the automatic behavior at any time:

```zsh
viper-env autoload --enable
```

## Instalation

### Oh my Zsh

Git clone this repository to the Oh my Zsh custom plugins folder.

Add plugin to plugins directive in `~/.zshrc`
```zsh
plugins=(
  # put local oh-my-zsh plugins here
  viper-env
)

source $HOME/.oh-my-zsh/oh-my-zsh.sh
```

### Antigen
It is recommended to use a `.antigenrc` file. Then add the following to it:

```zsh
antigen bundle DanielAtKrypton/viper-env

# Apply changes
antigen apply
```

Make sure in your `.zshrc` Antigen is loading the `.antigenrc` file as follows:
```zsh
antigen init ~/.antigenrc
```

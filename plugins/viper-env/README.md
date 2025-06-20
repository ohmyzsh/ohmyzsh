# Viper Env Z-Shel plugin

Automatically activates and deactivates python virtualenv upon cd in and out.

## Inspiration

Based on [blueray](https://stackoverflow.com/users/1772898/blueray)'s [answer](https://stackoverflow.com/a/63955939/11685534), I decided to go one step further and implement it as a Z-Shell plugin.

## Usage
<!-- [![asciicast](https://asciinema.org/a/4iMwcKfBS1dc1EgI1FihrDVxT.svg)](https://asciinema.org/a/4iMwcKfBS1dc1EgI1FihrDVxT) -->

![Alt text](./make_animation/assets/final.svg)

## Example
```zsh
> viper-env help

Description:
  Automatically activates and deactivates python virtualenv upon cd in and out.

Dependencies:
  - zsh
  - python
  - `brew install coreutils` (macOS only)

Example usage:
  # Create virtual environment
  python -m venv .venv
  # Save current dir
  current_dir=$(basename $PWD)
  # Exit current directory
  cd ..
  # Reenter it
  cd $current_dir
```

## Instalation

### Oh my Zsh

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
antigen bundle viper-env

# Apply changes
antigen apply
```

Make sure in your `.zshrc` Antigen is loading the `.antigenrc` file as follows:
```zsh
antigen init ~/.antigenrc
```
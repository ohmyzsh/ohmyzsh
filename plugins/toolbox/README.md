# Toolbox plugin

Plugin for [toolbox](https://containertoolbx.org), a tool to use containerized CLI environments.

To use it, add `toolbox` to the plugins array in your `zshrc` file:

```zsh
plugins=(... toolbox)
```

## Prompt function

This plugins adds `toolbox_prompt_info()` function. Using it in your prompt, it will show the toolbox indicator ⬢ (if you are running in a toolbox container), and nothing if not.

You can use it by adding `$(toolbox_prompt_info)` to your `PROMPT` or `RPROMPT` variable:

```zsh
RPROMPT='$(toolbox_prompt_info)'
```

## Aliases

| Alias | Command              | Description                            |
|-------|----------------------|----------------------------------------|
| tb    | `toolbox enter`      | Enters the toolbox environment         |
=======
## Usage

The plugin allows to automatically enter toolboxes on `cd` into git
repositories. It will use the default container defined in
`TOOLBOX_DEFAULT_CONTAINER`. It will set the hostname of the container to the
container name and set a ⬢ in front of the prompt to indicated that you
are in a toolbox.

```
➜  github $ cd ansible
⬢ (default) ➜  ansible git:(devel) $ cd docs
⬢ (default) ➜  docs git:(devel) $ cd ..
⬢ (default) ➜  ansible git:(devel) $ cd ..
➜  github $
```

We can override this by having a `.toolbox` file in the directory containing a differently named container:

```
➜  github $ cat ansible/.toolbox
my-toolbox
➜  github $ cd ansible
⬢ (my-toolbox) ➜  ansible git:(devel) $ cd ..
➜  github $
```

You can disable this behavior by setting `DISABLE_TOOLBOX_ENTER=1` before Oh My ZSH is sourced:
```zsh
DISABLE_TOOLBOX_ENTER=1
plugins=(... toolbox)
source $ZSH/oh-my-zsh.sh
```

Toolboxes are exited when leaving a git repository. You can disable this behavior by setting `DISABLE_TOOLBOX_EXIT=1`.

You can specify which image should be used as a default by setting `TOOLBOX_DEFAULT_IMAGE=ghcr.io/mikebarkmin/fedora-toolbox:35`.

For this plugin to work your container must have `zsh` installed. You can used this image `ghcr.io/mikebarkmin/fedora-toolbox:35` which comes preinstalled with `zsh` and `neovim`.

## Aliases

There are some convenient aliases which make for example use of the `TOOLBOX_DEFAULT_IMAGE` when set.

| alias | command | comment |
| ----- | ------- | ------- |
| tb | toolbox | |
| tbi | echo $TOOLBOX_DEFAULT_CONTAINER > .toolbox && toolbox_cwd | |
| tbc | toolbox create --image $TOOLBOX_DEFAULT_IMAGE | |
| tbe | toolbox enter | This is context aware |
| tbrm | toolbox rm | |
| tbrmi | toolbox rmi | |
| tbl | toolbox list | |
| tbr | toolbox run | This is context aware |


## Theme Integration
In most themes you can see the hostname (`user_host`), which is set by this plugin for each container, so there is no additional setup needed.

Additionally, the plugin provides a prompt function with can be used in a theme to display a hexagon to indicated that you are in a toolbox.

Here is an example of a modified `bira` theme:

```zsh
...
local toolbox_prompt='$(toolbox_prompt_info)'

PROMPT="╭─${toolbox_prompt}${user_host}${current_dir}${rvm_ruby}${git_branch}${venv_prompt}
╰─%B${user_symbol}%b "
...
```

## Advanced Setup

This plugin works great with vscode, if you use this [toolbox-vscode](https://github.com/owtaylor/toolbox-vscode).

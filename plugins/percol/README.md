## percol

**Maintainer:** [@robturtle](https://github.com/robturtle)

It provides two functionalities that allow you search history and resume
background jobs with interactively incremental searching utility powered by
[Percol](https://github.com/mooz/percol).

### Usage

1. Use `Ctrl-R` to search the history.

  ![interactively search history](https://www.dropbox.com/s/2ke80q5uswz7sqf/percol.plugin1.gif?raw=1)

2. Use `Ctrl-Q` to resume background jobs.

  ![interactively resume background jobs](https://www.dropbox.com/s/u5t5l7jeznv06y8/percol.plugin2.gif?raw=1)

### Installation

1. [Install percol](https://github.com/mooz/percol) from pip:

  ```
  pip install percol
  ```

2. Enable the plugin by adding it to your `plugins` definition in `~/.zshrc`:

  ```
  plugins=(percol)
  ```

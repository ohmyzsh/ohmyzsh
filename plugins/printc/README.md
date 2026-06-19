# printc

With this plugin you can print any color within the rgb color space via an interface that
is as simple as a regular print statement.

This simple tool provides an abstraction layer on top of terminal ANSI rgb escape codes,
making the addition of colorized output to your functions, shell scripts, and/or
interactive terminal in zsh a piece of cake. There is support for any of the colors which
can be achieved via the form R G B, where R, G and B are any numeric value
between 0 and 255, representing the red, green, blue color space values respectively.
Users of this plugin are able to issue a  `printc` statement, followed by the previous
mentioned rgb values, followed by the text to be printed. There is also 36 built in colors
which can be accessed via tab auto-complete. And there is support for bold, italic, and
underline text.

![screenshot](https://imgur.com/K0FVGzr.png)


#### Table of Contents
 - [Setup](#Setup)
 - [Configuration](#Configuration)
    - [Requirements](#Requirements)
    - [Italics Setup](#Italics-Setup)
 - [Usage](#Usage)
    - [Options](#Options)
    - [General Structure of Command](#General-Structure-of-Command)
 - [Notes on Environment Setup and Script Usage](#Notes-on-Environment-Setup-and-Script-Usage)


## Setup
To use, add printc to the plugins array inside your `~/.zshrc` file:
```
plugins=(... printc)
```
## Configuration

### Requirements
Your terminal emulator must support 256 color. If you want to leverage italic text,
depending on your terminal emulator you will likely need to add support for displaying
italic text. The process is very simple, and I'll include instruction on how to do so. As
long as your terminal emulator supports, and is set up for 256 color, which almost all are
now-a-days, you can use the color aspect of the plugin, even without the italic
functionality.

At the least your TERM environment variable must be set as so:
```
export TERM=xterm-256color
```

It is possible that this is all that will be needed for the italic functionality to work
as well. I do recommend trying and seeing if italics work. It it does not, just follow the
simple steps below.

### Italics Setup
 1) Create a directory `~/.terminfo`

 2) Create a file inside `~/.terminfo` called `xterm-256color-italics.terminfo`

 3) Place the following contents inside `xterm-256color-italics.terminfo` *exactly* as
 they are shown:

 ```
 xterm-256color-italic|xterm with 256 colors and italic,
 sitm=\E[3m, ritm=\E[23m,
 use=xterm-256color,
 ```

 4) Inside `~/.terminfo` run the command `tic xterm-256color-italics.terminfo`

 5) Set your TERM environment variable as so:
 ```
 export TERM=xterm-256color-italic
 ```
 You can export TERM in your `~/.zshrc` or `~/.zshenv` or many other ways. If you're an
 iTerm2 user you can do it through the GUI terminal emulator settings there. It doesn't
 matter how you do it, as long as the TERM environment variable is set and exported to
 one of the above mentioned values, most likely the latter if you want italics.

 As an aside, I have not tested this inside TMUX, but it should work there as long as the
 environment is set up to properly handle color and italics.

# Usage

### Options
  | Option              | Function               |
  | :-----------------: | --------------         |
  | -b                  | Bold                   |
  | -u                  | Underline              |
  | -i                  | Italic                 |
  | -C `color`          | Specify built in color |
  | -l                  | List built in colors   |
  | -n                  | No newline             |
  | -h                  | Display help page      |

### General Structure of Command
 * `printc [-b] [-u] [-i] [-n] <0-255> <0-255> <0-255> "Colorized Text to Display"`
     * This is the structure used when specifying a color with RGB values.
     * Note the absense of quotes around the RGB numbers, this is required.
     * Note the inclusion of quotes around the intended output, also required.
         * As usual double quotes will allow parameter expansion.
     * The RGB values must come after any options, and before the intended output.
 * `printc [-b] [-u] [-i] [-n]> -C <built in color> "Colorized Text to Display"`
     * This is the structure used when specifying a color that is built in to the plugin.
     * Quoting the intended output is not required when using built in color options.
 * Options can be given in any order, and chained together, such as
 `-buinC <built in color>`, so long as `built in color` follows immediately after `-C`,
 and in the case of using RGB values, they must come after any options that are given.

# Notes on Environment Setup and Script Usage
 Immediately after setup, the `printc` command will be available to use
 interactively, or inside aliases and functions. You can create nice colorized, formatted
 text for your output. In order to be used inside ZSH scripts, you will need to make the
 `printc` tool available outside of your current shell. One easy way to do this is to add
 the following lines to your `~/.zshenv` file.

 ```
 fpath=($HOME/.oh-my-zsh/plugins/printc $fpath)'
 ZSH=$HOME/.oh-my-zsh/'
 ```
 The first line makes the plugin itself available to shells that are forked from your
 interactive session, and the second line is an environment variable provided by OMZ,
 which is referenced inside of the `printc` plugin, and therefore needs to be exposed to
 children shells who want access to the tool. This can be done manually, or there is an
 included script, called `setup.sh` which will set everything up automatically if ran. It
 only needs to be ran once.

 And finally, any script that uses the `printc` command will have to include the line
 `autoload -Uz printc` near the top.

 If you only want to use `printc` interactively, and/or inside functions and aliases, then
 the above environment setup is not needed.


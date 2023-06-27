# englizsh
A zsh plugin that defines 4 keybindings to intuitively interface with any command-line GPT program. The idea is to toggle the contents of the shell buffer between natural language and shell command and directly execute natural language using GPT as the translator.

## Usage

1. Control + Space: Toggles the buffer between English and command. Assumes the buffer contains a command if the first word is a valid command according to `command -v`.

https://github.com/chinarjoshi/englizsh/assets/68311366/b1644a84-e3d8-41b3-b392-826f3350b22d

2. Alt + Space: Explicitly translates the buffer from English to command. Useful when the first word is a command, for instance when you're typing a command but forgot some flags.

https://github.com/chinarjoshi/englizsh/assets/68311366/3cefd48e-1f51-4d77-b07a-97e95597e54c
   
3. Enter: Executes commands normally, but if command is not found and there appears to be English in the buffer, then it is translated to shell before executing.

https://github.com/chinarjoshi/englizsh/assets/68311366/1090127c-c863-4b4b-8f71-51dda7f00423

4. Control + Enter: Explicitly translates the buffer from English to command and executes it. Useful when you know you're executing English but it doesn't appear like it.

https://github.com/chinarjoshi/englizsh/assets/68311366/e68fbe10-1230-485c-83ff-4d1deba02bd9

## Configuration

Englizsh can be configured through the following environmental variables before the script is sourced:

* `ENGLISH_TO_SHELL_CMD`: Command that translates natural language to shell command. Default: `sgpt --shell`
* `SHELL_TO_ENGLISH_CMD`: Command that translates shell command to natural language. Default: `sgpt --describe-shell`
* `ENGLIZSH_SAFE_CMD_NO_CONFIRM`: If true, executes non-destructive commands without prompting for confirmation
* `ENGLIZSH_DEFAULT_EXECUTE`: If true, entering nothing when prompted for confirmation executes the command by default
* `TOGGLE_BUFFER_KEYBINDING`: Keycode for function 1. Default: `^@`
* `TOGGLE_ENGLISH_KEYBINDING`: Keycode for function 2. Default: `^[@`
* `EXECUTE_ENGLISH_KEYBINDING`: Keycode for function 4. Default: `^[[27;5;13~`


**Tip:** If your GPT program does not already have options to produce or describe shell commands, you can use the following prompts:

<details>
<summary>English to shell prompt</summary>
<br>
Provide only {YOUR SHELL} commands for {YOUR OS} without any description.
If there is a lack of details, provide most logical solution.
Ensure the output is a valid shell command.
If multiple steps required try to combine them together.
</details>

<details>
<summary>Shell to English prompt</summary>
<br>
Provide a terse, single sentence description of the given shell command.
IMPORTANT: Do NOT start with 'This command ...', instead start with a verb.
Use the following example:
Command: du -cks
Answer: List the total disk usage of the current directory and its subdirectories in kilobytes
</details>


**Tip:** To find the keycode for the keybinding you wish to use, enter `Control + v` in zsh followed by the keybinding.

## Installation

### Manually

1. Download/update the script to `~/.englizsh` with curl:

`curl https://raw.githubusercontent.com/chinarjoshi/englizsh/main/englizsh > ~/.englizsh`

2. Source the script in your zshrc, assuming it is in your home directory.

`echo '. ~/.englizsh' >> ~/.zshrc`

----------

Special thanks to @TheR1D for feedback while developing this.

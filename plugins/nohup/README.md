## nohup

Add `nohup` to the current command pressing the `Ctrl + H` shortcut

### Usage

 * If the command line is `test 1 2 3` it will be transformed to `nohup test 1 2 3 &> test.out &!` (and vice-versa).

 * If the command line is empty, the last command will be recalled.

PS. If you use `zsh-syntax-highlighting`, be sure that it is the last in the plugins list

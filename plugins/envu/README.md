# ENVU

This plugin adds `envu` command that updates environment variables

To use it u need to add in your `.zshrc`:

 - `plugins=(... envu)`
 - `export ENVU_PATH="$ZSH/plugins/envu"`
 - `source $ENVU_PATH/envs`

Usage: `envu [ENV VARIABLE NAME] [VALUE]`

Example: `envu PATH $HOME/program`

Note: ":" is automatically added if PATH variable is detected
# Path to oh-my-zsh.
OMZ="$HOME/.oh-my-zsh"

# Set the key mapping style to 'emacs' or 'vi'.
KEYMAP='emacs'

# Set case-sensitivity for completion, history lookup, etc.
CASE_SENSITIVE='false'

# Color output (auto set to 'false' on dumb terminals).
COLOR='true'

# Auto set the tab and window titles.
AUTO_TITLE='true'

# Auto convert .... to ../..
DOT_EXPANSION='false'

# Indicate that completions are being generated.
COMPLETION_INDICATOR='false'

# Set the plugins to load (see $OMZ/plugins/).
# Example: plugins=(git lighthouse rails ruby textmate)
plugins=(git)

# This will make you scream: OH MY ZSH!
source "$OMZ/init.zsh"

# Load the prompt theme (type prompt -l to list all themes).
# Setting it to 'random' loads a random theme.
[[ "$TERM" != 'dumb' ]] && prompt sorin || prompt off

# Customize to your needs...


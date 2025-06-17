Fish-like fast/unobtrusive autosuggestions for zsh.
It suggests commands as you type based on history and completions.
Requirements: Zsh v4.3.11 or later

If you press the → key (forward-char widget) or End (end-of-line widget) with the cursor at the end of the buffer, it will accept the suggestion, replacing the contents of the command line buffer with the suggestion.

If you invoke the forward-word widget, it will partially accept the suggestion up to the point that the cursor moves to.

### Key Bindings

This plugin provides a few widgets that you can use with `bindkey`:

1. `autosuggest-accept`: Accepts the current suggestion.
2. `autosuggest-execute`: Accepts and executes the current suggestion.
3. `autosuggest-clear`: Clears the current suggestion.
4. `autosuggest-fetch`: Fetches a suggestion (works even when suggestions are disabled).
5. `autosuggest-disable`: Disables suggestions.
6. `autosuggest-enable`: Re-enables suggestions.
7. `autosuggest-toggle`: Toggles between enabled/disabled suggestions.

For example, this would bind <kbd>ctrl</kbd> + <kbd>space</kbd> to accept the current suggestion.

```sh
bindkey '^ ' autosuggest-accept
```


As you type commands, you will see a completion offered after the cursor

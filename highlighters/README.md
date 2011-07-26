zsh-syntax-highlighting / highlighters
======================================

Syntax highlighting is done by pluggable highlighters:

* [***main***](highlighters/main) - the base highlighter, and the only one active by default.
* [***brackets***](highlighters/brackets) - matches brackets and parenthesis.
* [***pattern***](highlighters/pattern) - matches user-defined patterns.
* [***cursor***](highlighters/cursor) - matches the cursor position.
* [***root***](highlighters/root) - triggered if the current user is root.


How to activate highlighters
----------------------------

To activate an highlighter, add it to the `ZSH_HIGHLIGHT_HIGHLIGHTERS` array in `~/.zshrc`, for example:

    ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor)


How to tweak highlighters
-------------------------

Highlighters look up styles from the `ZSH_HIGHLIGHT_STYLES` array. Navigate into each highlighter directory to see what styles it defines and how to configure it.


How to implement a new highlighter
----------------------------------

To create your own ***myhighlighter*** highlighter:

* Create your script at **highlighters/*myhighlighter*/*myhighlighter*-highlighter.zsh**.
* Implement the `_zsh_highlight_myhighlighter_highlighter_predicate` function. This function must return 0 when the highlighter needs to be called, for example:

        _zsh_highlight_myhighlighter_highlighter_predicate() {
          # Call this highlighter in SVN repositories
          [[ -d .svn ]]
        }

* Implement the `_zsh_highlight_myhighlighter_highlighter` function. This function does the actual syntax highlighting, by modifying `region_highlight`, for example:

        _zsh_highlight_myhighlighter_highlighter() {
          # Colorize the whole buffer with blue background
          region_highlight+=(0 $#BUFFER bg=blue)
        }

* Activate your highlighter in `~/.zshrc`:

        ZSH_HIGHLIGHT_HIGHLIGHTERS+=(myhighlighter)

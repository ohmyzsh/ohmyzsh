# Changelog

## v0.7.0
- Enable asynchronous mode by default (#498)
- No longer wrap user widgets starting with `autosuggest-` prefix (#496)
- Fix a bug wrapping widgets that modify the buffer (#541)


## v0.6.4
- Fix `vi-forward-char` triggering a bell when using it to accept a suggestion (#488)
- New configuration option to skip completion suggestions when buffer matches a pattern (#487)
- New configuration option to ignore history entries matching a pattern (#456)

## v0.6.3
- Fixed bug moving cursor to end of buffer after accepting suggestion (#453)

## v0.6.2
- Fixed bug deleting the last character in the buffer in vi mode (#450)
- Degrade gracefully when user doesn't have `zsh/system` module installed (#447)

## v0.6.1
- Fixed bug occurring when `_complete` had been aliased (#443)

## v0.6.0
- Added `completion` suggestion strategy powered by completion system (#111)
- Allow setting `ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE` to an empty string (#422)
- Don't fetch suggestions after copy-earlier-word (#439)
- Allow users to unignore zle-\* widgets (e.g. zle-line-init) (#432)


## v0.5.2
- Allow disabling automatic widget re-binding for better performance (#418)
- Fix async suggestions when `SH_WORD_SPLIT` is set
- Refactor async mode to use process substitution instead of zpty (#417)

## v0.5.1
- Speed up widget rebinding (#413)
- Clean up global variable creations (#403)
- Respect user's set options when running original widget (#402)

## v0.5.0
- Don't overwrite config with default values (#335)
- Support fallback strategies by supplying array to suggestion config var
- Rename "default" suggestion strategy to "history" to name it based on what it actually does
- Reset opts in some functions affected by `GLOB_SUBST` (#334)
- Support widgets starting with dashes (ex: `-a-widget`) (#337)
- Skip async tests in zsh versions less than 5.0.8 because of reliability issues
- Fix handling of newline + carriage return in async pty (#333)


## v0.4.3
- Avoid bell when accepting suggestions with `autosuggest-accept` (#228)
- Don't fetch suggestions after [up,down]-line-or-beginning-search (#227, #241)
- We are now running CI against new 5.5.1 version
- Fix partial-accept in vi mode (#188)
- Fix suggestion disappearing on fast movement after switching to `vicmd` mode (#290)
- Fix issue rotating through kill ring with `yank-pop` (#301)
- Fix issue creating new pty for async mode when previous pty is not properly cleaned up (#249)

## v0.4.2
- Fix bug in zsh versions older than 5.0.8 (#296)
- Officially support back to zsh v4.3.11

## v0.4.1
- Switch to [[ and (( conditionals instead of [ (#257)
- Avoid warnnestedvar warnings with `typeset -g` (#275)
- Replace tabs with spaces in yaml (#268)
- Clean up and fix escaping of special characters (#267)
- Add `emacs-forward-word` to default list of partial accept widgets (#246)

## v0.4.0
- High-level integration tests using RSpec and tmux
- Add continuous integration with Circle CI
- Experimental support for asynchronous suggestions (#170)
- Fix problems with multi-line suggestions (#225)
- Optimize case where manually typing in suggestion
- Avoid wrapping any zle-\* widgets (#206)
- Remove support for deprecated options from v0.0.x
- Handle history entries that begin with dashes
- Gracefully handle being sourced multiple times (#126)
- Add enable/disable/toggle widgets to disable/enable suggestions (#219)


## v0.3.3
- Switch from $history array to fc builtin for better performance with large HISTFILEs (#164)
- Fix tilde handling when extended_glob is set (#168)
- Add config option for maximum buffer length to fetch suggestions for (#178)
- Add config option for list of widgets to ignore (#184)
- Don't fetch a new suggestion unless a modification widget actually modifies the buffer (#183)

## v0.3.2
- Test runner now supports running specific tests and choosing zsh binary
- Return code from original widget is now correctly passed through (#135)
- Add `vi-add-eol` to list of accept widgets (#143)
- Escapes widget names within evals to fix problems with irregular widget names (#152)
- Plugin now clears suggestion while within a completion menu (#149)
- .plugin file no longer relies on symbolic link support, fixing issues on Windows (#156)

## v0.3.1

- Fixes issue with `vi-next-char` not accepting suggestion (#137).
- Fixes global variable warning when WARN_CREATE_GLOBAL option enabled (#133).
- Split out a separate test file for each widget.

## v0.3.0

- Adds `autosuggest-execute` widget (PR #124).
- Adds concept of suggestion "strategies" for different ways of fetching suggestions.
- Adds "match_prev_cmd" strategy (PR #131).
- Uses git submodules for testing dependencies.
- Lots of test cleanup.
- Various bug fixes for zsh 5.0.x and `sh_word_split` option.


## v0.2.17

Start of changelog.

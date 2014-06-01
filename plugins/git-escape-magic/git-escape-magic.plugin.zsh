# Automatically detect and escape zsh globbing meta-characters when used with
# git refspec characters like `[^~{}]`. NOTE: This must be loaded _after_
# url-quote-magic.
#
# This trick is detailed at https://github.com/knu/zsh-git-escape-magic and is
# what allowed this plugin to exist.

autoload -Uz git-escape-magic
git-escape-magic

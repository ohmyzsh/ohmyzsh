alias brews='brew list -1'
alias bubo='brew update && brew outdated'
alias bubc='brew upgrade && brew cleanup'
alias bubu='bubo && bubc'

if mkdir "$ZSH_CACHE_DIR/.brew-completion-message" 2>/dev/null; then
	print -P '%F{yellow}'Oh My Zsh brew plugin:
	cat <<-'EOF'

		  With the advent of their 1.0 release, Homebrew has decided to bundle
		  the zsh completion as part of the brew installation, so we no longer
		  ship it with the brew plugin; now it only has brew aliases.

		  If you find that brew completion no longer works, make sure you have
		  your Homebrew installation fully up to date.

		  You will only see this message once.
	EOF
	print -P '%f'
fi

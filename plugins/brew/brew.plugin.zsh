alias bc="brew cleanup"
alias bci="brew cask info"
alias bcl="brew cask list"
alias bco="brew cask outdated"
alias bcu="brew cask upgrade"
alias bl="brew list"
alias bo="brew outdated"
alias bu="brew update"
alias brewp='brew pin'
alias brews='bl -1'
alias brewsp='bl --pinned'
alias bubo='bu && bo'
alias bubc='brew upgrade && bc'
alias bubu='bubo && bubc'
alias bcubo='bu && bco'
alias bubobco='bubo && bco'
alias bcubc='brew cask reinstall $(bco) && bc'

if command mkdir "$ZSH_CACHE_DIR/.brew-completion-message" 2>/dev/null; then
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

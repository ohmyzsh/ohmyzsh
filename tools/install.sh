#!/bin/sh
#
# This script should be run via curl:
#   sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
# or wget:
#   sh -c "$(wget -qO- https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
#
# As an alternative, you can download the install script separately and
# run it afterwards with `sh install.sh'
#
set -e

# Default location
ZSH=${ZSH:-~/.oh-my-zsh}

command_exists() {
	command -v "$@" >/dev/null 2>&1
}

error() {
	echo "Error: $@" >&2
}

# Set up color sequences
setup_color() {
	if command_exists tput; then
		ncolors=$(tput colors)
	else
		ncolors=0
	fi

	# Only use colors if connected to a terminal that supports them
	if [ -t 1 ] && [ $ncolors -ge 8 ]; then
		RED="$(tput setaf 1)"
		GREEN="$(tput setaf 2)"
		YELLOW="$(tput setaf 3)"
		BLUE="$(tput setaf 4)"
		BOLD="$(tput bold)"
		NORMAL="$(tput sgr0)"
	else
		RED=""
		GREEN=""
		YELLOW=""
		BLUE=""
		BOLD=""
		NORMAL=""
	fi
}

setup_ohmyzsh() {
	# Prevent the cloned repository from having insecure permissions. Failing to do
	# so causes compinit() calls to fail with "command not found: compdef" errors
	# for users with insecure umasks (e.g., "002", allowing group writability). Note
	# that this will be ignored under Cygwin by default, as Windows ACLs take
	# precedence over umasks except for filesystems mounted with option "noacl".
	umask g-w,o-w

	echo "${BLUE}Cloning Oh My Zsh...${NORMAL}"

	command_exists git || {
		error "git is not installed"
		exit 1
	}

	if [ "$OSTYPE" = cygwin ] && git --version | grep -q msysgit; then
		error "Windows/MSYS Git is not supported on Cygwin"
		error "Make sure the Cygwin git package is installed and is first on the \$PATH"
		exit 1
	fi

	git clone --depth=1 https://github.com/robbyrussell/oh-my-zsh.git "$ZSH" || {
		error "git clone of oh-my-zsh repo failed"
		exit 1
	}
}

setup_zshrc() {
	echo "${BLUE}Looking for an existing zsh config...${NORMAL}"
	if [ -f ~/.zshrc ] || [ -h ~/.zshrc ]; then
		echo "${YELLOW}Found ~/.zshrc.${GREEN} Backing up to ~/.zshrc.pre-oh-my-zsh.${NORMAL}"
		mv ~/.zshrc ~/.zshrc.pre-oh-my-zsh
	fi

	echo "${BLUE}Using the Oh My Zsh template file and adding it to ~/.zshrc.${NORMAL}"

	cp "$ZSH/templates/zshrc.zsh-template" ~/.zshrc
	sed "/^export ZSH=/ c\\
export ZSH=\"$ZSH\"
" ~/.zshrc > ~/.zshrc-omztemp
	mv -f ~/.zshrc-omztemp ~/.zshrc
}

setup_shell() {
	# If this user's login shell is not already "zsh", attempt to switch.
	TEST_CURRENT_SHELL=$(basename "$SHELL")
	if [ "$TEST_CURRENT_SHELL" != "zsh" ]; then
		# If this platform provides a "chsh" command (not Cygwin), do it, man!
		if command_exists chsh; then
			echo "${BLUE}Time to change your default shell to zsh!${NORMAL}"
			if ! chsh -s $(grep /zsh$ /etc/shells | tail -1); then
				error "chsh command unsuccessful. Change your default shell manually."
			fi
		# Else, suggest the user do so manually.
		else
			cat <<-EOF
				I can't change your shell automatically because this system does not have chsh.
				${BLUE}Please manually change your default shell to zsh${NORMAL}
			EOF
		fi
	fi
}

main() {
	setup_color

	if ! command_exists zsh; then
		echo "${YELLOW}Zsh is not installed.${NORMAL} Please install zsh first."
		exit 1
	fi

	if [ -d "$ZSH" ]; then
		cat <<-EOF
			${YELLOW}You already have Oh My Zsh installed.${NORMAL}
			You'll need to remove '$ZSH' if you want to reinstall.
		EOF
		exit 1
	fi

	setup_ohmyzsh
	setup_zshrc
	setup_shell

	printf "$GREEN"
	cat <<-'EOF'
		         __                                     __
		  ____  / /_     ____ ___  __  __   ____  _____/ /_
		 / __ \/ __ \   / __ `__ \/ / / /  /_  / / ___/ __ \
		/ /_/ / / / /  / / / / / / /_/ /    / /_(__  ) / / /
		\____/_/ /_/  /_/ /_/ /_/\__, /    /___/____/_/ /_/
		                        /____/                       ....is now installed!


		Please look over the ~/.zshrc file to select plugins, themes, and options.

		p.s. Follow us on https://twitter.com/ohmyzsh

		p.p.s. Get stickers, shirts, and coffee mugs at https://shop.planetargon.com/collections/oh-my-zsh

	EOF
	printf "$NORMAL"

	exec zsh -l
}

main

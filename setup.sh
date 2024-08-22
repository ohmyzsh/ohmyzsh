#!/bin/bash

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check and install prerequisites
install_prerequisites() {
    if ! command_exists zsh; then
        echo "Installing Zsh..."
        if command_exists apt-get; then
            sudo apt-get update && sudo apt-get install -y zsh
        elif command_exists yum; then
            sudo yum install -y zsh
        elif command_exists brew; then
            brew install zsh
        else
            echo "Error: Unable to install Zsh. Please install it manually."
            exit 1
        fi
    fi

    if ! command_exists git; then
        echo "Installing Git..."
        if command_exists apt-get; then
            sudo apt-get update && sudo apt-get install -y git
        elif command_exists yum; then
            sudo yum install -y git
        elif command_exists brew; then
            brew install git
        else
            echo "Error: Unable to install Git. Please install it manually."
            exit 1
        fi
    fi

    if ! command_exists curl; then
        echo "Installing curl..."
        if command_exists apt-get; then
            sudo apt-get update && sudo apt-get install -y curl
        elif command_exists yum; then
            sudo yum install -y curl
        elif command_exists brew; then
            brew install curl
        else
            echo "Error: Unable to install curl. Please install it manually."
            exit 1
        fi
    fi
}

# Install Oh My Zsh
install_oh_my_zsh() {
    echo "Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
}

# Set Zsh as default shell
set_zsh_default() {
    echo "Setting Zsh as default shell..."
    chsh -s $(which zsh)
}

# Main function
main() {
    install_prerequisites
    install_oh_my_zsh
    set_zsh_default
    echo "Oh My Zsh installation complete! Please restart your terminal or run 'zsh' to start using it."
}

# Run the main function
main

# Terraform plugin to display workspace in prompt

Plugin for Terraform from Hashicorp, an infrastructure as code tool that allows for multi-cloud support, modularity, 
and the ability to plan and apply changes, making it easier to manage and provision infrastructure resources.

## Features:
- Completion for `terraform`
- aliases
- prompt function
- Support for agnoster template

## Structure:
```sh
.
├── README.md
├── plugins
    ├── _terraform
    └── terraform-workspace.plugin.zsh
```

## Requirements
* [zsh](http://www.zsh.org/)
* [Terraform](https://terraform.io/)
* [oh-my-zsh](https://github.com/ohmyzsh/ohmyzsh)
* [terraform-workspace plugin](https://github.com/ocontant/terraform-workspace)
* [terraform-workspace themes](https://github.com/ocontant/terraform-agnoster)

# Installation:
## Manual
1. Clone the repository to your localspace
   - `git clone https://github.com/ocontant/terraform-workspace.git`
2. Copy the plugins folder to ~/.oh-my-zsh/custom/plugins/terraform-workspace
   - `cp -r plugins/terraform-workspace ~/.oh-my-zsh/custom/plugins/terraform-workspace`
3. Copy the themes folder to ~/.oh-my-zsh/custom/themes/agnoster
   - `cp -r themes/agnoster ~/.oh-my-zsh/custom/themes/agnoster`
4. Add the plugin `terraform-workspace` to your plugins array section of your `~/.zshrc` file
    - `plugins=(... terraform-workspace)`
5. Add the theme `terraform-agnoster` to your theme section of your `~/.zshrc` file

## With Antigen
1. Install Antigen:
   - `curl -L git.io/antigen > ~/antigen.zsh`
2. Add antigen requirements to your `~/.zshrc` file
```sh
  source ~/antigen.zsh 
  # Load Antigen configurations 
  antigen init ~/.antigenrc
```
3. Create the file ~/.antigenrc and add the following content (I included my favorite bundle, feel free to add/remove):
```sh
  # Load oh-my-zsh library
  antigen use oh-my-zsh

  # Load bundles from the default repo (oh-my-zsh)
  antigen bundle git
  antigen bundle command-not-found
  antigen bundle docker

  # Load bundles from external repos
  antigen bundle zsh-users/zsh-completions
  antigen bundle zsh-users/zsh-autosuggestions
  antigen bundle zsh-users/zsh-syntax-highlighting
  antigen bundle zsh-users/zsh-history-substring-search
  
  # Load the terraform plugins and theme
  antigen bundle ocontant/terraform-workspace
  antigen theme ocontant/terraform-agnoster

  # Tell Antigen that you're done.
  antigen apply
```
4. Add the theme `terraform-agnoster` to your theme section of your `~/.zshrc` file
5. Add the plugin `terraform-workspace` to your plugins array section of your `~/.zshrc` file
    - `plugins=(... terraform-workspace)`


# Prompt function
## If you don't want to use oh-my-zsh agnoster theme, you can use this prompt to display the current Terraform workspace in your prompt.

1. Create a bloc in your `~/.zshrc` file:
```sh
# Terraform prompt
## Create 2 variables (feel free to customize the colors)
ZSH_THEME_TF_PROMPT_PREFIX="%{$fg[white]%}"
ZSH_THEME_TF_PROMPT_SUFFIX="%{$reset_color%}"

## Add the current Terraform workspace in your prompt by adding `"TF: ${__TERRAFORM_WORKSPACE_CACHE:gs/%/%%}"` to your `PROMPT` or `RPROMPT` variable.
## Example:
PROMPT="${PROMPT}>${ZSH_THEME_TF_PROMPT_PREFIX-[}${__TERRAFORM_WORKSPACE_CACHE:gs/%/%%}${ZSH_THEME_TF_PROMPT_SUFFIX-]}"
```
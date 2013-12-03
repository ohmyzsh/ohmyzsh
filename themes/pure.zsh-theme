#!/usr/bin/env zsh

# ------------------------------------------------------------------------------
#
# Pure - A minimal and beautiful theme for oh-my-zsh
#
# Based on the custom Zsh-prompt of the same name by Sindre Sorhus. A huge
# thanks goes out to him for designing the fantastic Pure prompt in the first
# place! I'd also like to thank Julien Nicoulaud for his "nicoulaj" theme from
# which I've borrowed both some ideas and some actual code. You can find out
# more about both of these fantastic two people here:
#
# Sindre Sorhus
#   Github:   https://github.com/sindresorhus
#   Twitter:  https://twitter.com/sindresorhus
#
# Julien Nicoulaud
#   Github:   https://github.com/nicoulaj
#   Twitter:  https://twitter.com/nicoulaj
#
# License
#
# Copyright (c) 2013 Kasper Kronborg Isager
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
#
# ------------------------------------------------------------------------------

# Set required options
#
setopt prompt_subst

# Load required modules
#
autoload -Uz vcs_info

# Set vcs_info parameters
#
zstyle ':vcs_info:*' enable hg bzr git
zstyle ':vcs_info:*:*' unstagedstr '!'
zstyle ':vcs_info:*:*' stagedstr '+'
zstyle ':vcs_info:*:*' formats "$FX[bold]%r$FX[no-bold]/%S" "%s/%b" "%%u%c"
zstyle ':vcs_info:*:*' actionformats "$FX[bold]%r$FX[no-bold]/%S" "%s/%b" "%u%c (%a)"
zstyle ':vcs_info:*:*' nvcsformats "%~" "" ""

# Fastest possible way to check if repo is dirty
#
git_dirty() {
    # Check if we're in a git repo
    command git rev-parse --is-inside-work-tree &>/dev/null || return
    # Check if it's dirty
    command git diff --quiet --ignore-submodules HEAD &>/dev/null; [ $? -eq 1 ] && echo "*"
}

# Display information about the current repository
#
repo_information() {
    echo "%F{blue}${vcs_info_msg_0_%%/.} %F{8}$vcs_info_msg_1_`git_dirty` $vcs_info_msg_2_%f"
}

# Displays the exec time of the last command if set threshold was exceeded
#
cmd_exec_time() {
    local stop=`date +%s`
    local start=${cmd_timestamp:-$stop}
    let local elapsed=$stop-$start
    [ $elapsed -gt 5 ] && echo ${elapsed}s
}

# Get the intial timestamp for cmd_exec_time
#
preexec() {
    cmd_timestamp=`date +%s`
}

# Output additional information about paths, repos and exec time
#
precmd() {
    vcs_info # Get version control info before we start outputting stuff
    print -P "\n$(repo_information) %F{yellow}$(cmd_exec_time)%f"
}

# Define prompts
#
PROMPT="%(?.%F{magenta}.%F{red})❯%f " # Display a red prompt char on failure
RPROMPT="%F{8}${SSH_TTY:+%n@%m}%f"    # Display username if connected via SSH

# ------------------------------------------------------------------------------
#
# List of vcs_info format strings:
#
# %b => current branch
# %a => current action (rebase/merge)
# %s => current version control system
# %r => name of the root directory of the repository
# %S => current path relative to the repository root directory
# %m => in case of Git, show information about stashes
# %u => show unstaged changes in the repository
# %c => show staged changes in the repository
#
# List of prompt format strings:
#
# prompt:
# %F => color dict
# %f => reset color
# %~ => current path
# %* => time
# %n => username
# %m => shortname host
# %(?..) => prompt conditional - %(condition.true.false)
#
# ------------------------------------------------------------------------------

Term-Undo

<p align="center">
<b>A Lightweight Zsh Utility for Instant Terminal Error Cleanup and Command Recovery</b></p>

<p align="center">
<code>Undo / Alt+U</code><br>Never panic in the terminal again! Instantly undo your last messed-up command.</p>

<p align="center">
<img src="https://github.com/nahid-mahmud555/term-undo/raw/main/test00.gif" alt="Term-Undo Demo" width="650px"></p>

Overview

Term-Undo is a lightweight Zsh utility designed to simplify terminal error recovery by clearing unwanted multi-line error output and restoring a previously entered command to the input buffer.

It aims to provide a clean and efficient recovery workflow without duplicating prompts, disrupting the existing Zsh configuration, or deleting command history.

Quick Usage

Term-Undo provides two ways to initiate command recovery:

Method	Description	Keyboard Shortcut
Keyboard Shortcut	Press Alt + U to trigger terminal cleanup and command recovery.	Alt + U
Command Alias	Type undo in your terminal to invoke the recovery workflow.	undo
💡 Tip: Recover your previous command without manually retyping it, where supported by the current shell state and implementation.
One-Line Installation

Install Term-Undo with a single command in your Zsh terminal.

Installation Command
zsh
curl -fsSL https://raw.githubusercontent.com/nahid-mahmud555/term-undo/main/install.sh | bash

Reload Zsh Configuration

After installation, reload your Zsh configuration:

zsh
source ~/.zshrc


This applies the configuration changes to the current shell session.

📝 Note for Root Users

Standard users and the superuser (root) maintain separate home directories and shell configuration files (.zshrc).

Standard User: /home/username/.zshrc
Root User: /root/.zshrc

Installing Term-Undo under a standard user account does not automatically enable it in the root environment. If your root terminal defaults to Bash, switch to a Zsh session before running the installation commands.

Installation for Root Users

Run the following commands in order:

Step 1 — Switch to Root Privileges
bash
sudo -i

Step 2 — Start a Zsh Session
bash
zsh

Step 3 — Install Term-Undo
bash
curl -fsSL https://raw.githubusercontent.com/nahid-mahmud555/term-undo/main/install.sh | bash

Step 4 — Reload Root's Zsh Configuration
bash
source ~/.zshrc

⚠️ Note: Each command is provided separately for easy copying. Make sure you execute them sequentially in the same root session. Term-Undo must be installed and configured separately for the root user and standard user.
🔒 Security Note

Review the installation script before executing a remotely downloaded script through a shell.

## An Oh My Zsh plugin for GPG encrypted, Internet synchronized Zsh history using Git
<br />
That is, if you'd like an easy way to securely synchronise your zsh_history across many computers connected to the Internet, this plugin will help you. **Be creative with this - I dare you.**

### What tooling do I need?
##### 1. GnuPG
history-sync uses GPG to encrypt/decrypt your zsh_history. The [GnuPG documentation](https://www.gnupg.org/documentation/manuals.html) is very good.

##### 2. Git
history-sync uses Git to push/pull your zsh_history to/from a remote repository.<br />

### How do I  use it?
1. Create a Git repo for housing your encrypted zsh_history file. This repo needs to be accessible from all client shells you'd like to synchronize
   - Mine is $HOME/.zsh_history_proj
2. Activate history-sync plugin in your .zshrc
   - `git clone git@github.com:wulfgarpro/history-sync.git $HOME/.oh-my-zsh/plugins/.`
3. Export environment variables (or use defaults found in the plugin file history-sync.plugin.zsh)
   <br />These are:
   - **ZSH_HISTORY_FILE**<br />
   Your zsh_history file location
   - **ZSH_HISTORY_PROJ**<br /> 
   Your Git project for housing your zsh_history file
   - **ZSH_HISTORY_FILE_ENC**<br />
   Your encrypted zsh_history file location
   - **GIT_COMMIT_MSG**<br />
   Your default message when pushing to $ZSH_HISTORY_PROJ
4. Ensure your GPG setup is complete and you have a public/private key pair for encrypting/decrypting: `man gpg`
5. Run `zhpl` to pull
6. Run `zhps -r 876T3F78 -r 998A637B -r ...` to encrypt and push
7. Run `zhsync` to pull/push

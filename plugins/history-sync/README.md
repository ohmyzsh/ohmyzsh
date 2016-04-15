## An oh-my-zsh plugin for gpg encrypted, internet synchronized zsh history using git.
<br />
That is, if you'd like an easy way to securely synchronise your zsh_history across many computers connected to the internet, this plugin will help you. You could even automate it using something like cron for a daily or even hourly sync.

### How do I  use it?

1. Create a git repo for housing your encrypted zsh_history file (local or remote)
   - Mine is $HOME/.zsh_history_proj
2. Activate history-sync plugin in your .zshrc
   - git clone git@github.com:wulfgarpro/history-sync.git $HOME/.oh-my-zsh/plugins/.
3. Export environment variables (or use defaults found in history-sync.plugin.zsh)
   <br />These are:
   - ZSH_HISTORY_FILE
   - ZSH_HISTORY_PROJ
   - ZSH_HISTORY_FILE_ENC
   - GIT_COMMIT_MSG
4. Ensure your gpg/pgp setup is complete and you have a public/private key pair
   <br /> i.e.:
   - gpg --list-keys
5. Run zhpl alias to pull
6. Run zhps alias to push
7. Run zhsync to pull/push


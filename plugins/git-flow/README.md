# Git flow plugin installation

```bash

git clone https://github.com/robbyrussell/oh-my-zsh.git 

cp oh-my-zsh/plugins/git-flow/git-flow.plugin.zsh ~/.git-flow-completion.zsh

vi ~/.zshrc

    # Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
    # Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
    # Example format: plugins=(rails git textmate ruby lighthouse)
    # Add wisely, as too many plugins slow down shell startup.

    plugins=(git git-flow)
       
    $ source ~/.git-flow-completion.zsh
```


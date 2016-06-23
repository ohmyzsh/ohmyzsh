# Git flow plugin installation

    1) $ git clone https://github.com/robbyrussell/oh-my-zsh.git 

    2) $ cp oh-my-zsh/plugins/git-flow/git-flow.plugin.zsh ~/.git-flow-completion.zsh

    3) $ gedit ~/.zshrc

    4) add git-flow in plugins like this plugins=(git git-flow)

```bash
    # Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
    # Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
    # Example format: plugins=(rails git textmate ruby lighthouse)
    # Add wisely, as too many plugins slow down shell startup.

    plugins=(git git-flow)
    
   
```

    5) $ source ~/.git-flow-completion.zsh

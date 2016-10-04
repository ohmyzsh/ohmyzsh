#Globalias


Expands all globes, backtick expressions and aliases(including global).

```
$ touch {1..10}<space>
#expands to
$ touch 1 2 3 4 5 6 7 8 9 10

$ mkdir "`date -R`"
#expands to
$ mkdir Tue,\ 04\ Oct\ 2016\ 13:54:03\ +0300

#.zshrc:
alias -g G="| grep --color=auto -P"
alias l='ls --color=auto -lah'

$ l<space>G<space>
#expands to
$ ls --color=auto -lah | grep --color=auto -P

ls **/*.json<space>
#expands to
ls folder/file.json anotherfolder/another.json
```

####Returns autocompletion to your custom aliases:
```
#.zsrc
alias S="sudo systemctl"

$ S<space>
#expands to:
sudo systemctl s<tab>
#trigger autocompletion
```

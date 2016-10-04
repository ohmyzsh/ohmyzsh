# Git auto fetch

Automatically fetches all changes from all remotes every time you cd into yout git-initialized project.

####Usage
Add ```git-auto-fetch``` to the plugins array in your zshrc file:
```shell
plugins=(... git-auto-fetch)
```

Every time you change directory to your git project all remotes will be fetched in background. Log of ```git fetch --all``` will be saved into .git/FETCH_LOG

####Toggle auto fetch per folder
If you are using mobile connection or for any other reason you can disable git-auto-fetch for any folder:

```shell
$ cd to/your/project
$ git-auto-fetch
disabled
$ git-auto-fetch
enabled
```

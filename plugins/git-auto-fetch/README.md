# Git auto-fetch

Automatically fetches all changes from all remotes while you are working in git-initialized directory.

#### Usage

Add `git-auto-fetch` to the plugins array in your zshrc file:

```shell
plugins=(... git-auto-fetch)
```

Every time you launch a command in your shell all remotes will be fetched in background.
By default autofetch will be triggered only if last fetch was done at least 60 seconds ago.
You can change fetch interval in your .zshrc:
```
GIT_AUTO_FETCH_INTERVAL=1200 #in seconds
```
Log of `git fetch --all` will be saved into `.git/FETCH_LOG`


#### Toggle auto fetch per folder
If you are using mobile connection or for any other reason you can disable git-auto-fetch for any folder:

```shell
$ cd to/your/project
$ git-auto-fetch
disabled
$ git-auto-fetch
enabled
```

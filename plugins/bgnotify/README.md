# bgnotify zsh plugin

cross-platform background notifications for long running commands! Supports OSX and Linux.

Standalone homepage: [t413/zsh-background-notify](https://github.com/t413/zsh-background-notify)

---

## How to use

Just add bgnotify to your plugins list in your `.zshrc`

- On OS X you'll need [terminal-notifier](https://github.com/alloy/terminal-notifier)
  * `brew install terminal-notifier` (or `gem install terminal-notifier`)
- On Linux, make sure you have `notify-send` or `kdialog` installed. If you're using Ubuntu you should already be all set!
- On Windows you can use [notifu](https://www.paralint.com/projects/notifu/) or the Cygwin Ports libnotify package


## Screenshots

**Linux**

![screenshot from 2014-11-07 15 58 36](https://cloud.githubusercontent.com/assets/326829/4962187/256b465c-66da-11e4-927d-cc2fc105e31f.png)

**OS X**

![screenshot 2014-11-08 14 15 12](https://cloud.githubusercontent.com/assets/326829/4965780/19fa3eac-6795-11e4-8ed6-0355711123a9.png)

**Windows**

![screenshot from 2014-11-07 15 55 00](https://cloud.githubusercontent.com/assets/326829/4962159/a2625ca0-66d9-11e4-9e91-c5834913190e.png)


## Configuration

One can configure a few things:

- `bgnotify_bell` enabled or disables the terminal bell (default true)
- `bgnotify_threshold` sets the notification threshold time (default 6 seconds)
- `function bgnotify_formatted` lets you change the notification. You can for instance customize the message and pass in an icon.
- `bgnotify_extraargs` appends extra args to notifier (e.g. `-e` for notify-send to create a transient notification)

Use these by adding a function definition before the your call to source. Example:

```sh
bgnotify_bell=false   ## disable terminal bell
bgnotify_threshold=4  ## set your own notification threshold

function bgnotify_formatted {
  ## $1=exit_status, $2=command, $3=elapsed_time

  # Humanly readable elapsed time
  local elapsed="$(( $3 % 60 ))s"
  (( $3 < 60 ))   || elapsed="$((( $3 % 3600) / 60 ))m $elapsed"
  (( $3 < 3600 )) || elapsed="$((  $3 / 3600 ))h $elapsed"

  [ $1 -eq 0 ] && title="Holy Smokes Batman" || title="Holy Graf Zeppelin"
  [ $1 -eq 0 ] && icon="$HOME/icons/success.png" || icon="$HOME/icons/fail.png"
  bgnotify "$title - took ${elapsed}" "$2" "$icon"
}

plugins=(git bgnotify)  ## add to plugins list
source $ZSH/oh-my-zsh.sh  ## existing source call
```

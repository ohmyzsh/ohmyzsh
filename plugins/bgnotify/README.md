# bgnotify zsh plugin

cross-platform background notifications for long running commands! Supports OSX and Ubuntu linux.

Standalone homepage: [t413/zsh-background-notify](https://github.com/t413/zsh-background-notify)

----------------------------------

## How to use!

Just add bgnotify to your plugins list in your `.zshrc`

- On OS X you'll need [terminal-notifer](https://github.com/alloy/terminal-notifier)
  * `brew install terminal-notifier` (or `gem install terminal-notifier`)
- On ubuntu you're already all set!


## Configuration

One can configure a few things:

- `bgnotify_threshold` sets the notification threshold time (default 6 seconds)
- `function bgnotify_formatted` lets you change the notification

Use these by adding a function definition before the your call to source. Example:

~~~ sh
bgnotify_threshold=4  ## set your own notification threshold

function bgnotify_formatted {
  ## $1=exit_status, $2=command, $3=elapsed_time
  [ $1 -eq 0 ] && title="Holy Smokes Batman!" || title="Holy Graf Zeppelin!"
  bgnotify "$title -- after $3 s" "$2";
}

plugins=(git bgnotify)  ## add to plugins list
source $ZSH/oh-my-zsh.sh  ## existing source call
~~~


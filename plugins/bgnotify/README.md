# bgnotify zsh plugin

cross-platform background notifications for long running commands! Supports OSX and Ubuntu linux.

Standalone homepage: [t413/zsh-background-notify](https://github.com/t413/zsh-background-notify)

----------------------------------

## How to use!

Just add bgnotify to your plugins list in your `.zshrc`

- On OS X you'll need [terminal-notifier](https://github.com/alloy/terminal-notifier)
  * `brew install terminal-notifier` (or `gem install terminal-notifier`)
- On ubuntu you're already all set!
- On windows you can use [notifu](https://www.paralint.com/projects/notifu/) or the Cygwin Ports libnotify package


## Screenshots

**Linux**

![screenshot from 2014-11-07 15 58 36](https://cloud.githubusercontent.com/assets/326829/4962187/256b465c-66da-11e4-927d-cc2fc105e31f.png)

**OS X**

![screenshot 2014-11-08 14 15 12](https://cloud.githubusercontent.com/assets/326829/4965780/19fa3eac-6795-11e4-8ed6-0355711123a9.png)

**Windows**

![screenshot from 2014-11-07 15 55 00](https://cloud.githubusercontent.com/assets/326829/4962159/a2625ca0-66d9-11e4-9e91-c5834913190e.png)


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

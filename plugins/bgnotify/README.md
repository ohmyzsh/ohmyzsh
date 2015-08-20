# zsh-background-notify

cross-platform background notifications for long running commands! Supports OSX and Ubuntu linux.

![screenshot 2014-11-08 14 15 12](https://cloud.githubusercontent.com/assets/326829/4965780/19fa3eac-6795-11e4-8ed6-0355711123a9.png)
----------------------------------

## Do you use `oh-my-zsh`?

RobbyRussel [merged](https://github.com/robbyrussell/oh-my-zsh/pull/3301) (and [tweeted](https://twitter.com/ohmyzsh/status/569566134984265729) about it) this plugin to the main-line oh-my-zsh. If that's what you're running then just add 'bgnotify' to your `.zshrc` plugins list and you're all set!

## Do you use `Prezto`?

I do too! [Prezto](https://github.com/sorin-ionescu/prezto) rocks-- and works great with bg-notify! (although there's no included plugin (yet?)).

## How to use!

1. Clone the repository:
  * `git clone https://github.com/t413/zsh-background-notify.git ~/.zsh-background-notify`
2. And add one line your `.zshrc`:
  * `source $HOME/.zsh-background-notify/bgnotify.plugin.zsh`
3. Done!

## Requirements:

- On OS X you'll need [terminal-notifer](https://github.com/alloy/terminal-notifier)
  * `brew install terminal-notifier` (or `gem install terminal-notifier`)
- On ubuntu you're already all set!
- On windows you can use [notifu](http://www.paralint.com/projects/notifu/) or the Cygwin Ports `libnotify` package

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
- `function notify_formatted` lets you change the notification

Use these by adding a function definition before the your call to source. Example:

~~~ sh
bgnotify_threshold=4  ## set your own notification threshold

function notify_formatted {
  ## $1=exit_status, $2=command, $3=elapsed_time
  [ $1 -eq 0 ] && title="Holy Smokes Batman!" || title="Holy Graf Zeppelin!"
  bgnotify "$title -- after $3 s" "$2";
}

source $HOME/.zsh/zsh-background-notify/bgnotify.plugin.zsh
~~~


## How it works

In zsh you can add a user-hook `preexec` that runs before executing a command and `precmd` that runs just before re-prompting. Timing the difference between them gives you execution time!

To check if you're in the background we can use xprop to find the NET_ACTIVE_WINDOW in ubuntu and osascript to run a simple apple script to get the same thing (although slower).


## Alternatives:

I like linking.. So here are a few similar alternatives to this script. Most are platform-specific and buggy in some way. (Sure is great to use one script on all of your systems!)

- This [reddit post](http://www.reddit.com/r/linux/comments/1pooe6/zsh_tip_notify_after_long_processes/)
- [zsh-notify](https://github.com/marzocchi/zsh-notify) plugin for Mac OS X
- [dotzsh notify](https://github.com/dotphiles/dotzsh/tree/master/modules/notify)
- [zbell](https://gist.github.com/jpouellet/5278239)

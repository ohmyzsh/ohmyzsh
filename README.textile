A handful of functions, auto-complete helpers, and stuff that makes you shout...

bq. "OH MY ZSHELL!"

h2. Setup

h3. The automatic installer... (do you trust me?)

@wget http://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | sh@

h3. The manual way


1. Clone the repository

  @git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh@

2. Create a new zsh config by copying the zsh template we've provided.

  *NOTE*: If you already have a ~/.zshrc file, you should back it up. @cp ~/.zshrc ~/.zshrc.orig@ in case you want to go back to your original settings.

  @cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc@

3. Set zsh as your default shell:

  @chsh -s /bin/zsh@

4. Start / restart zsh (open a new terminal is easy enough..)

h3. Problems?

You _might_ need to modify your PATH in ~/.zshrc if you're not able to find some commands after switching to oh-my-zsh.

h2. Usage

TODO: Update this..

* Rake autocomplete: @rake (tab)@. Will generate a cache of all your rake tasks and then let you auto-complete and/or select the task to run.
* ssh autocomplete: @ssh (tab)@ or @scp (tab)@
* Git branch, it'll tell you which branch you're in when you're in a git repository directory.
* Theme support: Change the @ZSH_THEME@ environment variable in @~/.zshrc@.
** Take a look at the "current themes":http://wiki.github.com/robbyrussell/oh-my-zsh/themes that come bundled with Oh My Zsh.
* much much more..

h2. Useful

the "refcard":http://www.bash2zsh.com/zsh_refcard/refcard.pdf is pretty tasty for tips.

h3. Customization

If you want to override any of the default behavior, just add a new file (ending in @.zsh@) into the @custom/@ directory.

h3. Uninstalling

If you want to uninstall it, just run @uninstall_oh_my_zsh@ from the command line and it'll remove itself and revert you to bash (or your previous zsh config).

h2. Thanks

* Rick Olson (technoweenie) might remember some of the configuration, which I took from a pastie a few years ago.
* Marcel (noradio) provided Rick the original zsh configuration.
* Nicholas (ulysses) for the "rake autocompletion code":http://weblog.rubyonrails.org/2006/3/9/fast-rake-task-completion-for-zsh.

h2. Help out!

I'm far from being a zsh-expert and suspect there are many ways to improve. If you have ideas on how to make the configuration easier to maintain (and faster), don't hesitate to fork and send pull requests!

h3. Send us your theme!

I'm hoping to collect a bunch of themes for our command prompts. You can see existing ones in the @themes/@ directory.

h3. Todo from imajes:

* need to make the title bar support git folder
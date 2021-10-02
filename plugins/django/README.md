# Django plugin

This plugin adds completion for the [Django Project](https://www.djangoproject.com/) commands
(`manage.py`, `django-admin`, ...).

## Deprecation (2021-09-22)

The plugin used to provide completion for `./manage.py` and `django-admin`, but Zsh already provides
a better, more extensive completion for those, so this plugin is no longer needed.

Right now a warning message is shown, but in the near future the plugin will stop working altogether.
So you can remove it from your plugins and you'll automatically start using Zsh's django completion.

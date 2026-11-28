# WP-CLI

The [WordPress CLI](https://wp-cli.org/) is a command-line tool for managing WordPress installations. You can update plugins, set up multisite installs and much more, without using a web browser.

This plugin adds [tab completion](https://wp-cli.org/#tab-completions) for `wp-cli` as well as several aliases for commonly used commands.

To use it, add `wp-cli` to the plugins array in your zshrc file:

```zsh
plugins=(... wp-cli)
```

**Maintainer:** [joshmedeski](https://github.com/joshmedeski)

## Aliases

The entire list of `wp-cli` commands can be found here: https://developer.wordpress.org/cli/commands/

| Alias     | Command                     |
|-----------|-----------------------------|
| **Core**                                |
| `wpcc`    | `wp core config`            |
| `wpcd`    | `wp core download`          |
| `wpci`    | `wp core install`           |
| `wpcii`   | `wp core is-installed`      |
| `wpcmc`   | `wp core multisite-convert` |
| `wpcmi`   | `wp core multisite-install` |
| `wpcu`    | `wp core update`            |
| `wpcudb`  | `wp core update-db`         |
| `wpcvc`   | `wp core verify-checksums`  |
| **Cron**                                |
| `wpcre`   | `wp cron event`             |
| `wpcrs`   | `wp cron schedule`          |
| `wpcrt`   | `wp cron test`              |
| **Database**                            |
| `wpdbe`   | `wp db export`              |
| `wpdbi`   | `wp db import`              |
| `wpdbcr`  | `wp db create`              |
| `wpdbs`   | `wp db search`              |
| `wpdbch`  | `wp db check`               |
| `wpdbr`   | `wp db repair`              |
| **Menu**                                |
| `wpmc`    | `wp menu create`            |
| `wpmd`    | `wp menu delete`            |
| `wpmi`    | `wp menu item`              |
| `wpml`    | `wp menu list`              |
| `wpmlo`   | `wp menu location`          |
| **Plugin**                              |
| `wppa`    | `wp plugin activate`        |
| `wppda`   | `wp plugin deactivate`      |
| `wppd`    | `wp plugin delete`          |
| `wppg`    | `wp plugin get`             |
| `wppi`    | `wp plugin install`         |
| `wppis`   | `wp plugin is-installed`    |
| `wppl`    | `wp plugin list`            |
| `wppp`    | `wp plugin path`            |
| `wpps`    | `wp plugin search`          |
| `wppst`   | `wp plugin status`          |
| `wppt`    | `wp plugin toggle`          |
| `wppun`   | `wp plugin uninstall`       |
| `wppu`    | `wp plugin update`          |
| **Post**                                |
| `wppoc`   | `wp post create`            |
| `wppod`   | `wp post delete`            |
| `wppoe`   | `wp post edit`              |
| `wppogen` | `wp post generate`          |
| `wppog`   | `wp post get`               |
| `wppol`   | `wp post list`              |
| `wppom`   | `wp post meta`              |
| `wppou`   | `wp post update`            |
| `wppourl` | `wp post url`               |
| **Sidebar**                             |
| `wpsbl`   | `wp sidebar list`           |
| **Theme**                               |
| `wpta`    | `wp theme activate`         |
| `wptd`    | `wp theme delete`           |
| `wptdis`  | `wp theme disable`          |
| `wpte`    | `wp theme enable`           |
| `wptg`    | `wp theme get`              |
| `wpti`    | `wp theme install`          |
| `wptis`   | `wp theme is-installed`     |
| `wptl`    | `wp theme list`             |
| `wptm`    | `wp theme mod`              |
| `wptp`    | `wp theme path`             |
| `wpts`    | `wp theme search`           |
| `wptst`   | `wp theme status`           |
| `wptu`    | `wp theme update`           |
| **User**                                |
| `wpuac`   | `wp user add-cap`           |
| `wpuar`   | `wp user add-role`          |
| `wpuc`    | `wp user create`            |
| `wpud`    | `wp user delete`            |
| `wpugen`  | `wp user generate`          |
| `wpug`    | `wp user get`               |
| `wpui`    | `wp user import-csv`        |
| `wpul`    | `wp user list`              |
| `wpulc`   | `wp user list-caps`         |
| `wpum`    | `wp user meta`              |
| `wpurc`   | `wp user remove-cap`        |
| `wpurr`   | `wp user remove-role`       |
| `wpusr`   | `wp user set-role`          |
| `wpuu`    | `wp user update`            |
| **Widget**                              |
| `wpwa`    | `wp widget add`             |
| `wpwda`   | `wp widget deactivate`      |
| `wpwd`    | `wp widget delete`          |
| `wpwl`    | `wp widget list`            |
| `wpwm`    | `wp widget move`            |
| `wpwu`    | `wp widget update`          |

# Hanami Plugin #
This plugin adds convinient ways to work with [Hanami](http://hanamirb.org/) via console. It's inspired by Rails plugin, so if you've used it, you'll be like home.

## Usage ##
For example, type `hc` into your console when you're within Hanami project directory to run application console.
You can read about available commands [here](http://hanamirb.org/guides/command-line/applications/), almost all of them have shortcut aliases with this plugin.

## Aliases ##

| Alias | Description                              | Command                                        |
|-------|------------------------------------------|------------------------------------------------|
| HED | Set environment variable HANAMI_ENV to development | HANAMI_ENV=development |
| HEP | Set environment variable HANAMI_ENV to production | HANAMI_ENV=production |
| HET | Set environment variable HANAMI_ENV to test | HANAMI_ENV=test |
| hc | Run application console | hanami console |
| hd | Remove specified hanami resource (model, action, migration, etc.) | hanami destroy |
| hg | Create specified hanami resource (model, action, migration, etc.) | hanami generate | hanami generate |
| hgm | Create migration file | hanami generate migration |
| hs | Launch server with hanami application | hanami server |
| hsp | Launch server with specified port | hanami server -p |
| hr | List application routes | hanami routes |
| hdc | Create application database | hanami db create |
| hdd | Delete application database | hanami db drop |
| hdp | Create application database, load schema (if any), run pending migrations | hanami db prepare |
| hda | Run pending migrations, dump schema, delete all migration files | hanami db apply |
| hdv | Print current database version (timestamp of last applied migration) | hanami db version |
| hdrs | Drop and recreate application database | hdd && hdp |
| hdtp | Actualize test environment database | HET hdp |
| hrg | Grep hanami routes with specified pattern | hr &#124; grep |

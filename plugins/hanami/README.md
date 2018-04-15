# Hanami Plugin #
This plugin adds convenient ways to work with [Hanami](http://hanamirb.org/) via console.
It's inspired by Rails plugin, so if you've used it, you'll feel like home.

## Usage ##

For example, type `hc` into your console when you're within Hanami project directory to run
the application console. Have a look at available shortcuts below. You can read more about
these commands [on the official website](http://hanamirb.org/guides/command-line/applications/).

## Aliases ##

| Alias | Command                   | Description                                             |
|-------|---------------------------|---------------------------------------------------------|
| HED   | HANAMI_ENV=development    | Set environment variable HANAMI_ENV to development      |
| HEP   | HANAMI_ENV=production     | Set environment variable HANAMI_ENV to production       |
| HET   | HANAMI_ENV=test           | Set environment variable HANAMI_ENV to test             |
| hc    | hanami console            | Run application console                                 |
| hd    | hanami destroy            | Remove specified hanami resource                        |
| hg    | hanami generate           | Create specified hanami resource                        |
| hgm   | hanami generate migration | Create migration file                                   |
| hs    | hanami server             | Launch server with hanami application                   |
| hsp   | hanami server -p          | Launch server with specified port                       |
| hr    | hanami routes             | List application routes                                 |
| hdc   | hanami db create          | Create application database                             |
| hdd   | hanami db drop            | Delete application database                             |
| hdp   | hanami db prepare         | Prepare database for the current environment            |
| hda   | hanami db apply           | Recreates a fresh schema after migrations (destructive) |
| hdv   | hanami db version         | Print current database version                          |
| hdrs  | hdd && hdp                | Drop and recreate application database                  |
| hdtp  | HET hdp                   | Actualize test environment database                     |
| hrg   | hr &#124; grep            | Grep hanami routes with specified pattern               |

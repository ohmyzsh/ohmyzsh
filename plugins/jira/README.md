#  Jira plugin  #

CLI support for JIRA interaction

##  Description  ##

This plugin provides command line tools for interacting with Atlassian's [JIRA](https://www.atlassian.com/software/jira) bug tracking software.

The interaction is all done through the web. No local installation of JIRA is necessary.

In this document, "JIRA" refers to the JIRA issue tracking server, and `jira` refers to the command this plugin supplies.

##  Usage  ##

This plugin supplies one command, `jira`, through which all its features are exposed. Most forms of this command open a JIRA page in your web browser.

## Commands

| Command       | Description                                               |
| :------------ | :-------------------------------------------------------- |
| `jira`        | Performs the default action                               |
| `jira new`    | Opens a new Jira issue dialogue                           |
| `jira ABC-123`   | Opens an existing issue                                |
| `jira ABC-123 m` | Opens an existing issue for adding a comment           |
| `jira dashboard [rapid_view]` |  # opens your JIRA dashboard              |
| `jira mine`   | Queries for your own issues                               |
| `jira tempo`  | Opens your JIRA Tempo                                     |
| `jira reported [username]`  | Queries for issues reported by a user       |
| `jira assigned [username]`  | Queries for issues assigned to a user       |
| `jira branch` | Opens an existing issue matching the current branch name  |


### Jira Branch usage notes

The branch name may have prefixes ending in "/": "feature/MP-1234", and also suffixes 
starting with "_": "MP-1234_fix_dashboard". In both these cases, the issue opened will be "MP-1234"

This is also checks if the prefix is in the name, and adds it if not, so: "MP-1234" opens the issue "MP-1234",
"mp-1234" opens the issue "mp-1234", and "1234" opens the issue "MP-1234".



#### Debugging usage  ####

These calling forms are for developers' use, and may change at any time.

```
jira dumpconfig   # displays the effective configuration
```

##  Setup  ##

The URL for your JIRA instance is set by `$JIRA_URL` or a `.jira_url` file.

Add a `.jira-url` file in the base of your project. You can also set `$JIRA_URL` in your `~/.zshrc` or put a `.jira-url` in your home directory. A `.jira-url` in the current directory takes precedence, so you can make per-project customizations.

The same goes with `.jira-prefix` and `$JIRA_PREFIX`. These control the prefix added to all issue IDs, which differentiates projects within a JIRA instance.

For example:

```
cd to/my/project
echo "https://jira.atlassian.com" >> .jira-url
```

(Note: The current implementation only looks in the current directory for `.jira-url` and `.jira-prefix`, not up the path, so if you are in a subdirectory of your project, it will fall back to your default JIRA URL. This will probably change in the future though.)

###  Variables  ###

* `$JIRA_URL` - Your JIRA instance's URL
* `$JIRA_NAME` - Your JIRA username; used as the default user for `assigned`/`reported` searches
* `$JIRA_PREFIX` - Prefix added to issue ID arguments
* `$JIRA_RAPID_BOARD` - Set to `true` if you use Rapid Board
* `$JIRA_RAPID_VIEW` - Set the default rapid view; it doesn't work if `$JIRA_RAPID_BOARD` is set to false
* `$JIRA_DEFAULT_ACTION` - Action to do when `jira` is called with no arguments; defaults to "new"
* `$JIRA_TEMPO_PATH` - Your JIRA tempo url path; defaults to "/secure/Tempo.jspa"


### Browser ###

Your default web browser, as determined by how `open_command` handles `http://` URLs, is used for interacting with the JIRA instance. If you change your system's URL handler associations, it will change the browser that `jira` uses.

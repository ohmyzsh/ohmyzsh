# taskwarrior

This plugin adds smart tab completion for [TaskWarrior][1]. It uses the zsh tab
completion script (`_task`) shipped with TaskWarrior for the completion
definitions.

To use it, add `taskwarrior` to the plugins array in your zshrc file:

```zsh
plugins=(... taskwarrior)
```

## Examples

Typing `task [TAB]` will give you a list of commands, `task 66[TAB]` shows a
list of available modifications for that task, etcetera.

The latest version pulled in from the official project is of January 1st, 2015.

## Aliases

### General Reports

| Alias | Command        | Description              |
|-------|----------------|--------------------------|
| tn    | `task next`    | Most urgent tasks        |
| tl    | `task list`    | Most details of tasks    |
| tll   | `task long`    | All details of tasks     |
| tls   | `task ls`      | Few details of tasks     |
| tlm   | `task minimal` | Minimal details of tasks |

All these reports can be filtered by passing a list/range of IDs after the
command (or specific filters, as detailed in Taskwarrior's [documentation][2]).

Additionally, by appending `d`, `w` or `m`, the plugin will use different
aliases to filter tasks with the special tags +TODAY, +WEEK or +MONTH,
respectively:

| Alias | Command               |
|-------|-----------------------|
| tnd   | `task next +TODAY`    |
| tld   | `task list +TODAY`    |
| tlld  | `task long +TODAY`    |
| tlsd  | `task ls +TODAY`      |
| tlmd  | `task minimal +TODAY` |
| tnw   | `task next +WEEK`     |
| tlw   | `task list +WEEK`     |
| tllw  | `task long +WEEK`     |
| tlsw  | `task ls +WEEK`       |
| tlmw  | `task minimal +WEEK`  |
| tnm   | `task next +MONTH`    |
| tlm   | `task list +MONTH`    |
| tllm  | `task long +MONTH`    |
| tlsm  | `task ls +MONTH`      |
| tlmm  | `task minimal +MONTH` |

### Status-related and graphical reports

| Alias | Command                 | Description                                        |
|-------|-------------------------|----------------------------------------------------|
| ta    | `task active`           | Active tasks                                       |
| to    | `task overdue`          | Overdue tasks                                      |
| tw    | `task waiting`          | Waiting (hidden) tasks                             |
| tc    | `task completed`        | Completed tasks                                    |
| tb    | `task burndown`         | Handler for `task burndown.weekly`                 |
| tbd   | `task burndown.daily`   | Shows a graphical burndown chart, by day           |
| tbw   | `task burndown.weekly`  | Shows a graphical burndown chart, by week          |
| tbm   | `task burndown.monthly` | Shows a graphical burndown chart, by month         |
| th    | `task history`          | Handler for `task history.monthly`                 |
| thd   | `task history.daily`    | Shows a report of task history, by day             |
| thw   | `task history.weekly`   | Shows a report of task history, by week            |
| thm   | `task history.monthly`  | Shows a report of task history, by month           |
| tha   | `task history.annual`   | Shows a report of task history, by year            |
| tg    | `task ghistory`         | Handler for `task ghistory.monthly`                |
| tgd   | `task ghistory.daily`   | Shows a graphical report of task history, by day   |
| tgw   | `task ghistory.weekly`  | Shows a graphical report of task history, by week  |
| tgm   | `task ghistory.monthly` | Shows a graphical report of task history, by month |
| tga   | `task ghistory.annual`  | Shows a graphical report of task history, by year  |
| tcl   | `task calendar`         | Shows a calendar, with due tasks marked            |
| ts    | `task summary`          | Shows a report of task status by project           |

### Task handling

All commands below except for `task undo` can receive arguments:

| Alias | Command       | Description                                        |
|-------|---------------|----------------------------------------------------|
| tad   | `task add`    | Adds a new task                                    |
| tmd   | `task modify` | Modifies the existing task with provided arguments |
| tdl   | `task delete` | Deletes the specified task                         |
| td    | `task done`   | Marks the specified task as completed              |
| te    | `task edit`   | Launches an editor to modify a task directly       |
| tu    | `task undo`   | Reverts the most recent change to a task           |

### Program behaviour

| Alias | Command                                       |                                           |
|-------|-----------------------------------------------|-------------------------------------------|
| tcx   | `task context`                                | Set and define contexts (default filters) |
| tcxn  | `task context none`                           | Unset the current context                 |
| tpd   | `task purge <(task _zshuuids status:deleted)` | Purge all deleted tasks (2.6 onwards)     |

## Contributors

- Manoel P. de Queiroz (git@manoelpqueiroz.anonaddy.com)

[1]: https://taskwarrior.org/
[2]: https://taskwarrior.org/docs/filter/
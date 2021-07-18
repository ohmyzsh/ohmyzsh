# Supercomputer

This adds some features that are useful on supercomputers running the Slurm-Tool
for job-allocation.


```zsh
plugins=(... supercomputer)
```

## Aliases

| Aliases       | Command            |  Description                           |
| :------------ | :----------------- | :------------------------------------- |
| sq            | `squeue -u $USER`  | Get jobs of the current user           |

## Functions

* `treesizethis`: Lists largest folders/files in current directory

* `slurmlogpath $SLURMID`: Returns the path of the `.out`-file of the `$SLURMID`

* `pretty_csv`: Pipe CSV files into this and it will auto-format them as table

* `showmyjobsstatus`: Lists your jobs and shows their estimated starting time (needs `whypending`)

* `ftails $SLURMJOB`: Follows the `.out`-file of the job `$SLURMID`. If no ID is given, it follows
	the first job available by `squeue -u $USER`

* `countdown $SECONDS`: Shows a blocking countdown timer that lasts for `$SECONDS` seconds

* `mongodbtojson $IP $PORT $DB`: Creates a JSON-file from that mongodb-database

* `rtest`: Creates a random non-existant `test`-folder in the form of `$HOME/test/randomtest_$RANDOM`

* `mcd $NAME`: `mkdir $NAME; cd $name`

* `echoerr $MSG`: Prints a message to STDERR

* `red_text $MSG, green_text $MSG, debug_code $MSG`: Prints messages on different colors

* `warningcolors`: Sets warning-colors variables for whiptail

# Slurminator

Enter `slurminator` to get a `whiptail`-GUI from which you can control jobs, kill, 
send signals to multiple jobs at once, tail multiple jobs at once, control workspaces 
(if available) and a lot more.

![Screenshot 1](1.png?raw=true "Screenshot")

![Screenshot 2](2.png?raw=true "Screenshot")

![Screenshot 3](3.png?raw=true "Screenshot")

![Screenshot 4](4.png?raw=true "Screenshot")


## Requirements

You need a working Slurm-Installation with ZSH for this. Also, whiptail for the Slurminator.

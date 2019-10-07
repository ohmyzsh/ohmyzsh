# Singlechar plugin

This plugin adds single char shortcuts (and combinations) for some commands.  
AUTHOR:  Michael Varner (musikmichael@web.de)

To use it, add `singlechar` to the plugins array of your zshrc file:

```
plugins=(... singlechar)
```

## Aliases

### CAT, GREP, CURL, WGET

| Alias | Command | Description |
|-------|---------|-------------|
| y | 'grep -Ri' | grep -R "Read all files under each directory, recursively.  Follow all symbolic links" and -i "Ignore case distinctions, so that characters that differ only in case match each other." |
| n | 'grep -Rvi' | see above and -v  "Invert the sense of matching, to select non-matching lines." |
| f. | 'find . \|  grep' | find pipe to grep |
| f: | 'find' | find |
| f | 'grep -Rli' | see "grep -Ri" and -l "Suppress normal output; instead print the name of each input file from which output would  normally  have been printed. The scanning will stop on the first match." |
| fn | 'grep -Rlvi'| see above and -v  "Invert the sense of matching, to select non-matching lines." |
| w | 'echo >' | echo create/overwrite file |
| a | 'echo >>' | echo create/append file |
| c | 'cat' | cat |
| p | 'less' | less |
| m | 'man' | man |
| d | ' wget' | wget |
| u | ' curl' | curl |

### ENHANCED WRITING

| Alias | Command | Description |
|-------|---------|-------------|
| w: | 'cat >' | cat create/overwrite file |
| a: | 'cat >>' | cat create/append file |

### XARGS

| Alias | Command | Description |
|-------|---------|-------------|
| x | 'xargs' | xargs |
| xy | 'xargs  grep -Ri' | see "CAT, GREP, CURL, WGET" section |
| xn | 'xargs  grep -Rvi' | see "CAT, GREP, CURL, WGET" section  |
| xf. | 'xargs find \|  grep' | see "CAT, GREP, CURL, WGET" section  |
| xf: | 'xargs find' | see "CAT, GREP, CURL, WGET" section  |
| xf | 'xargs  grep -Rli' | see "CAT, GREP, CURL, WGET" section  |
| xfn | 'xargs  grep -Rlvi' | see "CAT, GREP, CURL, WGET" section  |
| xw | 'xargs echo >' | see "CAT, GREP, CURL, WGET" section  |
| xa | 'xargs echo >>' | see "CAT, GREP, CURL, WGET" section  |
| xc | 'xargs cat' | see "CAT, GREP, CURL, WGET" section  |
| xp | 'xargs less' | see "CAT, GREP, CURL, WGET" section  |
| xm | 'xargs man' | see "CAT, GREP, CURL, WGET" section  |
| xd | 'xargs  wget' | see "CAT, GREP, CURL, WGET" section  |
| xu | 'xargs  curl' | see "CAT, GREP, CURL, WGET" section  |
| xw: | 'xargs cat >' | see "ENHANCED WRITING" section |
| xa: | 'xargs >>' | xargs create/append file |

### SUDO

| Alias | Command | Description |
|-------|---------|-------------|
| s | ' sudo' | sudo  |
| sy | ' sudo  grep -Ri' | see "CAT, GREP, CURL, WGET" section |
| sn | ' sudo  grep -Riv' | see "CAT, GREP, CURL, WGET" section |
| sf. | ' sudo find . \|  grep' | see "CAT, GREP, CURL, WGET" section |
| sf: | ' sudo find' | see "CAT, GREP, CURL, WGET" section |
| sf | ' sudo  grep -Rli' | see "CAT, GREP, CURL, WGET" section |
| sfn | ' sudo  grep -Rlvi' | see "CAT, GREP, CURL, WGET" section |
| sw | ' sudo echo >' | see "CAT, GREP, CURL, WGET" section |
| sa | ' sudo echo >>' | see "CAT, GREP, CURL, WGET" section |
| sc | ' sudo cat' | see "CAT, GREP, CURL, WGET" section |
| sp | ' sudo less' | see "CAT, GREP, CURL, WGET" section |
| sm | ' sudo man' | see "CAT, GREP, CURL, WGET" section |
| sd | ' sudo  wget' | see "CAT, GREP, CURL, WGET" section |
| sw: | ' sudo cat >' | see "ENHANCED WRITING" section |
| sa: | ' sudo cat >>' | see "ENHANCED WRITING" section |

### SUDO-XARGS

| Alias | Command | Description |
|-------|---------|-------------|
| sx | ' sudo xargs' | sudo xargs |
| sxy | ' sudo xargs  grep -Ri' | see "CAT, GREP, CURL, WGET" section |
| sxn | ' sudo xargs  grep -Riv' | see "CAT, GREP, CURL, WGET" section |
| sxf. | ' sudo xargs find \|  grep' | see "CAT, GREP, CURL, WGET" section |
| sxf: | ' sudo xargs find' | see "CAT, GREP, CURL, WGET" section |
| sxf | ' sudo xargs  grep -li' | see "CAT, GREP, CURL, WGET" section |
| sxfn | ' sudo xargs  grep -lvi' | see "CAT, GREP, CURL, WGET" section |
| sxw | ' sudo xargs echo >' | see "CAT, GREP, CURL, WGET" section |
| sxa | ' sudo xargs echo >>' | see "CAT, GREP, CURL, WGET" section |
| sxc | ' sudo xargs cat' | see "CAT, GREP, CURL, WGET" section |
| sxp | ' sudo xargs less' | see "CAT, GREP, CURL, WGET" section |
| sxm | ' sudo xargs man' | see "CAT, GREP, CURL, WGET" section |
| sxd | ' sudo xargs  wget' | see "CAT, GREP, CURL, WGET" section |
| sxu | ' sudo xargs  curl' | see "CAT, GREP, CURL, WGET" section |
| sxw: | ' sudo xargs cat >' | see "ENHANCED WRITING" section |
| sxa: | ' sudo xargs cat >>' | see "ENHANCED WRITING" section |

## Options

The commands **grep, sudo, wget, curl, less** can be overwritten any time. If they are not set yet, they will be overwritten with their default values

```
default GREP grep
default ROOT sudo
default WGET wget
default CURL curl

env_default PAGER less
```

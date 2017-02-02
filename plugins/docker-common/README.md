## Docker common plugin

A set of useful docker commands.

### Dserve
```bash
cd /myStaticFolder
dserve # It will lift an nfginx and output the port used on the host
# After you used it you can stop and remove it easily by name
# all the created container names will start with the dserve prefix
docker dstop dserve-myStaticFolder
docker rm dserve-myStaticFolder
```

## Dserve-php
```bash
cd /myStaticFolder
dserve-php # It will lift an apache and output the port used on the host
# After you used it you can stop and remove it easily by name
# all the created container names will start with the dserve-php prefix
docker dstop dserve-php-myStaticFolder
docker rm dserve-php-myStaticFolder
```

### Doc
This run command has many scenarios, this is just a basic configuration.
```bash
doc ls -a # It runs the command on a image with zsh inside
doc "cd .. && ls -a" # It list files from the parent folder inside the container
```

### Sdoc
Same as Doc but it mount volumes as read-only.
```bash
sdoc ls -a # It runs the command on a image with zsh inside
```

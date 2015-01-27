#Show progress while file is copying

# Rsync options are:
#  -p - preserve permissions
#  -o - preserve owner
#  -g - preserve group
#  -h - output in human-readable format
#  --progress - display progress
#  -b - instead of just overwriting an existing file, save the original
#  --backup-dir=/tmp/rsync - move backup copies to "/tmp/rsync"
#  -e /dev/null - only work on local files
#  -- - everything after this is an argument, even if it looks like an option

alias cpv="rsync -poghb --backup-dir=/tmp/rsync -e /dev/null --progress --"

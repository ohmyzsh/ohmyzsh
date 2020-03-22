# Functions
function clean-purgeable-disk-space(){
    if ! [ -z $1] ; then
        echo "Cleaning purgeable files from disk : $1 ...."
        diskutil secureErase freespace 0 $1
    else
        echo "Usage : clean-purgeable-disk-space <disk>"
        echo "Example : clean-purgeable-disk-space /dev/disk1s1"
        echo "Get available disks from the 'df -h /' command"
    fi
}

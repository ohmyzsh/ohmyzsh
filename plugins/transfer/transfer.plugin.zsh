# transfer.sh Easy file sharing from the command line
# transfer Plugin
# Usage Example :
# > transfer file.txt
# > transfer directory/



# Author:
#   Remco Verhoef <remco@dutchcoders.io>
#   https://gist.github.com/nl5887/a511f172d3fb3cd0e42d
#   Modified to use tar command instead of zip
#

echo -ne '\e[1;33m'
cat <<-EOF
        [oh-my-zsh] WARNING: The 'transfer' plugin is deprecated and will be removed after
        [oh-my-zsh] transfer.sh shuts down on November 30th. We suggest you stop using the
        [oh-my-zsh] plugin and find an alternative file hosting service.
EOF
echo -ne '\e[0m'

curl --version 2>&1 > /dev/null
if [ $? -ne 0 ]; then
  echo "Could not find curl."
  return 1
fi

transfer() { 
    # check arguments
    if [ $# -eq 0 ]; 
    then 
        echo "No arguments specified. Usage:\necho transfer /tmp/test.md\ncat /tmp/test.md | transfer test.md"
        return 1
    fi

    # get temporarily filename, output is written to this file show progress can be showed
    tmpfile=$( mktemp -t transferXXX )
    
    # upload stdin or file
    file=$1

    if tty -s; 
    then 
        basefile=$(basename "$file" | sed -e 's/[^a-zA-Z0-9._-]/-/g') 

        if [ ! -e $file ];
        then
            echo "File $file doesn't exists."
            return 1
        fi
        
        if [ -d $file ];
        then
            echo $file
            # tar directory and transfer
            tarfile=$( mktemp -t transferXXX.tar.gz )
            cd $(dirname $file) && tar -czf $tarfile $(basename $file)
            curl --progress-bar --upload-file "$tarfile" "https://transfer.sh/$basefile.tar.gz" >> $tmpfile
            rm -f $tarfile
        else
            # transfer file
            curl --progress-bar --upload-file "$file" "https://transfer.sh/$basefile" >> $tmpfile
        fi
    else 
        # transfer pipe
        curl --progress-bar --upload-file "-" "https://transfer.sh/$file" >> $tmpfile
    fi
   
    # cat output link
    cat $tmpfile

    # cleanup
    rm -f $tmpfile
}

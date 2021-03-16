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

curl --version 2>&1 > /dev/null
if [ $? -ne 0 ]; then
  echo "Could not find curl."
  return 1
fi

transfer() { 
    # check arguments
    if [ $# -eq 0 ]; 
    then 
        echo "No arguments specified! \nUsage:\n   transfer [file/folder] [option]\nExamples:\n   transfer /tmp/test.md\n   transfer /tmp/test.md -ca\n   cat /tmp/test.md | transfer test.md\n   cat /tmp/test.md | transfer test.md -ca\nOptions:\n   -ca  Encrypt file with symmetric cipher and create ASCII armored output"
        return 1
    fi

    # get temporarily filename, output is written to this file show progress can be showed
    tmpfile=$( mktemp -t transferXXX )
    
    # upload stdin or file
    file=$1

    # crypt file with symmetric cipher and create ASCII armored output
    crypt=0
    if [ -n "$2" ]; 
    then 
        if [ "$2"  = "-ca" ]; 
            then 
                crypt=1
        fi
    fi

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
            if [ "$crypt" -eq 1 ]; 
            then
                gpg -cao - "$tarfile" | curl --progress-bar -T "-" "https://transfer.sh/$basefile.tar.gz" >> $tmpfile
            else
                curl --progress-bar --upload-file "$tarfile" "https://transfer.sh/$basefile.tar.gz" >> $tmpfile
            fi
            rm -f $tarfile
        else
            # transfer file
            if [ "$crypt" -eq 1 ]; 
            then
                gpg -cao - "$file" | curl --progress-bar -T "-" "https://transfer.sh/$basefile" >> $tmpfile
            else
                curl --progress-bar --upload-file "$file" "https://transfer.sh/$basefile" >> $tmpfile
            fi
        fi
    else 
        # transfer from pipe
        if [ "$crypt" -eq 1 ]; 
        then
            gpg -aco - | curl -X PUT --progress-bar -T "-" "https://transfer.sh/$file" >> $tmpfile
        else
            curl --progress-bar --upload-file "-" "https://transfer.sh/$file" >> $tmpfile
        fi
    fi
   
    # cat output link
    cat $tmpfile
    # add newline
    echo

    # cleanup
    rm -f $tmpfile
}

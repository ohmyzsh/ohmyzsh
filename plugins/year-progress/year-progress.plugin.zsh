year_progress() {

    year=`date +%Y`
    current=`date +%j`

    # default common year: 365
    len=365

    # leap year: 366
    if [[ ($(($year%4)) == 0 && $(($year%100)) != 0) || $(($year%400)) == 0 ]] ;then
        len=366
    fi

    # progress=current/year
    percent=$(($current*100/$len))

    # The information to be displayed is used to calculate the length.
    info=$percent%'  '$current/$len

    # progress bar length = $COLUMNS - info.length
    cols=$(($COLUMNS-${#info}))

    # Fill the proportion of the screen
    scale=`echo "$cols" | awk '{printf ("%.2f\n",$1/100)}'`

    # The length of the progress bar can be shown on a proportional basis.
    valLen=`echo "$percent $scale" | awk '{printf ("%.0f\n",$1*$2)}'`

    echo 

    echo -n $percent%' '

    # Previous days
    for ((i=0; i<$valLen; i++))  
    do
        echo -n "▓"
    done

    # The remaining days
    for ((i=0; i<$(($cols-$valLen)); i++))  
    do
        echo -n "░"
    done

    echo ' '$current/$len

    echo 
}

year_progress


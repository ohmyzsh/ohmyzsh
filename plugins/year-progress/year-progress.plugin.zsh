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
    value=`echo "$current $len" | awk '{printf ("%.2f\n",$1/$2)}'`

    # Get the number of columns in the terminal
    tput init 
    cols=`tput cols`

    val2=$(($current*100/$len))

    info=$val2%'  '$current/$len

    cols=$(($cols-${#info}))

    # Fill the proportion of the screen
    scale=`echo "$cols" | awk '{printf ("%.2f\n",$1/100)}'`

    val=`echo "$val2 $scale" | awk '{printf ("%.0f\n",$1*$2)}'`

    echo 

    echo -n $val2%' '

    # Previous days
    for ((i=0; i<$val; i++))  
    do
        echo -n "▓"
    done

    # The remaining days
    for ((i=0; i<$((cols-$val)); i ++))  
    do
        echo -n "░"
    done

    echo ' '$current/$len

    echo 
}

year_progress


#!/bin/sh

##defining path of battery
if [ -e /proc/acpi/battery/BAT0/ ] 
        then 
        battpath="/proc/acpi/battery/BAT0" 
elif [ -e /proc/acpi/battery/BAT1/ ] 
        then 
        battpath="/proc/acpi/battery/BAT1" 
else 
        echo "No battery found. Make sure that you have acpi support in your kernel" 
        echo "and that the computer actually is a laptop :)" 
        exit 1 
fi
batt_prompt_perc(){
fullcap=`grep "^last full capacity" $battpath/info | awk '{ print $4 }'`
remcap=`grep "^remaining capacity" $battpath/state | awk '{ print $3 }'`

charge=$(( $remcap * 100 / $fullcap  ))

# prevent a charge of more than 100% displaying
if [ "$charge" -gt "99" ]
	then
   		charge=100
fi

color="red"
if [ $charge -gt "80" ]
	then 
		color="cyan"
elif [ $charge -gt 60 ]
	then	
		color="green"
elif [ $charge -gt 25 ]
	then
		color="yellow"
fi

echo -e "%F{$color}$charge%f"
}

bat_prompt_acstt(){
batstate=`grep "^charging state" $battpath/state | awk '{ print $3 }'`
case "${batstate}" in
   'charged')
  	 clr="green"
   	 btst="°"
   ;;
   'charging')
   	clr="blue"
   	btst="+"
   ;;
   'discharging')
   	clr="yellow"
   	btst="-"
   ;;
esac
echo -e "%F{$clr}$btst%f"
}

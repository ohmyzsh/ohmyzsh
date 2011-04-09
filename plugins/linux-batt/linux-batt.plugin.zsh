#!/bin/sh

##defining path of battery
if [ -e /proc/acpi/battery/BAT0/ ] 
        then 
        battpath="/proc/acpi/battery/BAT0" 
elif [ -e /proc/acpi/battery/BAT1/ ] 
        then 
        battpath="/proc/acpi/battery/BAT1" 
else 
        echo "--" 
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

color="$ZSH_THEME_BATPERC_PROMPT_CLRLESS25PRC"
if [ $charge -gt "80" ]
	then 
		color="$ZSH_THEME_BATPERC_PROMPT_CLRMORE80PRC"
elif [ $charge -gt 40 ]
	then	
		color="$ZSH_THEME_BATPERC_PROMPT_CLR40TO80PRC"
elif [ $charge -gt 25 ]
	then
		color="$ZSH_THEME_BATPERC_PROMPT_CLR25TO40PRC"
fi

echo -e "$ZSH_THEME_BATPERC_PROMPT_PREFIX%F{$color}$charge%f$ZSH_THEME_BATPERC_PROMPT_SUFFIX"
}

bat_prompt_acstt(){
batstate=`grep "^charging state" $battpath/state | awk '{ print $3 }'`
STUATUS=""
case "${batstate}" in
   'charged')
	STATUS="$ZSH_THEME_ACBAT_PROMPT_CHARGED"
   ;;
   'charging')
	STATUS="$ZSH_THEME_ACBAT_PROMPT_CHARGING"
   ;;
   'discharging')
	STATUS="$ZSH_THEME_ACBAT_PROMPT_DISCHARGING"
   ;;
esac

echo -e "$STATUS"
}

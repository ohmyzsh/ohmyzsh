# Add your own custom plugins in the custom/plugins directory. Plugins placed
# here will override ones with the same name in the main plugins directory.
#!/bin/sh
current-time-with-all-zone() {
    if [[ $# -eq 0 ]]; then
      CURRENT=`date`
      GMT_11=`env TZ=Pacific/Midway date`
      GMT_10=`env TZ=Pacific/Honolulu date`
      GMT_9=`env TZ=Pacific/Gambier date`
      GMT_8=`env TZ=Pacific/Pitcairn date`
      GMT_7=`env TZ=America/Phoenix date`
      GMT_6=`env TZ=America/Costa_Rica date`
      GMT_5=`env TZ=America/Bogota date`
      GMT_4=`env TZ=America/Caracas date`
      GMT_3=`env TZ=America/Montevideo date`
      GMT_3_30=`env TZ=America/St_Johns date`
      GMT_2=`env TZ=America/Noronha date`
      GMT_1=`env TZ=Atlantic/Cape_Verde date`
      GMT_0=`env TZ=UTC date`
      GMT_P1=`env TZ=Europe/Dublin date`
      GMT_P2=`env TZ=Africa/Cairo date`
      GMT_P3=`env TZ=Asia/Baghdad date`
      # GMT_P3_30=`env TZ=Iran date`
      GMT_P4=`env TZ=Asia/Tbilisi date`
      GMT_P4_30=`env TZ=Asia/Kabul date`
      GMT_P5=`env TZ=Asia/Yekaterinburg date`
      GMT_P5_30=`env TZ=Asia/Kolkata date`
      GMT_P5_45=`env TZ=Asia/Kathmandu date`
      GMT_P6=`env TZ=Asia/Almaty date`
      GMT_P6_30=`env TZ=Asia/Rangoon date`
      GMT_P7=`env TZ=Asia/Ho_Chi_Minh date`
      GMT_P8=`env TZ=Asia/Shanghai date`
      GMT_P9=`env TZ=Asia/Tokyo date`
      GMT_P9_30=`env TZ=Australia/Adelaide date`
      GMT_P10=`env TZ=Australia/Brisbane date`
      GMT_P11=`env TZ=Asia/Magadan date`
      GMT_P12=`env TZ=Pacific/Auckland date`
      GMT_P12_45=`env TZ=Pacific/Chatham date`
      GMT_P13=`env TZ=Pacific/Samoa date`

      echo "Your current     $CURRENT"
      echo "------------------------------------------------"
      echo "GMT -11          $GMT_11"
      echo "------------------------------------------------"
      echo "GMT -10          $GMT_10"
      echo "------------------------------------------------"
      echo "GMT -9           $GMT_9"
      echo "------------------------------------------------"
      echo "GMT -8           $GMT_8"
      echo "------------------------------------------------"
      echo "GMT -7           $GMT_7"
      echo "------------------------------------------------"
      echo "GMT -6           $GMT_6"
      echo "------------------------------------------------"
      echo "GMT -5           $GMT_5"
      echo "------------------------------------------------"
      echo "GMT -4           $GMT_4"
      echo "------------------------------------------------"
      echo "GMT -3:30        $GMT_3_30"
      echo "------------------------------------------------"
      echo "GMT -3           $GMT_3"
      echo "------------------------------------------------"
      echo "GMT -2           $GMT_2"
      echo "------------------------------------------------"
      echo "GMT -1           $GMT_1"
      echo "------------------------------------------------"
      echo "GMT 0            $GMT_0"
      echo "------------------------------------------------"
      echo "GMT +1           $GMT_P1"
      echo "------------------------------------------------"
      echo "GMT +2           $GMT_P2"
      echo "------------------------------------------------"
      echo "GMT +3           $GMT_P3"
      echo "------------------------------------------------"
      # echo "GMT +3:30        $GMT_P3_30"
      echo "GMT +4           $GMT_P4"
      echo "------------------------------------------------"
      echo "GMT +4:30        $GMT_P4_30"
      echo "------------------------------------------------"
      echo "GMT +5           $GMT_P5"
      echo "------------------------------------------------"
      echo "GMT +5:30        $GMT_P5_30"
      echo "------------------------------------------------"
      echo "GMT +5:45        $GMT_P5_45"
      echo "------------------------------------------------"
      echo "GMT +6           $GMT_P6"
      echo "------------------------------------------------"
      echo "GMT +6:30        $GMT_P6_30"
      echo "------------------------------------------------"
      echo "GMT +7           $GMT_P7"
      echo "------------------------------------------------"
      echo "GMT +8           $GMT_P8"
      echo "------------------------------------------------"
      echo "GMT +9           $GMT_P9"
      echo "------------------------------------------------"
      echo "GMT +9:30        $GMT_P9_30"
      echo "------------------------------------------------"
      echo "GMT +10          $GMT_P10"
      echo "------------------------------------------------"
      echo "GMT +11          $GMT_P11"
      echo "------------------------------------------------"
      echo "GMT +12          $GMT_P12"
      echo "------------------------------------------------"
      echo "GMT +12:45       $GMT_P12_45"
      echo "------------------------------------------------"
      echo "GMT +13          $GMT_P13"
      echo "------------------------------------------------"
    else
        # printf '%s' $1
        echo "COMMING SOON..."
    fi
}
alias ctz=current-time-with-all-zone

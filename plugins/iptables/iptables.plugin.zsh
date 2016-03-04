# Some useful iptables aliases for New SysAdmins


alias fw_show="iptables -L -n -v" # Displaying the Status of Your Firewall
alias fw_show_line="iptables -n -L -v --line-numbers" # Display Line 
alias fw_start="service iptables start" # Start the Firewall
alias fw_restart="service iptables restart" # Restart the Firewall
alias fw_stop="service iptables stop" # Stop the Firewall
alias fw_save="service iptables save" # Save the Firewall
alias fw_icmp_drop="iptables -A INPUT -p icmp --icmp-type echo-request -j DROP" # Block ICMP Ping Request
alias fw_flush="iptables -F"

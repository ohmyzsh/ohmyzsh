CSI="\033["
CEND="${CSI}0m"
CRED="${CSI}1;31m"
CCYAN="${CSI}1;36m"
 
ipban() {
 
ACTION=$1
IP=$2
 
case $ACTION in
"add")
if [[ $IP != "" ]]; then
iptables -A INPUT -s $IP -j DROP
iptables-save > /etc/iptables/rules.v4
fi
;;
"remove")
if [[ $IP != "" ]]; then
iptables -D INPUT -s $IP -j DROP
iptables-save > /etc/iptables/rules.v4
fi
;;
"list")
echo -e "${CCYAN}Liste des adresses ip bannies :${CEND}"
echo -e "${CCYAN}----------------------------------------------------------------${CEND}"
iptables -L INPUT | grep DROP
echo -e "${CCYAN}----------------------------------------------------------------${CEND}"
;;
"count")
CIP=$(iptables -L INPUT | grep DROP | wc -l)
echo -e "Nombre d'adresses ip bannies : ${CRED}$CIP${CEND}"
;;
*)
echo "Utilisation: $0 {add|remove|list|count} [IP]"
esac
}

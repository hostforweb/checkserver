echo -e "\033[1;32m"
hostname
echo -e "\033[1;33m"
echo "-------------------"
top -b -d1 -n1| grep -i "Cpu(s)" | awk '{print "CPU:" $2 }' | head -n1
free -h | grep -i mem | awk '{print "Free Ram: "$7}'
echo "-------------------"
echo -e "\033[1;34m"
echo "Connections on port 80:"
netstat -anp |grep 80 |wc -l
echo "Connections on port 443:"
netstat -anp |grep 443 |wc -l
echo -e '\033[0;37m'
echo "Mysql use:"
mysqladmin processlist
echo -e "\033[1;33m"
echo "DISK USAGE"
df -h -x tmpfs
echo "DISK IOwait"
iotop -qbon1 | grep -vi "total\|actual\|command" | awk '{print $10" "$11" "$12}'| tail -6
echo -e "\033[1;34m"
echo "=========================================Top Email Login count:========================================="
cat /var/log/exim_mainlog | egrep -o 'dovecot_login[^ ]+' | cut -d: -f2 | sort | uniq -c | sort -n |tail -3
echo -e "\033[1;33m"
echo -e "\n=========================================Folders FROM emails were sent=========================================\n" ; grep cwd /var/log/exim_mainlog | grep -v /var/spool | awk -F"cwd=" '{print $2}' | awk '{print $1}' | sort | uniq -c | sort -n | tail -5
echo -e '\033[0;37m'

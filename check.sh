echo -e "\033[1;32m"
hostname
virt-what
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
echo -e "\033[1;32m"
echo "DISK IOwait"
iotop -qbon1 | grep -vi "total\|actual\|command" | awk '{print $10" "$11" "$12}'| tail -6
echo -e "\033[1;34m"
/usr/local/cpanel/3rdparty/bin/perl <(curl -s "https://raw.githubusercontent.com/CpanelInc/tech-SSE/master/msp.pl") --auth
echo -e '\033[0;37m'

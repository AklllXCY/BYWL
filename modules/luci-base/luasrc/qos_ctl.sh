#!/bin/bash
tc qdisc del dev br-lan root
iptables -t mangle  -F POSTROUTING
en=`uci get tastek.control.qos_en_m`
if [[ $? -eq 0 -o $en -eq 1 ]];then
	speed_u=`uci get tastek.control.qos_up_speed`
	if [[ $? -eq 0 ]];then
		speed_d=`uci get tastek.control.qos_down_speed`
		if [[ $? -eq 0 ]];then
			tc qdisc add dev br-lan root handle 1:0 htb default 999
			tc class add dev br-lan parent 1:0 classid 1:1 htb rate $speed_d"Mbit" ceil $speed_d"Mbit"
			tc class add dev br-lan parent 1:0 classid 1:999 htb rate 100Mbit ceil 100Mbit
			tc filter add dev br-lan parent 1:0 prio 10 handle 0x80/0xff fw classid 1:1	
			for i in $(seq 1 5);do
				en=`uci get tastek.control.qos_en$i`
				if [[ $? -eq 0 -o $en -eq 1 ]];then
					ip_s=`uci get tastek.control.qos_ip_s$i`
					if [[ $? -eq 0 ]];then
						ip_e=`uci get tastek.control.qos_ip_e$i`
						iptables -t mangle -A POSTROUTING -m  iprange --dst-range $ip_s-$ip_e -j MARK --or-mark 0x80
						iptables -t mangle -A POSTROUTING -m  iprange --src-range $ip_s-$ip_e -j MARK --or-mark 0x80
					fi
				fi
			done
		fi
	fi
fi


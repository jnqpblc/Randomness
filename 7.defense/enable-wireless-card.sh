#!/bin/bash
ifconfig -a|egrep -o 'wlan[0-9]{1,2}' >/dev/null
if [ $? -eq 0 ];then
        ifconfig $(ifconfig -a|egrep -o 'wlan[0-9]{1,2}') up
        /sbin/wpa_supplicant -c /etc/wpa_supplicant.conf -i $(ifconfig -a|egrep -o 'wlan[0-9]{1,2}') 2>/dev/null &
        dhclient -4 $(ifconfig -a|egrep -o 'wlan[0-9]{1,2}') >/dev/null &
fi

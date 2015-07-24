#!/bin/bash
ifconfig|egrep -o 'tun[0-9]{1,2}' >/dev/null
if [ $? -ne 0 ];then
	killall openvpn
	/usr/sbin/openvpn --config /root/uplink.ovpn --status /var/log/openvpn/status.log 30 --log-append /var/log/openvpn/connection.log &
	else echo "Connection already established."
fi

# OpenVPN persistent connection monitor, runs every minute
# */1 * * * * /usr/local/bin/openvpn-persistence.sh >/dev/null 2>&1

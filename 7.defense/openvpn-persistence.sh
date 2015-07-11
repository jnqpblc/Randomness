#!/bin/bash
/sbin/ifconfig tun0 >/dev/null 2>&1
if [ $? -eq 1 ];then
	killall openvpn
	/usr/sbin/openvpn --config /root/uplink.ovpn --status /var/log/openvpn/status.log 30 --log-append /var/log/openvpn/connection.log &
	else echo "Connection already established."
fi

# OpenVPN persistent connection monitor, runs every minute
# */1 * * * * /usr/local/bin/openvpn-persistence.sh >/dev/null 2>&1

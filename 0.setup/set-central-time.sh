#!/bin/bash
sudo rm -f /etc/localtime 
sudo ln -s /usr/share/zoneinfo/US/Central /etc/localtime
sudo sh -c "echo '15 * * * * root /usr/sbin/ntpdate time.nist.gov' > /etc/cron.d/ntpdate"
sudo /usr/sbin/ntpdate time.nist.gov

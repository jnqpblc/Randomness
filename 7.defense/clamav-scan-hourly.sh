#!/bin/bash
# http://www.digitalsanctuary.com/tech-blog/debian/automated-clamav-virus-scanning.html
SUBJECT="VIRUS DETECTED ON `hostname`!!!"
TO="support@domain.com"
FROM="alerts@domain.com"
LOG="/var/log/clamav/scan.log"
check_scan () {
    # Check the last set of results. If there are any "Infected" counts that aren't zero, we have a problem.
    if [ `tail -n 12 ${LOG}  | grep Infected | grep -v 0 | wc -l` != 0 ]
    then
        EMAILMESSAGE=`mktemp /root/.clamav/virus-alert.XXXXX`
        echo "To: ${TO}" >>  ${EMAILMESSAGE}
        echo "From: ${FROM}" >>  ${EMAILMESSAGE}
        echo "Subject: ${SUBJECT}" >>  ${EMAILMESSAGE}
        echo "Importance: High" >> ${EMAILMESSAGE}
        echo "X-Priority: 1" >> ${EMAILMESSAGE}
        echo "`tail -n 50 ${LOG}`" >> ${EMAILMESSAGE}
        sendmail -t < ${EMAILMESSAGE}
    fi
}
date > /root/.clamav/lastrun.hourly
find / -not -wholename '/sys/*' -and -not -wholename '/proc/*' -mmin -61 -type f -print0 | xargs -0 -r clamscan --exclude-dir=/proc/ --exclude-dir=/sys/ --quiet --infected --log=${LOG}
check_scan
date >> /root/.clamav/lastrun.hourly

# cron.job
# 60 * * * * /usr/local/bin/clamav-scan-hourly.sh

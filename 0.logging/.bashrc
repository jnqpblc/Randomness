
alias msf='msfconsole -r ~/.msf4/msfconsole.rc'
alias msfconsole='msfconsole -r ~/.msf4/msfconsole.rc'
export MSF_DATABASE_CONFIG=/usr/share/metasploit-framework/config/database.yml
alias uag="--script-args http.useragent='Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)'"
alias uay="--script-args http.useragent='Mozilla/5.0 (compatible; Yahoo! Slurp; http://help.yahoo.com/help/us/ysearch/slurp)'"
alias apikey="--script-args http-google-malware.api='{google-api-key}'"

# Added ":\D{%F-%T}~" to the end of the prompt
# Eg. root@kali:~:2015-06-21-07:55:37~#
if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;31m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]:\D{%F-%T}~\$'
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w:\D{%F-%T}~\$'
fi

# Logs all terminal output
# Eg. ~/.terminal-logs/2015-06-02_08:15:25.14622.log
if [ -z "$UNDER_SCRIPT" ]; then
        logdir=$HOME/.terminal-logs
        if [ ! -d $logdir ]; then
                mkdir $logdir
        fi
        #gzip -q $logdir/*.log
        logfile=$logdir/$(date +%F_%T).$$.log
        export UNDER_SCRIPT=$logfile
        script -f -q $logfile
        exit
fi

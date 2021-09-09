#!/bin/bash
if [ -z $2 ]; then printf "\nSyntax: $0 <masscan-output.txt> <{format}|summary|ports|csv|xml|sqlite>\n\n"
else
  if [ $2 == "summary" ]; then
    printf "\nMasscan found $(sort -k 6 $1|wc -l) open TCP ports across $(sort -k 6 $1|awk '{print $6}'|sort -u|wc -l) hosts within scope.\n\n"
    for ip in $(awk '{print $6}' $1|sort -u); do
      printf "$ip : "; egrep " $(echo $ip|sed 's/\./\\./g;') " $1|awk '{print $4}'|sort -n|tr '\n' ' ';
      printf '\n';
    done | sort -n
  elif [ $2 == "ports" ]; then
    printf "\nMasscan found $(sort -k 6 $1|wc -l) open TCP ports across $(sort -k 6 $1|awk '{print $6}'|sort -u|wc -l) hosts within scope.\n\n"
    for port in $(awk '{print $4}' $1|sort -u); do
      printf "$port : "; egrep " $port " $1|awk '{print $6}'|sort -n|tr '\n' ' ';
      printf '\n';
    done | sort -n
  elif [ $2 == "csv" ]; then
    for ip in $(awk '{print $6}' $1|sort -u); do
      printf "$ip,"; egrep "$(echo $ip|sed 's/\./\\./g;')" $1|awk '{print $4}'|sort -n|tr '\n' ','|sed 's/,$//g;';
    done
  elif [ $2 == "xml" ]; then
    printf '<?xml version="1.0"?><nmaprun scanner="masscan" start="1631142488" version="1.0-BETA" xmloutputversion="1.03"><scaninfo type="syn" protocol="tcp"/>'
    count=$(awk '{print $6}' $1|sort -u|wc -l)
    for ip in $(awk '{print $6}' $1|sort -u); do
        printf "<host endtime=\"1631122717\"><address addr=\"$ip\" addrtype=\"ipv4\"/><ports>"
      for protoport in $(egrep "$(echo $ip|sed 's/\./\\./g;')" $1 |awk '{print $4}'|sort -n); do
        port=$(echo $protoport|cut -d'/' -f1);
        proto=$(echo $protoport|cut -d'/' -f2)
        printf "<port protocol=\"$proto\" portid=\"$port\"><state state=\"open\" reason=\"syn-ack\" reason_ttl=\"255\"/></port>"
      done
        printf '</ports></host>'
    done
    echo "<runstats><finished time=\"1631142488\" timestr=\"2021-09-08 19:08:08\" elapsed=\"0\"/><hosts up=\"$count\" down=\"0\" total=\"$count\"/></runstats></nmaprun>"
  elif [ $2 == "sqlite" ]; then
   DBFILE=scan.sqlite
   DBTABLE=scandata
   sqlite3 $DBFILE "CREATE TABLE $DBTABLE(hostname varchar(100), ip varchar(16), port integer(5), protocol varchar(3), state varchar(20), service varchar(100), version varchar(100))"
    for ip in $(awk '{print $6}' $1|sort -u); do
      for port in $(egrep "$(echo $ip|sed 's/\./\\./g;')" $1 |awk '{print $4}'|sort -n); do
        sqlite3 $DBFILE "INSERT INTO $DBTABLE VALUES (\"\", \"$ip\", \"$port\", \"tcp\", \"open\", \"\", \"\")"
      done
    done
  else
    printf "\nSyntax: $0 <masscan-output.txt> <format|summary|csv>\n\n"
  fi
fi

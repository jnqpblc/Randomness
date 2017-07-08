#! /bin/sh
if [ -z $1 ];then printf "\nSyntax: $0 <Length|32|64|128>\n\n"
        else
LEN=$1;
LANG=C tr -dc '[:print:]' </dev/urandom | head -c ${LEN}
printf '\n'
fi

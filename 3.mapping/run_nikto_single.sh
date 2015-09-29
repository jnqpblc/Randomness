#!/bin/bash
if [ -z $3 ];then printf "\nSyntax: $0 <client> <proto> <tagets> <optional|root folder>\n\n"
        else
CLIENT=$1; PROTO=$2; TARGET=$3 ROOT=$4;
if [ -z $4 ]; then
        nikto -host $PROTO://$TARGET | tee "~/$CLIENT/nikto_single_$TARGET_$PROTO.txt"
        else
        nikto -host $PROTO://$TARGET -root "$ROOT" | tee "~/$CLIENT/nikto_single_$TARGET_$PROTO.txt"
fi
fi

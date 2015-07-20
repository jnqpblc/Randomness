#!/bin/bash
if [ -z $1 ];then printf "\nSyntax $0 <file size in MB>\n\n"
   else
      find . -type f -size +$1M -exec ls -lh {} + 2>/dev/null |  sort -nr -k 5
fi

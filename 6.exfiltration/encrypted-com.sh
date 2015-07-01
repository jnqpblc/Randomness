#!/bin/bash
[ $# -ge 1 -a -f "$1" ] && in="$1" || in="-"
printf '\n'
cat "$in" | openssl aes-256-cbc -a | tr '\n' '#';
printf '\n\n'

#!/bin/bash
[ $# -ge 1 -a -f "$1" ] && in="$1" || in="-"
printf '\n'
cat "$in" | tr '#' '\n' | openssl aes-256-cbc -d -a
printf '\n'

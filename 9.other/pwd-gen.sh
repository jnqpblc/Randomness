#! /bin/sh
num=32
if [ x"${1}" = x"-n" ]; then
  num=$2
fi
LANG=C tr -dc '[:print:]' </dev/urandom | head -c ${num}
echo

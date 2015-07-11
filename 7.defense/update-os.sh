#!/bin/bash
/usr/bin/apt-get update -y;
/usr/bin/apt-get upgrade -y;
/usr/bin/apt-get autoremove -y;
/usr/bin/apt-get autoclean -y;

# Automatic updates, runs daily at 2:30 a.m.
# 30 2 * * * /usr/local/bin/update-os.sh >/dev/null 2>&1

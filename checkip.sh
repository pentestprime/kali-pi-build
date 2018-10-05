#!/bin/bash

#Set ALL the variables!
EXTERNAL=$(curl https://icanhazip.com)
INTERNAL=$(ip a s|sed -ne '/127.0.0.1/!{s/^[ \t]*inet[ \t]*\([0-9.]\+\)\/.*$/\1/p}')
FROM=UUUU
PASS=PPPP
TO=TTTT

sendemail -f $FROM -t $TO -u "Automated IP Address Report from system $(hostname)" \
-m "Your IP address is as follows: \
\n \
External IP Address: $EXTERNAL \
\n \
Internal IP Address: $INTERNAL" \
-s "smtp.gmail.com:587" -o tls=yes \
-xu $FROM -xp $PASS
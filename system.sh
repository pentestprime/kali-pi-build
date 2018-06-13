#!/bin/bash
#===========================
# Start init
#===========================
function pause(){
    echo 'Press any key to continue...';   read -p "$*"
}
#  End INIT

echo "Resizing root partition..."

SDCARD="/dev/mmcblk0"

#Here I'm just piping the keystrokes I would be typing at the fdisk prompt
#directly into the fdisk command, complete with newlines for Enter.
#Needless to say, DO NOT TOUCH UNLESS YOU KNOW WHAT YOU'RE DOING!!!
fdisk "$SDCARD" <<EOF
d
2
n
p
2


w
EOF

exit 0
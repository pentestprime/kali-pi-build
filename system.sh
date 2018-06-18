#!/bin/bash
#===========================
# Start init
#===========================
function pause(){
    echo 'Press any key to continue...';   read -p "$*"
}
#  End INIT

#=================================================
#===========  Start Main script ==================
#=========== Version 2.0.2  6-18-2018 ==============
#=================================================

echo "Resizing root partition..."

SDCARD="/dev/mmcblk0"
ROOT="p2"

#Here I'm just piping the keystrokes I would be typing at the fdisk prompt
#directly into the fdisk command, complete with newlines for Enter.
#Needless to say, DO NOT TOUCH UNLESS YOU KNOW WHAT YOU'RE DOING!!!
fdisk "$SDCARD" <<EOF
d
2
n
p
2
125001

n
w
EOF

#Tell the kernel about our new partition size
partprobe

echo "Resizing root filesystem..."
resize2fs "$SDCARD""$ROOT"

exit 0

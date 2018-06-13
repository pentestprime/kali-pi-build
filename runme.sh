#!/bin/bash
#===========================
# Start init
#===========================
function pause(){
    echo 'Press any key to continue...';   read -p "$*"
}

#Make this script restart after reboot
cp ~/.xprofile ~/.xprofile.bak
cat << EOF > ~/.xprofile
#!/bin/sh
xfce4-terminal -x CCCC
EOF

sed -i "s|CCCC|$0|g" ~/.xprofile

#  End INIT

clear
echo " _  __     _ _   ____ ___   _____   ___           _        _ _ " 
echo "| |/ /__ _| (_) |  _ \_ _| |___ /  |_ _|_ __  ___| |_ __ _| | |"
echo "|   // _  | | | | |_) | |    |_ \   | ||  _ \/ __| __/ _  | | |"
echo "|   \ (_| | | | |  __/| |   ___) |  | || | | \__ \ || (_| | | |"
echo "|_|\_\__,_|_|_| |_|  |___| |____/  |___|_| |_|___/\__\__ _|_|_|"
echo " "
echo " By Don Bowers"
echo " "
echo " This script will automatically install and configure several things"
echo " to make the Raspberry Pi function as a penetration testing tool."
echo " One of those things is the ability for the Pi to run in headless"
echo " mode.  The Pi will have the ability to boot and automatically start"
echo " a WAP to allow remote login.  The Pi will send an email"
echo " notification with the IP address of the Pi to allow remote access."
echo " "
echo " For this script to work you will need a GMail account to send"
echo " email from and another account to receive the response."
echo " "
echo " Also, please note that the system will automatically reboot"
echo " during the install process."
echo " The script should automatically relaunch itself after rebooting."
echo " " 
pause

bash system.sh

echo "We need to reboot now..."
pause
reboot now

echo "Resizing root filesystem..."
SDCARD="/dev/mmcblk0"
ROOT="p2"
resize2fs "$SDCARD""$ROOT"

bash headless.sh
bash software.sh

echo "Cleanup..."
rm ~/.xprofile
cp ~/.xprofile.bak ~/.xprofile

echo " "
echo " "
echo "Deep breath...Finished"
echo "Enjoy the Pi..."
echo " "
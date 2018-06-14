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
#=========== Version 2.0  6-14-2018 ==============
#=================================================

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
echo " " 
pause

#Expand root partition
bash system.sh

echo "Updating Repository..."
apt update 
echo "Updating System..."
apt upgrade -y

#Install software and configuration for headless operation
bash headless.sh
#Install additional productivity software
bash software.sh

echo " "
echo " "
echo "Deep breath...Finished."
echo "A reboot is recommended before use."
echo "Enjoy the Pi..."
echo " "

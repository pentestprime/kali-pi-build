#!/bin/bash
#===========================
# Start init
#===========================
function pause(){
echo 'Press any key to continue...';   read -p "$*"
}
#  End INIT
#===========================
#  Start Main script       
#============================
clear
echo " _  __     _ _   ____ ___   _____   ___           _        _ _ " 
echo "| |/ /__ _| (_) |  _ \_ _| |___ /  |_ _|_ __  ___| |_ __ _| | |"
echo "|   // _  | | | | |_) | |    |_ \   | ||  _ \/ __| __/ _  | | |"
echo "|   \ (_| | | | |  __/| |   ___) |  | || | | \__ \ || (_| | | |"
echo "|_|\_\__,_|_|_| |_|  |___| |____/  |___|_| |_|___/\__\__ _|_|_|"

echo " By Don Bowers"
echo " "
echo " This script will automatically install and configure several things"
echo " to make the raspberry PI function as a penetration testing tool."
echo " One of those things is the ability for the PI to run in headless"
echo " mode.  The Pi will have the ability to boot, automatically start"
echo " a WAP to allow remote login.  The Pi will also send an email"
echo " notification with the IP address of the PI to allow access"
echo " "
echo " For headless mode to work you will need a gmail account to sned"
echo " email to and another account to receive the response."
echo " " 
pause
#===============================
# Ask the user for login details
#===============================
while true; do
clear
echo "                Getting WPA and Email Information"
echo " ____________________________________________________________________"
echo " "
     read -p 'Enter the SSID for your WPA........................' ssidvar
     read -p 'Enter the Password for you WPA.....................' passvar
     read -p 'Enter the email you wish to send the IP email to...' tovar
     read -p 'Enter the email account to relay from..............' fromvar
     read -p 'Enter the password for that account................' frompassvar
echo " "
    read -p "Is the information you entered correct?(y/n) " yn
    case $yn in
        [Yy]* ) break;;
        * ) echo " ";;
    esac
done
echo "Updating Repository..."
apt update 
echo "Installing xrdp Desktop..."
apt install xrdp -y 
echo "Installing gparted Disk Partition Application..."
apt install gparted -y 
echo "Now we need to resize the diwk partition..."
pause
gparted
pause
echo "Adding several commands to .bashrc..."
echo "alias ll='ls --color'" >> .bashrc
echo "alias fman=thunar" >>.bashrc
echo "Added commands to .bashrc" 
echo "Turning off Screen Power Options..."
xset -dpms
echo "Installing Headless Software...Pleas Wait"
apt install hostapd -y 
apt install bridge-utils -y 
apt install sendmail -y 
echo "Creating Interfaces file for Bridged Network..."
cat << EOF > /etc/network/interfaces
#Interface Settings for Briged Interface
auto lo br0
iface lo inet loopback
# wireless wlan0
allow-hotplug wlan0
iface wlan0 inet manual
# eth0 connected to the ISP router
allow-hotplug eth0
iface eth0 inet manual
# Setup bridge
iface br0 inet dhcp
    bridge_ports wlan0 eth0
EOF
echo "Configuring Default hostapd files"
cat << EOF > /etc/default/hostapd
DAEMON_CONF="/etc/hostapd/hostapd.conf"
EOF
cat << EOF > /etc/hostapd/hostapd.conf
interface=wlan0
bridge=br0
driver=nl80211
country_code=US
ssid=SSSS
hw_mode=g
channel=6
wpa=2
wpa_passphrase=PPPP
wpa_key_mgmt=WPA-PSK
wpa_pairwise=TKIP
rsn_pairwise=CCMP
auth_algs=1
macaddr_acl=0
EOF
sed -i "s|SSSS|$ssidvar|g" /etc/hostapd/hostapd.conf
sed -i "s|PPPP|$passvar|g" /etc/hostapd/hostapd.conf
echo "Starting Hostapd Service"
systemctl enable hostapd 
systemctl start hostapd 
echo "Creating Email Responder Script"
mkdir /root/scripts
cat << EOF > /root/scripts/checkip.py
#!/usr/bin/env python 
# modified from http://elinux.org/RPi_Email_IP_On_Boot_Debian 
import subprocess 
import smtplib 
import socket 
from email.mime.text import MIMEText 
import datetime 
import urllib2 
# Change to your own account information 
to = 'TTTT' 
gmail_user = 'UUUU' 
gmail_password = 'PPPP' 
smtpserver = smtplib.SMTP('smtp.gmail.com', 587) 
smtpserver.ehlo() 
smtpserver.starttls() 
smtpserver.ehlo 
smtpserver.login(gmail_user, gmail_password) 
today = datetime.date.today() 
# Very Linux Specific 
arg='ip route list' 
p=subprocess.Popen(arg,shell=True,stdout=subprocess.PIPE) 
data = p.communicate() 
split_data = data[0].split() 
ipaddr = split_data[split_data.index('src')+1] 
extipaddr = urllib2.urlopen("http://icanhazip.com").read() 
my_ip = 'Local address: %s\nExternal address: %s' %  (ipaddr, extipaddr) 
msg = MIMEText(my_ip) 
msg['Subject'] = 'IP For RaspberryPi on %s' % today.strftime('%b %d %Y') 
msg['From'] = gmail_user 
msg['To'] = to 
smtpserver.sendmail(gmail_user, [to], msg.as_string()) 
smtpserver.quit() 
EOF
echo "Configuring Email Responder"
sed -i "s|TTTT|$tovar|g" /root/scripts/checkip.py
sed -i "s|UUUU|$fromvar|g" /root/scripts/checkip.py
sed -i "s|PPPP|$frompassvar|g" /root/scripts/checkip.py
chmod +x /root/scripts/checkip.py
echo "Creating Email Responder Service"
cat << EOF > /lib/systemd/system/checkip.service
[Unit]
Description=IP Check Script
After=network.target

[Service]
Type=oneshot
ExecStart=/usr/bin/python /root/scripts/checkip.py

[Install]
WantedBy=multi-user.target
EOF
echo "Starting Email Responder Service"
echo "You should get an email"
systemctl start checkip.service 
systemctl enable checkip.service
#=======================================
# Starting Productivity Software and Configuration
#========================================
echo "Installing Productivity Software, this might take a wile..."
apt install bleachbit -y
apt install apt-file -y
apt install scrub -y
apt install tor -y
apt install proxychains -y
apt install htop -y
apt install evince -y
apt install watchdog -y
apt install whois -y
apt install netcat -y
apt install php -y 
apt install screenfetch -y 
apt install cups -y
apt install cups-client -y 
apt install foomatic.db -y 
apt install libreoffice -y 
apt install gimp -y 
apt install metasploit-framework -y 
apt install websploit -y 
apt install gedit -y 
apt install postgresql -y
apt install fwbuilder -y 
echo "Installing Microsoft Visual Studio Code..."
. <( wget -O - https://code.headmelted.com/installers/apt.sh ) >> update.log
echo "Installing Discover Script..."
git clone https://github.com/leebaird/discover.git >> update.log
chmod +x /root/discover/discover.sh
echo "Installing Lazy Script"
git clone https://github.com/arismelachroinos/lscript >> update.log
chmod +x /root/lscript/install.sh
echo "Configuring Proxychains"
cp /etc/proxychains.conf /etc/proxychains.bak
cat << EOF > /etc/proxychains.conf
# proxychains.conf  VER 3.1
#	
dynamic_chain
proxy_dns 
tcp_read_time_out 15000
tcp_connect_time_out 8000
[ProxyList]
socks4 	127.0.0.1 9050
socks5  127.0.0.1 9050
EOF
echo "Configuring Watchdog System"
modprobe bcm2835_wdt 
cat << EOF > /etc/modules
# /etc/modules: kernel modules to load at boot time.
#
# This file contains the names of kernel modules that should be loaded
# at boot time, one per line. Lines beginning with "#" are ignored.
bcm2835_wdtl
EOF
cat << EOF > /etc/watchdog.conf
max-load-1		= 24
watchdog-device	= /dev/watchdog
realtime		= yes
priority		= 1
EOF
echo "Starting Final Services"
systemctl start apache >> update.log
systemctl enable apache >> update.log
systemctl start tor >> update.log
systemctl enable tor >> update.log
systemctl start postgresql >> update.log
systemclt enable postgresql >> update.log
systemctl start xrdp >> update.log
systemctl enable xrdp >> update.log
systemctl start cups >> update.log
systemctl enable cups >> update.log
systemctl enable watchdog >> update.log
systemctl start watchdog >> update.log
#
#
echo "Initializing Databases"
msfdb init
updatedb
echo "Please wait...I am upgrading the system...."
echo "You may be required to respond to system prompts"
echo "Typically choose the defaults unless you have"
echo "a good reason to change them.."
echo "This could take some time depending on how new the image is..."
apt upgrade -y
echo " "
echo " "
echo " "
echo "Deep Breath.....Finished"
echo "Install data was written to update.log"
echo "Enjoy the PI..."
# End of script

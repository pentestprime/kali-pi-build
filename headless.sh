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
#=========== Version 2.0.1  6-18-2018 ==============
#=================================================
clear


#========================================
#========== WPA and Email Setup =========
#========================================
while true; do
    clear
    echo "                Getting WPA and Email Information"
    echo " ____________________________________________________________________"
    echo " "
        read -p '  Enter the SSID for your WPA...............' ssidvar
        read -p '  Enter the Password for your WPA...........' passvar
        read -p '  Enter the email to send the IP email to...' tovar
        read -p '  Enter the email account to relay from.....' fromvar
        read -p '  Enter the password for the relay account..' frompassvar
    echo " "
        read -p "Is the information you entered correct?(y/n) " yn
        case $yn in
            [Yy]* ) break;;
            * ) echo " ";;
        esac
done

#=====================================
#=========== Basic Config ============
#=====================================

echo "Adding several commands to .bashrc..."
echo "alias ll='ls --color'" >> /root/.bashrc
echo "alias fman=thunar" >>/root/.bashrc
echo "alias cls=clear" >> /root/.bashrc

#====================================
#===== Headless Configuration =======
#====================================
echo "Installing Headless Software... Please Wait"
apt install hostapd -y
apt install bridge-utils -y
apt install sendmail -y

echo "Creating Interfaces file for Bridged Network..."
cp /etc/network/interfaces /etc/network/interfaces.bak
cat << EOF > /etc/network/interfaces
#Interface Settings for Bridged Interface
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

cp /etc/default/hostapd /etc/default/hostapd.bak
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
extipaddr = urllib2.urlopen("http://icanhazip.com").read() \
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

#
echo "Creating Email Responder Service"
#

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

echo "Configuring Watchdog System"
apt install watchdog -y
modprobe bcm2835_wdt
cp /etc/modules /etc/modules.bak

cat << EOF > /etc/modules
# /etc/modules: kernel modules to load at boot time.
# This file contains the names of kernel modules that should be loaded
# at boot time, one per line. Lines beginning with "#" are ignored.
bcm2835_wdtl
EOF

cp /etc/watchdog.conf /etc/watchdog.bak
cat << EOF > /etc/watchdog.conf
max-load-1		= 24
watchdog-device	= /dev/watchdog
realtime		= yes
priority		= 1
EOF

#=========================================================
#=============== Installing Critical Software ============
#=========================================================
echo ' '
echo 'Installing Critical Software'
apt install xrdp gedit cups cups-client foomatic-db -y
echo ' '
echo 'Starting Critical Systems '
echo "Starting Email Responder Service"
echo "You should now get an email..."
systemctl start checkip.service 
systemctl enable checkip.service
systemctl start cups
systemctl enable cups
systemctl start apache2
systemctl enable apache2
systemctl start xrdp
systemctl enable xrdp
systemctl start watchdog
systemctl enable watchdog
updatedb

exit 0

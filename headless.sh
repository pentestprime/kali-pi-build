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
#===========  Version 2.0.4  2019-01-09 ==========
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
        read -p '  Enter the device you want to use for hostapd..' devicevar
        read -p '  Enter the SSID for your WPA...................' ssidvar
        read -p '  Enter the Password for your WPA...............' passvar
        read -p '  Enter the email to send the IP email to.......' tovar
        read -p '  Enter the email account to relay from.........' fromvar
        read -p '  Enter the password for the relay account......' frompassvar
    echo " "
        read -p "Is the information you entered correct?(y/n) " yn
        case $yn in
            [Yy]* ) break;;
            * ) echo " ";;
        esac
done

if [[ -n $SUDO_USER ]]; then
    HOMEDIR=/home/$SUDO_USER
else
    HOMEDIR=/root
fi

#=====================================
#=========== Basic Config ============
#=====================================

echo "Adding several commands to .bashrc..."
echo "alias ll='ls --color'" >> $HOMEDIR/.bashrc
echo "alias fman=thunar" >> $HOMEDIR/.bashrc
echo "alias cls=clear" >> $HOMEDIR/.bashrc

#====================================
#===== Headless Configuration =======
#====================================
echo "Installing Headless Software... Please Wait"
apt install hostapd -y
apt install bridge-utils -y
apt install sendemail -y

echo "Creating Interfaces file for Bridged Network..."
cp /etc/network/interfaces /etc/network/interfaces.bak
cat << EOF > /etc/network/interfaces
#Interface Settings for Bridged Interface
auto lo br0
iface lo inet loopback
# wireless DDDD
allow-hotplug DDDD
iface DDDD inet manual
# eth0 connected to the ISP router
allow-hotplug eth0
iface eth0 inet manual
# Setup bridge
iface br0 inet dhcp
bridge_ports DDDD eth0
EOF

sed -i "s|DDDD|$devicevar|g" /etc/network/interfaces

cp /etc/default/hostapd /etc/default/hostapd.bak
echo "Configuring Default hostapd files"
cat << EOF > /etc/default/hostapd
DAEMON_CONF="/etc/hostapd/hostapd.conf"
EOF

cat << EOF > /etc/hostapd/hostapd.conf
interface=DDDD
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

sed -i "s|DDDD|$devicevar|g" /etc/hostapd/hostapd.conf
sed -i "s|SSSS|$ssidvar|g" /etc/hostapd/hostapd.conf
sed -i "s|PPPP|$passvar|g" /etc/hostapd/hostapd.conf

echo "Starting hostapd"
systemctl unmask hostapd
systemctl enable hostapd
echo "Creating Email Responder Script"
mkdir /root/scripts
cp checkip.sh /root/scripts/

echo "Configuring Email Responder"
sed -i "s|TTTT|$tovar|g" /root/scripts/checkip.sh
sed -i "s|UUUU|$fromvar|g" /root/scripts/checkip.sh
sed -i "s|PPPP|$frompassvar|g" /root/scripts/checkip.sh
chmod +x /root/scripts/checkip.sh

#
echo "Creating Email Responder Service"
#

cat << EOF > /lib/systemd/system/checkip.service
[Unit]
Description=IP Check Script
After=network.target

[Service]
Type=oneshot
ExecStart=/bin/bash /root/scripts/checkip.sh

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
apt install xrdp gedit cups cups-client foomatic-db cockpit -y
echo ' '
#
# Disable special windows manager tweak compositing off
xfconf-query -c xfwm4 -p /general/use_compositing -s false
echo 'Starting Critical Systems '
echo "Starting Email Responder Service"
echo "You should now get an email..."
systemctl enable checkip.service --now
systemctl enable cups --now
systemctl enable apache2 --now
systemctl enable xrdp --now
systemctl enable watchdog --now
systemctl enable cockpit.socket --now
updatedb

exit 0

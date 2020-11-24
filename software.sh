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
#=========== Version 2.0.4  2019-01-09 ==============
#=================================================
clear
echo '    __ __      ___    ____             __        ____           __        ____'
echo '   / //_/___ _/ (_)  / __ \____  _____/ /_      /  _/___  _____/ /_____ _/ / /'
echo '  / ,< / __ `/ / /  / /_/ / __ \/ ___/ __/_____ / // __ \/ ___/ __/ __ `/ / / '
echo ' / /| / /_/ / / /  / ____/ /_/ (__  ) /_/_____// // / / (__  ) /_/ /_/ / / /  '
echo '/_/ |_\__,_/_/_/  /_/    \____/____/\__/     /___/_/ /_/____/\__/\__,_/_/_/   '
echo '                                                                            '
echo 'By Don Bowers '
echo ' ' 

#==================================================================
#=== Starting Productivity Software Install and  Configuration  ===
#==================================================================
echo "Installing Productivity Software, this might take a wile..."
apt install bleachbit apt-file scrub tor proxychains gparted -y
apt install htop evince whois php netcat screenfetch theharvester locate -y
apt install libreoffice -y
apt install gimp -y
apt install metasploit-framework -y
apt install websploit postgresql fwbuilder -y
apt install tmux guake -y

#Currently breaks.  Needs replacing with VSCodium.
#echo "Installing Microsoft Visual Studio Code..."
#. <( wget -O - https://code.headmelted.com/installers/apt.sh )

cd /root/scripts
echo "Installing EZsploit..."
git clone https://github.com/rand0m1ze/ezsploit
chmod +x `pwd`/ezsploit/ezsploit.sh

echo "Installing PTF..."
git clone https://github.com/trustedsec/ptf
cd

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

echo "Starting Final Services"
systemctl enable postgresql --now
msfdb init

exit 0

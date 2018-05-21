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
#==========Version 1.1.7  5-21.2018 ==============
#=================================================
clear
echo '    __ __      ___    ____             __        ____           __        ____'
echo '   / //_/___ _/ (_)  / __ \____  _____/ /_      /  _/___  _____/ /_____ _/ / /'
echo '  / ,< / __ `/ / /  / /_/ / __ \/ ___/ __/_____ / // __ \/ ___/ __/ __ `/ / / '
echo ' / /| / /_/ / / /  / ____/ /_/ (__  ) /_/_____// // / / (__  ) /_/ /_/ / / /  '
echo '/_/ |_\__,_/_/_/  /_/    \____/____/\__/     /___/_/ /_/____/\__/\__,_/_/_/   '
echo '                                                                            '
echo 'Don Bowers '
echo ' ' 
#==================================================================
#=== Starting Productivity Software Install and  Configuration  ===
#==================================================================
echo "Installing Productivity Software, this might take a wile..."
apt install bleachbit -y
apt install apt-file -y
apt install scrub -y
apt install tor -y
apt install proxychains -y
apt install htop -y
apt install evince -y
apt install whois -y
apt install netcat -y
apt install php -y 
apt install screenfetch -y 
apt install libreoffice -y 
apt install gimp -y 
apt install metasploit-framework -y 
apt install websploit -y 
apt install postgresql -y
apt install fwbuilder -y 
echo "Installing Microsoft Visual Studio Code..."
. <( wget -O - https://code.headmelted.com/installers/apt.sh ) 
echo "Installing Discover Script..."
git clone https://github.com/leebaird/discover.git 
chmod +x /root/discover/discover.sh
echo "Installing Lazy Script"
git clone https://github.com/arismelachroinos/lscript 
chmod +x /root/lscript/install.sh
echo "Installing EZsploit"
git clone https://github.com/rand0m1ze/ezsploit
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
systemctl enable tor 
systemclt enable postgresql 
msfdb init

echo " "
echo " "
echo "Deep breath...Finished"
echo "Enjoy the PI..."
echo " "
#=============================================
# End of script  =============================
#=============================================

﻿# kali-pi-build
Kali Linux on Raspberry PI 3, 3b+ Post Install

The install.sh script is a post-install script for the Raspberry PI running Kali Linux.  Copy the script to the users home directory and make it executable. 

The script does a log of things, some of these are as follows:
- Wireless Access Point (WPA)
- Email Responder to email iP addrss
- Resize Micro SSD card
- Configure Headless operation
- Add custom commands to .bashrc
- Reset ssH keys
- Install and configure TOR with Proxychains
- Add Printer support
- Install and Configure Watchdog - use:   :(){ :|: & };:   to test
- Install other applications such as libreoffice, bleachbit, screenfetch
  Ezsploit, websploit, Discover script, Lazy Script, Microsoft Code Editor,
  and more…

Critical file locations used in this project:

Bash Commands

	/root/.bashrc

Network Configuration

	/etc/network/interfaces

Hostapd files

	/etc/default/hostapd
	/etc/hostapd/hostapd.conf

Email Configuration files

	/root/scripts/checkip.py
	/lib/systemd/system/checkip.service

Watchdog Configuration files

	/etc/modules
	/etc/watchdog.conf 

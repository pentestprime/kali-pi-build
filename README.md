﻿# kali-pi-build 
Kali Linux for Raspberry Pi 3, 3b+ Post Install Scripts

These scripts are for the Raspberry Pi running Kali Linux.  The system.sh script will automatically expand your root partition.  The headless.sh script will install and configure critical software for headless operation.  The software.sh script will install other software needed for a penetration tester.

The scripts do a variety of things:
- Configure Wireless Access Point (WPA)
- Email Responder to email IP addrss
- Resize Root Partition
- Configure headless operation
- Add custom commands to .bashrc
- Install and configure TOR with Proxychains
- Add Printer support
- Install and Configure Watchdog - use:   :(){ :|: & };:   to test
- Install additional applications including Libreoffice, Bleachbit, Screenfetch,
  EZ-Sploit, Websploit, Microsoft VS Code, 
  and more…

# Installing
Run the runme.sh script.

If you choose, you can run the "extra.sh" script to install some additional tools (currently Lee Baird's Discover Script and Lazy Script), however, this is not recommended to do by default.

# Files
Critical file locations used in this project:

Additional Software (Discover Script, EZ-Sploit, and PTF)

	/root/bin

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

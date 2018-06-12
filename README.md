﻿# kali-pi-build 
Kali Linux for Raspberry Pi 3, 3b+ Post Install Scripts

These install.sh and post-install.sh scripts are for the Raspberry Pi running Kali Linux.  Copy the scripts to your home directory and make it executable.  The install.sh script will install critical software for headless operation.  The post-install.sh script will install other software needed for a penetration tester.

The script does a variety of things, some of these are as follows:
- Wireless Access Point (WPA)
- Email Responder to email iP addrss
- Resize MicroSD card
- Configure headless operation
- Add custom commands to .bashrc
- Regenerate SSH keys
- Install and configure TOR with Proxychains
- Add Printer support
- Install and Configure Watchdog - use:   :(){ :|: & };:   to test
- Install additional applications including Libreoffice, Bleachbit, Screenfetch,
  EZ-Sploit, Websploit, Lee Baird's discover script, Lazy Script, Microsoft VS Code,
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

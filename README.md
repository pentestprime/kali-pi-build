# kali-pi-build
Kali Linux on Raspberry PI 3, 3b+ Post Install

The install.sh script is a post-install script for the Raspberry PI running Kali Linux.  Copy the script to the users home directory and make it executable. 

The script does a log of things, some of these are as follows:
	1. Create a wireless access point (WAP) with the wlan0 card in the PI
	2. Allows the user to choose the WAP name and password, make sure the 
	password is at least 8 characters.
	3. Sends the user a email with the current IP address of the PI. This
	will allow the user to login remote via putty or xrdp remotely.  The user
	must have an email account to send email to and a gmail account to 
    	send the email from.  You may need to modify the security on the gmail
	account for this to work.
	4.  This script installs and configures a lot of other software not part of
	image such as metasploit, libreoffice, tor, screenfetch and so on.	

#!/bin/bash
#===================
#   hostapd init
#===================
iw phy phy0 interface add mon0 type monitor && ifconfig mon0 up
systemctl start hostapd
exit 0


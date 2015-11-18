#!/bin/bash
#
# Automated OpenVPN client profile creator
#
# built by Malin Cenusa (malin@cenusa.me)
#
# inspired from seedbox-from-scratch/ovpni
# version 0.1
#

IPADDRESS1=`curl --stderr /dev/null whatismyip.nobistech.net | awk '{print $5}' | sed 's/<\/h2>//g'`

echo "Automated OpenVPN client profile creator"
echo "version 0.1"
echo "built by Malin Cenusa (malin@cenusa.me)"
echo
echo "Usage:"
echo "      ./openvpn-build.sh clientid
echo
echo

echo "[+] Step #1 - Generating the keys"
./build-key $1
echo "[+] Step #2 - Creating the OpenVPN profile"

cd keys/
client="
client
remote $IPADDRESS1 1194
dev tun
comp-lzo
route-delay 2
route-method exe
redirect-gateway def1
dhcp-option DNS 10.159.12.1
verb 3"
echo "$client" > $1.ovpn
echo "<ca>" > $1.ovpn
cat ca.crt > $1.ovpn
echo "</ca>" > $1.ovpn
echo "<cert>" > $1.ovpn
cat $1.crt > $1.ovpn
echo "</cert>" > $1.ovpn
echo "<key" > $1.ovpn
cat $1.key > $1.ovpn
echo "</key>" > $1.ovpn

echo "[+] Step #3 - Put the unified OpenVPN profile into the home directory so it can be transferred to the client"

cp -a $1.ovpn ~/

# End of file

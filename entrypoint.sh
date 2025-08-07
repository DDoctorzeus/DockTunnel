#!/bin/sh

# Ensure running as root
if [ "$(id -u)" -ne 0 ]; then
   echo "This script must be run as root";
   exit 1;
fi

# Grab env vars and set defaults if not set already
if [ -z $VPNCONFNAME ]; then
    VPNCONFNAME="ovpn.conf";
fi
if [ -z $PROXYBINDIP ]; then
    PROXYBINDIP="0.0.0.0";
fi
# This doesn't really matter when running under docker as can just re-bind the port when container created but just in case
if [ -z $PROXYPORT ]; then
    PROXYPORT="8080";
fi

# Start openvpn (forks to de-escalated user perms)
echo "[DockTunnel] Starting OpenVPN...";
openvpn --config /vpn/$VPNCONFNAME --cd /vpn --user openvpn --group openvpn --daemon --log /var/log/openvpn.log;

# Wait for tun0 to come up
echo "[DockTunnel] Waiting for VPN tunnel (tun0)...";
while ! ip a show tun0 2>/dev/null | grep ",UP"; do
    sleep 1;
done

echo "[DockTunnel] VPN tunnel established.";

echo "[DockTunnel] Starting proxy server on $PROXYBINDIP:$PROXYPORT";
if [ -z $ENABLEPROXYLOGGING ]; then
    sudo -u microsocks microsocks -i $PROXYBINDIP -p $PROXYPORT -b tun0 2>/dev/null;
else
    echo "[DockTunnel] WARNING: Proxy logging is enabled.";
    sudo -u microsocks microsocks -i $PROXYBINDIP -p $PROXYPORT -b tun0;
fi
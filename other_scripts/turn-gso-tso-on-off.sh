# run it at the sender
# if you don't have VLAN delete the last two lines
sudo ethtool -K eth1 tso $1
sudo ethtool -K eth1 gso $1
sudo ethtool -K vlan1618 gso $1
sudo ethtool -K vlan1618 tso $1

# run it at the receiver

sudo ethtool -K eth1 gro $1
sudo ethtool -K eth1 lro $1
sudo ethtool -K vlan390 gro $1
sudo ethtool -K vlan390 lro $1

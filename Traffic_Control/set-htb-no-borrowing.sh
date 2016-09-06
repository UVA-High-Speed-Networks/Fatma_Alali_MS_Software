# no borrowing between classes is allowed in this script
# disablinf borrowing is achived by creating multiple parent classes attached
# to the root class

limit=10mb
ETH_IF=eth1

sudo tc qdisc del dev $ETH_IF root

sudo tc qdisc add dev $ETH_IF root handle 1: htb

sudo tc class add dev $ETH_IF parent 1: classid 1:1 htb rate 20mbit
sudo tc class add dev $ETH_IF parent 1: classid 1:2 htb rate 80mbit
sudo tc class add dev $ETH_IF parent 1:1 classid 1:10 htb rate 20mbit
sudo tc class add dev $ETH_IF parent 1:2 classid 1:11 htb rate 80mbit

#add leaf qdiscs to control the buffer size for each class
sudo tc qdisc add dev $ETH_IF parent 1:10 handle 10: bfifo limit $limit
sudo tc qdisc add dev $ETH_IF parent 1:11 handle 11: bfifo limit $limit

#filter: decide which packets go to which class
U32="sudo tc filter add dev $ETH_IF protocol ip parent 1:0 prio 1 u32"
$U32 match ip dport 5004 0xffff flowid 1:10
$U32 match ip dport 5005 0xffff flowid 1:11

#you can filter using the IP address as follows:
#sudo tc filter add dev eth1 protocol ip parent 1:0 prio 1 u32 match ip dst 10.10.1.2/32 flowid 1:10


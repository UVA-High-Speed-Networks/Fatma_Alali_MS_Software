
limit=30mb

sudo tc qdisc del dev vlan390 root

sudo tc qdisc add dev vlan390 root handle 1: htb

sudo tc class add dev vlan390 parent 1: classid 1:1 htb rate 20mbit
sudo tc class add dev vlan390 parent 1: classid 1:2 htb rate 80mbit
sudo tc class add dev vlan390 parent 1:1 classid 1:10 htb rate 20mbit
sudo tc class add dev vlan390 parent 1:2 classid 1:11 htb rate 80mbit


sudo tc qdisc add dev vlan390 parent 1:10 handle 10: bfifo limit $limit
sudo tc qdisc add dev vlan390 parent 1:11 handle 11: bfifo limit $limit

U32="sudo tc filter add dev vlan390 protocol ip parent 1:0 prio 1 u32"
$U32 match ip dport 5004 0xffff flowid 1:10
$U32 match ip dport 5005 0xffff flowid 1:11

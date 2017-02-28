# This script allows borrowing between classes

IF=eth1
limit=20mb

sudo tc qdisc del dev $IF root

sudo tc qdisc add dev $IF root handle 1: htb default 12
sudo tc class add dev $IF parent 1: classid 1:1 htb rate 900mbit ceil 900mbit

sudo tc class add dev $IF parent 1:1 classid 1:10 htb rate 300mbit ceil 900mbit
sudo tc class add dev $IF parent 1:1 classid 1:11 htb rate 300mbit ceil 900mbit
sudo tc class add dev $IF parent 1:1 classid 1:12 htb rate 300mbit ceil 900mbit

#add leaf qdiscs to control the buffer size for each class
#if none is specified pfifo is attached by default
# pfifo: packet FIFO, where limit is specified by packets
# bfifi: byte FIFO, where limit is specified by bytes
sudo tc qdisc add dev $IF parent 1:10 handle 10: bfifo limit $limit
sudo tc qdisc add dev $IF parent 1:11 handle 11: bfifo limit $limit

U32="sudo tc filter add dev $IF protocol ip parent 1:0 prio 1 u32"
$U32 match ip dport 5002 0xffff flowid 1:10
#$U32 match ip dport 5003 0xffff flowid 1:11
#$U32 match ip dport 5004 0xffff flowid 1:12

#or filter by IP address
#sudo tc filter add dev $IF protocol ip parent 1:0 prio 1 u32 match ip dst 10.10.1.2/32 flowid 1:10~                                                                               

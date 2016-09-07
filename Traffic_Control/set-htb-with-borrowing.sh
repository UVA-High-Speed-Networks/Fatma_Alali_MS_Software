# This script allows borrowing between classes

IF=eth1

sudo tc qdisc del dev eth1 root

sudo tc qdisc add dev eth1 root handle 1: htb default 12
sudo tc class add dev eth1 parent 1: classid 1:1 htb rate 900mbit ceil 900mbit

sudo tc class add dev eth1 parent 1:1 classid 1:10 htb rate 300mbit ceil 900mbit
sudo tc class add dev eth1 parent 1:1 classid 1:11 htb rate 300mbit ceil 900mbit
sudo tc class add dev eth1 parent 1:1 classid 1:12 htb rate 300mbit ceil 900mbit


U32="sudo tc filter add dev eth1 protocol ip parent 1:0 prio 1 u32"
$U32 match ip dport 5002 0xffff flowid 1:10
#$U32 match ip dport 5003 0xffff flowid 1:11
#$U32 match ip dport 5004 0xffff flowid 1:12

#or
#sudo tc filter add dev eth1 protocol ip parent 1:0 prio 1 u32 match ip dst 10.10.1.2/32 flowid 1:10~                                                                               

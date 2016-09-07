# This script is used to emulate different RTTs for each flow coming 
# from different hosts


IF=eth0
RTT1=50ms
RTT2=10ms

sudo tc qdisc del dev $IF root

sudo tc qdisc add dev $IF root handle 1: htb default 11
sudo tc class add dev $IF parent 1: classid 1:1 htb rate 1000mbit ceil 1000mbit

sudo tc class add dev $IF parent 1:1 classid 1:10 htb rate 500mbit ceil 1000mbit
sudo tc class add dev $IF parent 1:1 classid 1:11 htb rate 500mbit ceil 1000mbit

sudo tc qdisc add dev $IF parent 1:10 handle 10: netem delay $RTT1
sudo tc qdisc add dev $IF parent 1:11 handle 11: netem delay $RTT2

U32="sudo tc filter add dev $IF protocol ip parent 1:0 prio 1 u32"
$U32 match ip sport 5004 0xffff flowid 1:10
$U32 match ip sport 5005 0xffff flowid 1:11

# HTB at the sender
# First we have only one class
# after the second circuit/VC is added, the script calles "add-another-htb-class.sh" is used
# to add a new class to HTB to handle the new VC flow

sudo tc qdisc del dev vlan390 root

sudo tc qdisc add dev vlan390 root handle 1: htb 

sudo tc class add dev vlan390 parent 1: classid 1:1 htb rate $1 
sudo tc class add dev vlan390 parent 1:1 classid 1:10 htb rate $1
sudo tc qdisc add dev vlan390 parent 1:10 handle 10: bfifo limit $2

U32="sudo tc filter add dev vlan390 protocol ip parent 1:0 prio 1 u32"
$U32 match ip dport 5006 0xffff flowid 1:10


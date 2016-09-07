# This script was used in the cross layer desing paper
# it is used for one-to-many case
# where while a DTN is serving a receiver
# another receiver is added, therefore a new class should be created
# and added to HTB without interfering with the running flow

# This script does not allow borrowing
# hence, a new parent class is created and added to the root

# This script should be executed if you already have an HTB qdisc
# added to your interface.


IF=eth0

# add new parent
sudo tc class add dev $IF parent 1: classid 1:2 htb rate 500mbit
sudo tc class add dev $IF parent 1:2 classid 1:12 htb rate 200mbit

# uncomment if you want to add a delay to this new flow
#sudo tc qdisc add dev vlan390 parent 1:12 handle 12: netem delay 20ms


# filter: indicate which flow should be directed to the new class
U32="sudo tc filter add dev $IF protocol ip parent 1:0 prio 1 u32"
$U32 match ip dport 5005 0xffff flowid 1:12



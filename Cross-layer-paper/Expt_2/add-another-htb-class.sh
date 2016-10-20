tbf_rate=$1
tbf_limit=$2

sudo tc class add dev vlan390 parent 1: classid 1:2 htb rate $tbf_rate
sudo tc class add dev vlan390 parent 1:2 classid 1:11 htb rate $tbf_rate
sudo tc qdisc add dev vlan390 parent 1:11 handle 11: bfifo limit $tbf_limit

U32="sudo tc filter add dev vlan390 protocol ip parent 1:0 prio 1 u32"
$U32 match ip dport 5007 0xffff flowid 1:11



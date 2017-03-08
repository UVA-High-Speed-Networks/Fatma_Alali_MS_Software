IF=eth4
limit=25mb

sudo tc qdisc del dev $IF root
#by default prio qdisc create 3 classes, class 1 has the highest priority
sudo tc qdisc add dev $IF root handle 1: prio default 10

sudo tc qdisc add dev $IF parent 1:1 handle 10: bfifo limit $limit
sudo tc qdisc add dev $IF parent 1:2 handle 11: bfifo limit $limit

sudo tc filter add dev $IF protocol ip parent 1:0 prio 1 u32 match ip dport 5004 0xffff flowid 1:11
#sudo tc filter add dev $IF protocol ip parent 1:0 prio 1 u32 match ip src 10.10.2.1/32 flowid 1:1
#sudo tc filter add dev $IF protocol ip parent 1:0 prio 1 u32 match ip src 10.10.1.1/32 flowid 1:2

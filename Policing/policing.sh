ETH_IF=eth1 #the interface where policing should be applied
RATE=500mbit #the rate at which the interface will accept packets
IP=10.10.1.2/32 #the specific flow identified by its source IP address where policing should apply to

sudo tc qdisc del dev $ETH_IF ingress

sudo tc qdisc add dev $ETH_IF handle ffff: ingress
sudo tc filter add dev $ETH_IF parent ffff: protocol ip prio 1 \
   u32 match ip dst $IP \
   police rate $RATE burst 300mbit drop flowid :1


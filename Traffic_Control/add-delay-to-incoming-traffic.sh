# This script is used if you want to add delay (increase RTT)
# but you want to do it at the receiver instead of the sender for some reasons

# You need to use the Intermediate Functional Block pseudo-device IFB .
# This network device allows attaching queuing discplines to incoming packets.

# First you need to do the following:
# modprobe ifb
# ip link set dev ifb0 up

IF=eth0 #the interface name
delay=30ms

sudo tc qdisc del dev $IF ingress
sudo tc qdisc del dev ifb0 root

sudo tc qdisc add dev $IF ingress
sudo tc filter add dev $IF parent ffff: \ 
   protocol ip u32 match u32 0 0 flowid 1:1 action mirred egress redirect dev ifb0

sudo tc qdisc add dev ifb0 root netem delay $delay limit 10000



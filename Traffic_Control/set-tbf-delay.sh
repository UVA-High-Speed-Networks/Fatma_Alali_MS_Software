# This script ise used to shape the traffic and to increase the RTT of the path

IF=eth0
rate=1000mbit
limit=10mb #should equal to 2 BDP to ensure no packet is dropped by tc
RTT=30ms

sudo tc qdisc del dev $IF root
sudo tc qdisc add dev $IF root handle 1:0 tbf rate $rate burst 20kb limit $limit
sudo tc qdisc add dev $IF parent 1:1 handle 10: netem delay $RTT limit $limit


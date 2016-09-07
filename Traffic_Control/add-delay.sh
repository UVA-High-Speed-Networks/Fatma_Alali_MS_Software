
# Add delay at the sender
# netem (network emulater) which is part of tc can be used to delay the packet
# (hold the packets in a buffer at the sender) before sending them into the wire
# this script can be used to emulate high RTT paths

IF=eth0
RTT=50ms

sudo tc qdisc del dev $IF root
sudo tc qdisc add dev $IF root netem delay $RTT

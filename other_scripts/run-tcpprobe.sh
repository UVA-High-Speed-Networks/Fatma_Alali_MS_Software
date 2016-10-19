# tcp_probe is used to capture information regarding the current running TCP sockets
# we used it to capture the cwnd values
# use plot tcp_p

#! /bin/bash
sudo modprobe tcp_probe port=5201 full=1
sudo chmod 444 /proc/net/tcpprobe
cat /proc/net/tcpprobe > /tmp/tcpprobe.out &
pid=$!
iperf3 -c 10.10.1.3 -t 10
kill $pid

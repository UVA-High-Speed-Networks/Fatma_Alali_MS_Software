#First run the following command at the receiver to listen to the incoming connections:
#socat STDIO UDP-LISTEN:1234 > /dev/null &

# The following script do the following:
# (i) perform ping for 2 sec to update ARP table
# (ii) set TBF
# (iii) run socat to transfer a file using UDP immediatly after setting TBF

# socat was used instead of iperf3 to generate UDP packets is because
# iperf3 first use a TCP connection to exhcange port information before starting the UDP flow
# but we did not want to go through this because we wanted to study the status of TBF bucket
# at the begning, and if iperf3 was used, then because of the first TCP connection handshake, the 
# TBF would have a chance to bi filled with token

#ping
ping 10.10.1.2 -w 2

#set TBF
sh set-tbf.sh

#run socat
cat fileName | socat -b 57520 - UDP4-DATAGRAM:10.10.1.2:1234

#or iperf3 !
#iperf3 -c 10.10.1.2 -i 1 -t 15

# To capture the packets using the following tcpdump filter:
# sudo tcpdump -B 4096 -i vlan1836 dst port 1234 or src port 1234 -s 70 -w run-6-socat.pcap

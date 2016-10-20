#!/bin/bash

# This script create two flows with different rate and different RTT
# The first flow start first, then the second flow starts
# HTB is used to control the rate of each flow
# "sar", which is a linix utility used to monitor NICs, is used to get the aggregate rate

# the RTTs can be emulated at the receiver by using tc netem delay

log_dir=/users/fha6np/expt2-5-8-2016/results-2-recv
mkdir -p $log_dir

tc_rate1_unit=500mbit
tc_rate2_unit=100mbit
rtt=50 #unit: ms, longest RTT
rtt2=10
tc_rate=500 #worst path tc rate
tc_rate2=100

#---------flow1 setting--------
wmem1=$(bc <<< "scale=5;(($rtt/1000)*$tc_rate*1000000*2)/8") #unit: bytes
wmem=$(bc <<< "$wmem1/1") #to change it to int
echo wmem= $wmem
BDP=$(bc <<< "scale=8;((($rtt/1000)*$tc_rate*1000000)/8)/1500") #unit: packets
#set TCP sending buffer to 2BDP
sudo echo 4096  $wmem $wmem > /proc/sys/net/ipv4/tcp_wmem

fcwnd=$(bc <<< "($BDP*1.2)/1") #unit: pkts
#set ctcp fcwnd
sudo echo $fcwnd > /sys/module/tcp_ctcp/parameters/initial

limit_temp=$(bc <<< "($fcwnd*1500)/1") #unit: bytes
unit=b
limit=$limit_temp$unit
echo flow1 limit is $limit
#---------flow2 setting--------
BDP2=$(bc <<< "scale=8;((($rtt2/1000)*$tc_rate2*1000000)/8)") #unit: bytes
unit=b
limit2=$BDP2$unit
echo flow2 limit is $limit2

#-----------start the expt------------
#set HTB 
sh set-htb.sh $tc_rate1_unit $limit

#run sar to collect stat
sar -n DEV 1 30 | grep vlan390 | awk '{print $7}' >> $log_dir/sar-output.txt &

#start iperf3
#iperf3 -p5004 -c 10.10.1.3 -i 1 -t 30 > $log_dir/iperf3-flow1.txt &
./nuttcp-7.3.3 -p5006 -i1 -T30 10.10.1.3 > $log_dir/iperf3-flow1.txt &
sleep 10

#add another class for HTB
sh add-another-htb-class.sh $tc_rate2_unit $limit 

#start iperf3, flow2
#iperf3 -p5005 -c 10.10.1.2 -i 1 -t 10 > $log_dir/iperf3-flow2.txt &
./nuttcp-7.3.3 -p5007 -i1 -T10 10.10.1.2 > $log_dir/iperf3-flow2.txt &
sleep 20

#parse the results
#parse througput
cat $log_dir/iperf3-flow1.txt | grep 1.00 | awk '{print $7}' >> $log_dir/parsed-thru-flow1.txt
cat $log_dir/iperf3-flow2.txt | grep 1.00 | awk '{print $7}' >> $log_dir/parsed-thru-flow2.txt
                        

#parse retx_rate
retrans=`cat $log_dir/iperf3-flow1.txt | grep RX | awk '{print $13}'`
tot_data=`cat $log_dir/iperf3-flow1.txt | grep RX | awk '{print $1}'`
echo "scale=10;($retrans/(($tot_data*1000000)/1448))*100" | bc >> $log_dir/flow1-parsed-retx-rate.txt #we should add retrans to total data

retrans=`cat $log_dir/iperf3-flow2.txt | grep RX | awk '{print $13}'`
tot_data=`cat $log_dir/iperf3-flow2.txt | grep RX | awk '{print $1}'`
echo "scale=10;($retrans/(($tot_data*1000000)/1448))*100" | bc >> $log_dir/flow2-parsed-retx-rate.txt

#retrans=`cat $log_dir/iperf3-flow2.txt | grep sender | awk '{print $13}'`
#tot_data=`cat $log_dir/iperf3-flow2.txt | grep sender | awk '{print $5}'`
#echo "scale=10;($retrans/(($tot_data*1000000)/1448))*100" | bc >> $log_dir/flow2-parsed-retx-rate.txt
                        
#parse tc dropped packet (get the drop packet for TBF
sudo tc -s qdisc show dev vlan390 | grep -A1 10 | grep dropped | awk '{print $7}' | rev | cut -c 2- |rev >> $log_dir/tc-dropped-pkts-flow1.txt
sudo tc -s qdisc show dev vlan390 | grep -A1 11 | grep dropped | awk '{print $7}' | rev | cut -c 2- |rev >> $log_dir/tc-dropped-pkts-flow2.txt

#parse tc dropped packet rate %
#tc_dropped=`sudo tc -s qdisc show dev vlan390 | grep -A1 tbf | grep dropped | awk '{print $7}' | rev | cut -c 2- |rev`
#tc_tot_pkts=`sudo tc -s qdisc show dev vlan390 | grep -A1 tbf | grep dropped | awk '{print $4}' | rev | cut -c 2- |rev`
#echo "scale=8;(($tc_dropped/($tc_tot_pkts+$tc_dropped))*100)" | bc >> $log_dir/parsed-tc-dropped-rate.txt #its look like total packets doesn't include retrans, so we should do retrans/total+retrans

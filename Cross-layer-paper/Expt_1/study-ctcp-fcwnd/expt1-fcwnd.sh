#!/bin/bash

# This script study the impact of CTCP fcwnd on the throughput
# fcwnd is set to different percentage of the path BDP to find the 
# optimal fcwnd value 

# This script produces 3 files for each setting:
# average throuhgput
# average retx rate
# average dropped packets by tc
# It also keeps the raw data for all the runs in each setting

#Run this script with bash and sudo, i.e., sudo bash scriptName.sh
#The receiver TCP buffer is set to the worst case BDP. (You should do that at the receiving node)
#sudo echo 4096 25000000 25000000 > /proc/sys/net/ipv4/tcp_rmem

recv_ip=10.10.1.3
path_orginal_RTT=0.38 #unit: ms
IF=eth3 # the sending interface where you want to apply tc TBF

rtt=$1
tbf_rate_unit=$2
tbf_rate=$3

if [[ "$#" -ne 3 ]]; then
	echo "Usage:"
	echo "\$1 the RTT you want to emulate, e.g., 50ms. This is not the real path RTT, if you don't want to change the rtt, then use 0ms"
	echo "\$2 TBF rate and unit, e.g., 1000mbit (1 Gbps). mb:MByte, mbit:Mbit"
	echo "\$3 TBF rate without the unit, e.g, 1000" 
	exit -1
fi


main_log_dir=/users/fha6np/expt1-3-5-2016/vary-RTT-fcwnd/$tbf_rate_unit

sudo echo ctcp > /proc/sys/net/ipv4/tcp_congestion_control
sudo echo 100 > /sys/module/tcp_ctcp/parameters/scale

for RTT in rtt
do
        temp=`echo $RTT | rev | cut -c 3- |rev`
        rtt=$(bc <<< "scale=8;($temp+$path_orginal_RTT)/1000") #RTT in seconds
        wmem=$(bc <<< "($rtt*$tbf_rate*1000000*2)/8") #unit: bytes
        BDP=$(bc <<< "(($rtt*$tbf_rate*1000000)/8)/1500") #unit: packets

        #set TCP sending buffer to 2BDP
        sudo echo 4096  $wmem $wmem > /proc/sys/net/ipv4/tcp_wmem


        for percentage in 0.7 1 1.2 1.3 1.4 1.5 1.7 1.9 #2
        do
                fcwnd=$(bc <<< "($BDP*$percentage)/1") #unit: pkts
                #set ctcp fcwnd
                sudo echo $fcwnd > /sys/module/tcp_ctcp/parameters/initial

		limit_temp=$(bc <<< "$fcwnd*1500") #unit: bytes
        	unit=b
		limit=$limit_temp$unit
		echo limit is $limit

		if [[ "$limit_temp" -lt 20000 ]] #lt is for integer comarison, < is for string comparison
		then limit=20kb
		fi
		echo limit is $limit

                #set the log dir
                log_dir=$main_log_dir/RTT-$RTT/ratio-$percentage-fcwnd-$fcwnd
                mkdir -p $log_dir


                for i in `seq 1 50`
                do

                        echo $RTT $limit run $i

                        #configure TBF
                        sudo tc qdisc del dev $IF root
                        sudo tc qdisc add dev $IF root tbf rate $tbf_rate_unit burst 20kb limit $limit

                        #start iperf3
                        #iperf3 -c $recv_ip -i 1 -t 20 > $log_dir/run-$i.txt
                        ./nuttcp-7.3.3 -i1 -T20 $recv_ip > $log_dir/run-$i.txt

                        #parse the result
                        #parse througput
                        cat $log_dir/run-$i.txt | grep RX | awk '{print $7}' >> $log_dir/parsed-thru.txt

                        #parse retx_rate
                        retrans=`cat $log_dir/run-$i.txt | grep RX | awk '{print $13}'`
                        tot_data=`cat $log_dir/run-$i.txt | grep RX | awk '{print $1}'`
                        echo "scale=10;($retrans/(($tot_data*1000000)/1448))*100" | bc >> $log_dir/parsed-retx-rate.txt #we should add retrans to total data

                        #parse tc dropped packet (get the drop packet for TBF
                        sudo tc -s qdisc show dev vlan390 | grep -A1 tbf | grep dropped | awk '{print $7}' | rev | cut -c 2- |rev >> $log_dir/tc-dropped-pkts.txt

                        #parse tc dropped packet rate %
                        tc_dropped=`sudo tc -s qdisc show dev $IF | grep -A1 tbf | grep dropped | awk '{print $7}' | rev | cut -c 2- |rev`
                        tc_tot_pkts=`sudo tc -s qdisc show dev $IF | grep -A1 tbf | grep dropped | awk '{print $4}' | rev | cut -c 2- |rev`
                        echo "scale=8;(($tc_dropped/($tc_tot_pkts+$tc_dropped))*100)" | bc >> $log_dir/parsed-tc-dropped-rate.txt #its look like total packets doesn't include retrans, so we should do retrans/total+retrans

                done

                #find the avg retx rate and thrtc_tot_pktsoughput for the 50 runs for each setup
                cat $log_dir/parsed-thru.txt | awk '{ sum += $1 } END { if (NR > 0) print sum / NR }' >> $main_log_dir/RTT-$RTT/avg_thru_for_different_limit.txt
                cat $log_dir/parsed-retx-rate.txt  | awk '{ sum += $1 } END { if (NR > 0) print sum / NR }' >> $main_log_dir/RTT-$RTT/avg_retx_rate_for_different_limit.txt

        done
done


#tar -cvf vary-RTT-fcwnd.tar vary-RTT-fcwnd/

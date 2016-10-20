# This script is used to verify the number of reported retx packets of iperf3 and nuttcp
# by comparing the number with the number of retx reported by tcptrace

# Make sure to change the interface, IP address, TCP port, and the log directory

#Nuttcp test
LOG_DIR=/users/fha6np/check-nuttcp-retx

# create a log directory, ignore if the directory already exist
mkdir -p $LOG_DIR

for i in `seq 1 100`
do
	echo run $i
	#start tcpdump
	sudo tcpdump -B 4096 -i vlan1610  dst port 5001 or src port 5001 -w $LOG_DIR/run-$i.pcap &

	#start nuttcp
	nuttcp -i1 -T15 10.10.1.1 > $LOG_DIR/run-$i.txt

	#kill tcpdump
	sudo killall tcpdump

	#process the pcap file
	tcptrace -l $LOG_DIR/run-$i.pcap > $LOG_DIR/tcptrace-run-$i.txt

	#compare the log files
	cat $LOG_DIR/tcptrace-run-$i.txt | grep 'rexmt data pkts:' | awk '{sum+=$4+$8} END {print sum}' > file1.txt

	cat $LOG_DIR/run-$i.txt | grep RX | awk '{print $13}' > file2.txt

	if diff file1.txt file2.txt >/dev/null ; then
  		echo 0 >> $LOG_DIR/nuttcp-results.txt
		# rm -f $LOG_DIR/run-$i.pcap
	else
  		echo 1 >> $LOG_DIR/nuttcp-results.txt
	fi	

	#remove unded files
	rm -f file1.txt file2.txt

done 

echo finish nuttcp test


#Iperf3 test
LOG_DIR=/users/fha6np/check-iperf3-retx
mkdir -p $LOG_DIR

for i in `seq 1 100`
do
	echo iperf3 rin $i

        #start tcpdump
        sudo tcpdump -B 4096 -i vlan1610  dst port 5201 or src port 5201 -w $LOG_DIR/run-$i.pcap &

        #start iperf3
        iperf3 -c 10.10.1.1 -i 1 -t 15 > $LOG_DIR/run-$i.txt

        #kill tcpdump
        sudo killall tcpdump

        #process the pcap file
        tcptrace -l $LOG_DIR/run-$i.pcap > $LOG_DIR/tcptrace-run-$i.txt

        #compare the log files
        cat $LOG_DIR/tcptrace-run-$i.txt | grep 'rexmt data pkts:' | awk '{sum+=$4+$8} END {print sum}' > file1.txt

        cat $LOG_DIR/run-$i.txt | grep sender | awk '{print $9}' > file2.txt

        if diff file1.txt file2.txt >/dev/null ; then
                echo 0 >> $LOG_DIR/iperf3-results.txt
		# rm -f $LOG_DIR/run-$i.pcap
        else
                echo 1 >> $LOG_DIR/iperf3-results.txt
        fi

        #remove unded files
        rm -f file1.txt file2.txt 


done
echo finish iperf3 test

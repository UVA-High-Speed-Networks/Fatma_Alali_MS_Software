proto=$1
log_dir=$2



sudo iperf3  -c 10.10.1.3 -p5004 -t 40 > $log_dir/iperf3-run-$proto.txt

sudo cat $log_dir/iperf3-run-$proto.txt | grep MBytes | awk '{print $7}' >> $log_dir/parsed-thru-$proto.txt
sudo cat $log_dir/iperf3-run-$proto.txt | grep MBytes | awk '{print $9}' >> $log_dir/parsed-retrans-$proto.txt
sudo tc -s qdisc show dev eth1 | grep -A1 tbf | grep dropped | awk '{print $7}' | rev | cut -c 2- |rev >> $log_dir/tc-dropped-pkts-$proto.txt

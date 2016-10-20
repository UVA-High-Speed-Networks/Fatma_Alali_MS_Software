
sh /users/fha6np/expt3-3-9-2016/set-htb.sh

log_dir=/users/fha6np/expt3-3-9-2016/results-wmem-2-BDP-delay
mkdir -p $log_dir

#start udp flows

iperf3  -c 10.10.1.3 -p 5005 -u -b 50M -t 40 > $log_dir/flow1-$1.txt &
sleep 10
iperf3  -c 10.10.1.3 -p 5006 -u -b 60M -t 5 > $log_dir/flow2-$1.txt
sleep 20
iperf3  -c 10.10.1.3 -p 5006 -u -b 60M -t 7 >> $log_dir/flow2-$1.txt

sleep 5

#parse flow1 results
sudo cat $log_dir/flow1-$1.txt | grep MBytes | awk '{print $7}' >> $log_dir/parsed-flow1-thru-$1.txt
sudo cat $log_dir/flow1-$1.txt | grep MBytes | awk '{print $9}' >> $log_dir/parsed-flow1-retrans-$1.txt



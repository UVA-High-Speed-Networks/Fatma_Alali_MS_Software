sudo cat $log_dir/flow1-$1.txt | grep MBytes | awk '{print $7}' >> $log_dir/parsed-flow1-thru-$1.txt
sudo cat $log_dir/flow1-$1.txt | grep MBytes | awk '{print $9}' >> $log_dir/parsed-flow1-retrans-$1.txt

#run the script with sudo 
#sudo echo 4096 23750000 23750000 > /proc/sys/net/ipv4/tcp_rmem at the receiver

proto=$1
log_dir=$2
mkdir -p $log_dir

# calculate those values based on RTT and rate
fcwnd=4750
wmem=11875000
limit=7.125mb

#set TCP sending buffer to 2BDP
sudo echo 4096  $wmem $wmem > /proc/sys/net/ipv4/tcp_wmem #wmem=2BDP
#sudo echo 4096  $wmem 23750000 > /proc/sys/net/ipv4/tcp_wmem #wmem=4BDP

#set TCP ver
sudo echo $proto > /proc/sys/net/ipv4/tcp_congestion_control

#set fcwnd
sudo echo $fcwnd > /sys/module/tcp_ctcp/parameters/initial

#et TBF, imit is set to 2BDP to be fair for HTCP
sudo tc qdisc del dev eth1 root
#sudo tc qdisc add dev eth1 root tbf rate 950mbit burst 20kb limit 23.75mb #wmem=4BDP
sudo tc qdisc add dev eth1 root tbf rate 950mbit burst 20kb limit $limit #limit = BDP


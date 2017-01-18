sudo yum update

#install ctcp
wget http://www.ece.virginia.edu/cheetah/software/ctcp/CTCP.tar.gz
mv CTCP.tar.gz CTCP.tar
mkdir ctcp
cp CTCP.tar ctcp/
cd ctcp
tar -xvf CTCP.tar
make
sudo insmod ./tcp_ctcp.ko

#install iperf3
wget https://launchpad.net/ubuntu/+archive/primary/+files/iperf3_3.0.7.orig.tar.gz
tar -zxvf iperf3_3.0.7.orig.tar.gz
cd iperf-3.0.7/
./configure
make
sudo make install

#echo htcp > /proc/sys/net/ipv4/tcp_congestion_control 
#echo 4096 81500000 81500000 > /proc/sys/net/ipv4/tcp_rmem

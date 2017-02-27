sudo apt-get update

#install tshark
sudo apt-get -y install tshark

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
sudo apt-get -y install uuid-dev
wget https://launchpad.net/ubuntu/+archive/primary/+files/iperf3_3.0.7.orig.tar.gz
tar -zxvf iperf3_3.0.7.orig.tar.gz
cd iperf-3.0.7/
./configure
make
sudo make install
sudo apt-get -y install lib32z1

#install screen 
sudo apt-get -y install screen

sudo apt-get -y install vim

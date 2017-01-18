#get the latest tshark version  "Source Code" under "Stable Release" here:
#https://www.wireshark.org/download.html

# install needed packeges
yum install -y gcc-c++ bison flex gtk2 gtk2-devel libpcap-devel

# get the source code
tar -xvf wireshark-1.12.4.tar.bz2
cd wireshark-1.12.4

# make
./configure --with-gtk2
make
make install

# use the below command to check your tshark version
tshark -v


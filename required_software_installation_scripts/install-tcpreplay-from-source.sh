# release installation  4.1.2
# source: https://github.com/appneta/tcpreplay

wget https://github.com/appneta/tcpreplay/releases/download/v4.1.2/tcpreplay-4.1.2.tar.gz
tar zxvf tcpreplay-4.1.2.tar.gz
cd tcpreplay-4.1.2/
sudo apt-get install build-essential libpcap-dev
./configure --enable-quick-tx
#or
#./configure 
make
sudo make install

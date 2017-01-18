# if you used apt-get to get tshark, you will not get the latest release
# earlier tshark releases has some bugs or lack some features

# install needed packeges
sudo apt-get -y build-dep wireshark 
sudo apt-get -y install checkinstall
sudo apt-get -y install qt5-default
sudo apt-get -y install libssl-dev
sudo apt-get -y install libgtk-3-dev

# get the source code
# chopse the version you want https://www.wireshark.org/download.html
wget https://1.na.dl.wireshark.org/src/wireshark-1.12.10.tar.bz2
tar -xvf wireshark-1.12.10.tar.bz2
cd wireshark-1.12.10

# make
./configure
make
sudo checkinstall
sudo make install

sudo ldconfig

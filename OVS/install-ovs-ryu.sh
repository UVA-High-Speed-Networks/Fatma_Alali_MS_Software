#get and install ovs for ubuntu
sudo apt-get update
sudo apt-get install -y git automake autoconf gcc uml-utilities libtool build-essential git pkg-config linux-headers-`uname -r`
sudo apt-get install -y python-setuptools python-pip python-dev \
libxml2-dev libxslt-dev
wget http://openvswitch.org/releases/openvswitch-2.3.1.tar.gz
gunzip openvswitch-2.3.1.tar.gz
tar -xvf openvswitch-2.3.1.tar
cd openvswitch-2.3.1
./configure --with-linux=/lib/modules/`uname -r`/build
sudo make
sudo make install

sudo make modules_install
sudo /sbin/modprobe openvswitch

sudo mkdir -p /usr/local/etc/openvswitch
sudo ovsdb-tool create /usr/local/etc/openvswitch/conf.db vswitchd/vswitch.ovsschema

#Before starting ovs-vswitchd itself, you need to start its configuration database, ovsdb-server. Each machine on which Open vSwitch is installed should run its own copy of ovsdb-server
sudo ovsdb-server --remote=punix:/usr/local/var/run/openvswitch/db.sock \
                 --remote=db:Open_vSwitch,Open_vSwitch,manager_options \
                 --private-key=db:Open_vSwitch,SSL,private_key \
                 --certificate=db:Open_vSwitch,SSL,certificate \
                 --bootstrap-ca-cert=db:Open_vSwitch,SSL,ca_cert \
                 --pidfile --detach

#initialize the database
sudo ovs-vsctl --no-wait init

#start the main Open vSwitch daemon, telling it to connect to the same Unix domain socket
sudo ovs-vswitchd --pidfile --detach

#show
sudo ovs-vsctl show
sudo ovs-vsctl --version

#-----install ryu------------
cd
sudo apt-get install -y python-setuptools
sudo pip install -y greenlet
sudo apt-get install -y python-pip python-dev libxml2-dev libxslt-dev zlib1g-dev
sudo pip install -y oslo.config

sudo easy_install -y pip

git clone git://github.com/osrg/ryu.git
cd ryu
sudo python ./setup.py install

#if you get an error installing the following
#sudo apt-get install python-eventlet python-webob python-routes python-gevent
#do the follwing:
#sudo vi  /var/lib/dpkg/statoverride
#and remove the line that leads to the error

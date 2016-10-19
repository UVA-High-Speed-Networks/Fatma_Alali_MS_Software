# This script run OVS, and add interfaces to OVS.
# The added interfaces will be controlled by OVS

# The list of interfaces you want to add to the virtual switch
IF_1=eth1
IF_2=eth2
IF_3=eth3
IF_4=eth4

# first set the IP addresses of the interfaces you want to add to the virtual switch to 0
sudo ifconfig $IF_1 0
sudo ifconfig $IF_2 0
sudo ifconfig $IF_3 0
sudo ifconfig $IF_4 0


# delete current OVS bridge if any
sudo ovs-vsctl del-br br0
sudo  ovs-vsctl -- --all destroy QoS -- --all destroy Queue

# add OVS bridge (switch)
sudo ovs-vsctl add-br br0
#sudo ovs-vsctl set Bridge br0 protocols=OpenFlow13

# add the interfaces that you want to be part of your virtual switch
# the oreder at which you add the interfaces is important 
# because the first port of OVS will be the first interface you added to OVS
sudo ovs-vsctl add-port br0 $IF_1
sudo ovs-vsctl add-port br0 $IF_2
sudo ovs-vsctl add-port br0 $IF_3
sudo ovs-vsctl add-port br0 $IF_4

# OVS controller setting
# in this scripts the controller is running in the same node that run OVS
# if you want to run the controller in another node, change the IP address below
sudo ovs-vsctl set-controller br0 tcp:127.0.0.1:6633
sudo ovs-vsctl set-manager ptcp:6632
sudo ovs-vsctl set-fail-mode br0 secure



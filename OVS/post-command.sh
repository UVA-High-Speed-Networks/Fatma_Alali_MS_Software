# This script configure your virtual switch
# by adding IP addresses to the OVS ports

# This script should be executed after running ryu (run-ryu.sh)
# The variable called "sw_id" represent the switch id assigned for your OVS
# when running ryu you can find the switch id

sw_id=00000013468d3dbd


curl -X PUT -d '"tcp:127.0.0.1:6632"' http://localhost:8080/v1.0/conf/switches/$sw_id/ovsdb_addr

# The first IP address will be assigned to the first interface you added to OVS, e.g, if eth3 was the first you added to OVS
# then eth3 is considered port1 in OVS
curl -X POST -d '{"address":"10.10.1.2/24"}' http://127.0.0.1:8080/router/$sw_id
curl -X POST -d '{"address":"10.10.2.2/24"}' http://127.0.0.1:8080/router/$sw_id
curl -X POST -d '{"address":"10.10.3.2/24"}' http://127.0.0.1:8080/router/$sw_id
curl -X POST -d '{"address":"10.10.4.2/24"}' http://127.0.0.1:8080/router/$sw_id
				
# I've noticed that in the forwarding table there is always one missing entry for one of the ports
# so this command is used to add the entry for this port
# you need to change the MAC address and the IP based on the entry you are missing
sudo ovs-ofctl add-flow br0 idle_timeout=1800,idle_age=184,priority=35,ip,nw_dst=10.10.4.1,actions=dec_ttl,mod_dl_src:00:13:46:8d:3d:bd,mod_dl_dst:00:1b:21:2d:4d:23,output:4


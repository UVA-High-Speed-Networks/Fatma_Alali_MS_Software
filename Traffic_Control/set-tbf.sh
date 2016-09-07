# This script is used to shape traffic coming from a single interface
# the difference between TBF and HTB qudiscs ia that with HTB you
# can set different rate for each flow coming from a single interface

IF=eth0
rate=700mbit
limit=25mb # the buffer size, set it to 2BDP

sudo tc qdisc del dev $IF root
sudo tc qdisc add dev $IF root tbf rate $rate burst 20kb limit $limit

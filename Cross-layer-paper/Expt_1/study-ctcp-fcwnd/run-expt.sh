# you need to ssh to the receiver to add a delay (emulate different values of RTTs)
# you should have a script called add-delay-tbf.sh at the receiver

tbf_rate_unit=1000mbit
tbf_rate=1000

for tbf_rate in 50 300 800 #100 600 1000 50 #50 100 300 500 700 1000
do 
	unit=mbit
	tbf_rate_unit=$tbf_rate$unit
	echo $tbf_rate_unit
	
	for RTT in 0ms 0.2ms 0.7ms 5ms 10ms 20ms 50ms 100ms
	do
		ssh fha6np@pc26.utahddc.geniracks.net sh add-delay-tbf.sh $RTT  &
		sudo bash expt1-fcwnd.sh $RTT $tbf_rate_unit $tbf_rate

	done
done

tar -cvf vary-RTT-fcwnd.tar vary-RTT-fcwnd/

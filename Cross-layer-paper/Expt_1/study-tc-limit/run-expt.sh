
# you need to ssh to the receiver to add a delay (emulate different values of RTTs)
# you should have a script called add-delay-tbf.sh at the receiver

for tbf_rate in 100 200 250 500 700 1000
do 
	unit=mbit
	tbf_rate_unit=$tbf_rate$unit
	echo $tbf_rate_unit
	
	for RTT in 0.2ms 50ms 100ms
	do
		ssh fha6np@pc26.utahddc.geniracks.net sh add-delay-tbf.sh $RTT  &
		sudo bash expt1-limit-2.sh $RTT $tbf_rate_unit $tbf_rate

	done
done


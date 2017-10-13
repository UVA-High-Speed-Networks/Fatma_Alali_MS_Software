# change "ss -t -i" to what ever command or script you wanted to run xx times

for i in `seq 1 10`; do ss -t -i; sleep .5; done | grep -A1 172.17.12.13
#or with watch
watch -n 0.5 ss -t -i #-n for the interval, -d to print only if there is a difference in the output

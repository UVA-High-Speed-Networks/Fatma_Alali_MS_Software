# you should insert tcpprobe first and run it to capture cwnd values
# then you can use this script to plot cwnd values
# run run_tcpprobe.sh first

#! /bin/bash
gnuplot -persist <<EOF 
 set style data lines
 set title "cwnd"
 set xlabel "time (seconds)"
 set ylabel "Segments (cwnd, ssthresh)"
 set terminal pngcairo size 350,262 enhanced font 'Verdana,10'
 set output 'plotting_functions-4.png'
 plot "/tmp/tcpprobe.out" using 1:7 title "cwnd",\
 "/tmp/tcpprobe.out" using 1:(\$8>=2147483647 ? 0 : \$8) title "snd_ssthresh"
EOF

#plot "/tmp/tcpprobe.out" using 1:7 title "snd_cwnd", \
#      "/tmp/tcpprobe.out" using 1:(\$8>=2147483647 ? 0 : \$8) title "snd_ssthresh"

#set style data linespoints
# set xdata time
# set timefmt "%S"
# set format x "%S"


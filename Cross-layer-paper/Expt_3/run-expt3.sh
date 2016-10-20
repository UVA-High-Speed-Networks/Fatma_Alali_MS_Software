# run this script from your local machine to initiate flows from two different hosts
# make sure you are using public and private keys for authentication to make the expt
# automation easier

proto=$1 # CTCP or HTCP

log_dir=/users/fha6np/expt3-3-9-2016/results-RTT-50-fcwnd-1.2BDP

tcp_host=fha6np@pc12.utahddc.geniracks.net #-p 36154
udp_host=fha6np@pc33.utahddc.geniracks.net

#setup for TCP flow host
ssh $tcp_host -p 36154 sudo sh /users/fha6np/expt3-3-9-2016/expt3-setting.sh $proto $log_dir

#start beta flow
ssh $udp_host sh /users/fha6np/expt3-3-9-2016/start-beta-flow.sh $proto &

#alpha flow
ssh $tcp_host -p 36154 sudo sh /users/fha6np/expt3-3-9-2016/start-alpha-flow.sh $proto $log_dir

# $1 is the file name that have tshark output
cat $1 | grep Win |  awk '{print $12}' | cut -c 5- >  $1-parsed-win.txt


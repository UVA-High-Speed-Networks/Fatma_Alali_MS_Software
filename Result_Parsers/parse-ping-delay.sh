# $1 is the file name that store ping output
cat $1 | grep ttl | awk '{ print $8 }' | cut -c 6- >>$1-parsed.txt

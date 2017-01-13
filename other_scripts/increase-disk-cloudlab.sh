# You need to run the script with sudo

#First create new partition to mount your home directory:
#In GENI it is already created! sda4 is empty so use it
#Use "lsblk" command to check if you have the partition created or not
#Follow this link to create a new partition if needed: 
#http://ubuntuserverhelp.com/using-fdisk-to-create-a-partition/

#Note that for InstaGENI the home directory name is your UVA computing ID without the 0
your_dir_name=/users/fha6np0

#show disk info:
df -h
lsblk

#create a filesystem to the partition:
sudo mkfs.ext4 /dev/sda4
#Temporarily mount the new partition:
sudo mkdir /mnt/tmp
sudo mount /dev/sda4 /mnt/tmp

#copy you directory to the new location:
sudo rsync -avx $your_dir_name/ /mnt/tmp

#mount the new partition as HOME with
sudo mount /dev/sda4 $your_dir_name

sleep 5
#remove the old home directory
sudo umount $your_dir_name
#deletes the old home
rm -rf $your_dir_name/*

#Make your HOME directory  permanent
#grep the UUID of the sda4 partition
uuid=`sudo blkid | grep sda4 | awk '{print $2}' | cut -c 7- | rev | cut -c 2- | rev`
sudo echo UUID=$uuid  $your_dir_name    ext4    defaults   0  2 >> /etc/fstab


#remount
sudo mount -a

#to check where your directory is mounted now:
df -P $your_dir_name | tail -1 | cut -d' ' -f 1

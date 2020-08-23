#!/bin/bash

echo -n "Enter the sudo password : "
read -s password

cmd=$(echo $password | sudo -S lshw -C network -short 2>/dev/null | grep Wireless | awk '{print $2 " " $4}')
if sudo -n true ; then
        echo "I got the sudo password"
else
        echo "Wrong sudo password"
        echo "Either replace the password in this script or give password via command line arguments"
        echo "Exiting...."
        exit 0
fi

#the return value is a single string having a space
#splitting by space and storing in a array
cmd=($cmd)
echo "Wifi Interface: "${cmd[0]}
echo "Wifi Driver: "${cmd[1]}

exit 0
if [ -d "rtlwifi_new" ]
then
	rm -rf rtlwifi_new
fi

git clone https://github.com/kindlerprince/rtlwifi_new.git

if [[ $? -ne 0 ]]; then
	echo "Failed to cloned Repository"
	echo "Exiting..."
	exit 0
fi

cd rtlwifi_new
make
sudo make install
sudo modprobe -rv ${cmd[1]}
sudo modprobe -v ${cmd[1]} ant_sel=2
sudo ip link set ${cmd[0]} up
sudo iw dev ${cmd[0]} scan
make clean

echo "Wifi Driver Installed Successfully"

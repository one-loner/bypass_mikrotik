#!/bin/bash
if [ -z "$1" ]; then
    echo "Use $0 <tunnel ip address> <distance (optional, 1 by default)>"
    exit
fi

if [ -z "$2" ]; then
   d='1'
else
   echo 'Distance=1'
   d=$2
fi

wget https://antifilter.download/list/ip.lst -O iplist.txt
ip=$(cat iplist.txt)
if [ -z "$ip" ]; then
    echo "Download failed."
    ip=$(cat iplist-fix.txt)
fi
echo '/ip route' > Mikrotik-script.rsc
for line in $ip;
do
  echo 'add distance='$d' dst-address='$line' gateway='$1 >> Mikrotik-script.rsc
done

read -p "Add routes to DNS servers: 1.1.1.1, 8.8.8.8, 9.9.9.9 Y/N [N]" yn

case $yn in 
	Y* ) echo 'Yes'
             echo 'add distance='$d' dst-address=1.1.1.1 gateway='$1 >> Mikrotik-script.rsc
             echo 'add distance='$d' dst-address=8.8.8.8 gateway='$1 >> Mikrotik-script.rsc
             echo 'add distance='$d' dst-address=9.9.9.9 gateway='$1 >> Mikrotik-script.rsc
                ;;
	y* ) echo 'Yes'
             echo 'add distance='$d' dst-address=1.1.1.1 gateway='$1 >> Mikrotik-script.rsc
             echo 'add distance='$d' dst-address=8.8.8.8 gateway='$1 >> Mikrotik-script.rsc
             echo 'add distance='$d' dst-address=9.9.9.9 gateway='$1 >> Mikrotik-script.rsc

		;;
	* ) echo 'No'
		;;
esac

echo 'Done. Run script Mikrotik-script.rsc on your Mikrotik device to add routes.'

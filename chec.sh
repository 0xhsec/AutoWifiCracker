#! /usr/bin/bash


cr="\e[1;31m"
cg="\e[1;32m"
cb="\e[0m"
modeManaged(){
	sudo ifconfig $1 down
	sudo iwconfig $1 mode managed 
	sudo ifconfig $1 up
}
modeMonitor(){
	sudo ifconfig $1 down
	sudo iwconfig $1 mode monitor 
	sudo ifconfig $1 up
	cmode=$(iwconfig $wiface | grep monitor)
	if [ cmode ];then
		echo -e "$cg[+] $1 in managed mode.... $cb"
	else
		echo -e "$cr[+] $1 Failed to managed mode.... $cb"
	fi	

}

t1=$(which aircrack-ng)


if [ "$EUID" = 0  ]; then
    if [ $t1 ]; then
    	echo -e "$cg[+] Looking for wireless card....$cb"
    else
    	echo -e "$cr[!] Recommended app aircrack-ng was not found.. $cb"
    	exit
    fi
else
    echo -e "$cr[!] error: script must be run as root $cb"
	echo -e "$cr[!] Re-run script$cr sudo ./Autowific...  $cb"
	exit
fi

# wdevice= nmcli device status | grep wifi | awk '{print $1;}'
wiface=$(nmcli device status | grep wifi | cut -d " " -f1)

if [ $wiface ]; then
    echo -e "[+] Found $cg$wiface$cb interface $cb"
    mode=$(iwconfig $wiface | grep -i -c Monitor)
	if [ $mode = 1 ]; then
	    echo -e "$cg[+] $wiface in Monitor mode.... $cb"		
	else
	    echo -e "$cr[+] Changing $wiface into Managed mode.... $cb"
	    modeMonitor $wiface
	fi	
else
    echo -e "$cr[!] Sorry didn't found any wireless card $cb"
    exit 
fi

echo "[+] Changing $wiface into normal"
modeManaged $wiface


echo "===="
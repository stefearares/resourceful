#!bin/bash

command_exists() {
  command -v "$1" >/dev/null 2>&1
}

if ! command_exists mpstat; then
  echo "sysstat is not installed. Do you want to install it? (y/n)"
  read answer
  if [ "$answer" == "y" ]; then
     sudo apt-get install sysstat 
    
  else
    echo "sysstat is required for this script. Exiting."
    exit 1
  fi
fi

if ! command_exists speedtest-cli; then
  echo "speedtest-cli is not installed. Do you want to install it? (y/n)"
  read answer
  if [ "$answer" == "y" ]; then
     sudo apt-get install speedtest-cli
   
  else
    echo "speedtest-cli is required for this script. Exiting."
    exit 1
  fi
fi

tester=$(pwd | rev | cut -d'/' -f1 | rev)

if [ "$tester" == "resourceful" ]; then

        moment=$(date +"Date: %D Time: %T%n");
        echo "$moment" >> history;
	who=$(whoami)
	printf "User: %s\n" "$who" >> history;
	up=$(uptime -p)
	printf "Current Uptime: %s\n" "$up"  >> history;
        cpu=$(echo "100 - $(mpstat 1 1 | tail -n 1 | rev | cut -d' ' -f1 | rev | tr ',' '.')" | bc)
        printf "CPU usage: %s%%\n" "$cpu" >> history;
	totalmem=$(free | awk '/^Mem/ {printf $2}')
	usedmem=$(free | awk '/^Mem/ {printf $3}')
	printf "Used memory: %s KBs / Total: %s KBs\n" "$usedmem" "$totalmem" >> history;
	pack=$(apt-mark showmanual | wc -l)
	printf "Manually installed packages: %s\n" "$pack" >> history;
	network=$(speedtest-cli --simple)
	printf "%s\n" "$network" >> history; 
 	echo -n "I/O: " >> history;
        ios=$(iostat -d | awk '$1 ~ /^(nvme|sda)/ {print $1}')
        if [ -n "$ios" ]; then
        formatted_line=$(echo "$ios" | tr '\n' ', ' | sed 's/,$/./')
        echo -n "$formatted_line" >> history;
        fi

else
        mkdir resourceful;
        mv proiect.sh resourceful;
        cd resourceful;
        moment=$(date +"Date: %D Time: %T%n");
        echo "$moment" > history;
	who=$(whoami)
        printf "User: %s\n" "$who" >> history;
	up=$(uptime -p)
        printf "Current Uptime: %s\n" >> history;
        cpu=$(echo "100 - $(mpstat 1 1 | tail -n 1 | rev | cut -d' ' -f1 | rev | tr ',' '.')" | bc)
        printf "CPU usage: %s%%\n" "$cpu" >> history;
	totalmem=$(free | awk '/^Mem/ {printf $2}')
        usedmem=$(free | awk '/^Mem/ {printf $3}')
	printf "Used memory: %s KBs / Total: %s KBs\n" "$usedmem" "$totalmem" >> history;
	pack=$(apt-mark showmanual | wc -l)
        printf "Manually installed packages: %s\n" "$pack" >> history;
	network=$(speedtest-cli --simple)
	printf "%s\n" "$network" >> history; 
 	echo -n "I/O: " >> history;
        ios=$(iostat -d | awk '$1 ~ /^(nvme|sda)/ {print $1}')
        if [ -n "$ios" ]; then
        formatted_line=$(echo "$ios" | tr '\n' ', ' | sed 's/,$/./')
        echo -n "$formatted_line" >> history;
        fi


fi

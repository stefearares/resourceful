#!/bin/bash

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

	moment=$(date +"Date: %D Time: %T%n");

        who=$(whoami)

        up=$(uptime -p)

        cpu=$(echo "100 - $(mpstat 1 1 | tail -n 1 | rev | cut -d' ' -f1 | rev | tr ',' '.')" | bc)

        totalmem=$(free | awk '/^Mem/ {printf $2}')

        usedmem=$(free | awk '/^Mem/ {printf $3}')                              

	pack=$(apt-mark showmanual | wc -l)

        network=$(speedtest-cli --simple)

        ios=$(iostat -d | awk '$1 ~ /^(nvme|sda)/ {print $1}')



if [ "$tester" == "resourceful" ]; then

        

        echo "$moment" >> history;

	printf "User: %s\n" "$who" >> history;

	printf "Current Uptime: %s\n" "$up"  >> history;

        printf "CPU usage: %s%%\n" "$cpu" >> history;

	printf "Used memory: %s KBs / Total: %s KBs\n" "$usedmem" "$totalmem" >> history;

	printf "Manually installed packages: %s\n" "$pack" >> history;

	printf "%s\n" "$network" >> history; 

 	echo -n "I/O: " >> history;

        if [ -n "$ios" ]; then

        formatted_line=$(echo "$ios" | tr '\n' ' ' | sed 's/,$/./')

        echo -n "$formatted_line" >> history;

       	echo -e "\n">> history

        fi



else

        mkdir resourceful;

        mv proiect.sh resourceful;

        cd resourceful;

        echo "$moment" > history;

        printf "User: %s\n" "$who" >> history;

        printf "Current Uptime: %s\n" >> history;

        printf "CPU usage: %s%%\n" "$cpu" >> history;

	printf "Used memory: %s KBs / Total: %s KBs\n" "$usedmem" "$totalmem" >> history;

        printf "Manually installed packages: %s\n" "$pack" >> history;

	printf "%s\n" "$network" >> history; 

 	echo -n "I/O: " >> history;

        if [ -n "$ios" ]; then

        formatted_line=$(echo "$ios" | tr '\n' ' ' | sed 's/,$/./')

        echo -n "$formatted_line" >> history;

        echo -e "\n"  >> history;

	fi





fi

	green='\033[0;32m'

	red='\033[0;31m'

	yellow='\033[0;33m'

	nocolor='\033[0m'



        echo "$moment";

        printf "User: %s\n" "$who";

        printf "Current Uptime: %s\n" "$up";

       	printf "CPU usage: %s%%\n" "$cpu";

        printf "Used memory: %s KBs / Total: %s KBs\n" "$usedmem" "$totalmem";

        printf "Manually installed packages: %s\n" "$pack";

        printf "%s\n" "$network";

        echo -n "I/O: ";

        if [ -n "$ios" ]; then

        formatted_line=$(echo "$ios" | tr '\n' ' ' | sed 's/,$/./')

        echo -n "$formatted_line";

        fi

	echo;

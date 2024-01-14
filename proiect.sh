#!/bin/bash

command_exists() {
  command -v "$1" >/dev/null 2>&1
}

if ! command_exists mpstat; then
  echo "sysstat is not installed. Do you want to install it? (Y/n)"
  read answer
  if [ "$answer" == "Y" ]; then
    sudo apt-get install sysstat
  else
    echo "sysstat is needed for this script."
    exit 1
  fi
fi

if ! command_exists speedtest-cli; then
  echo "speedtest-cli is not installed. Do you want to install it? (Y/n)"
  read answer
  if [ "$answer" == "Y" ]; then
    sudo apt-get install speedtest-cli
  else
    echo "speedtest-cli is needed for this script."
    exit 1
  fi
fi

script_name=$(basename "$0")
tester=$(pwd | rev | cut -d'/' -f1 | rev)
moment=$(date +"Date: %D Time: %T%n")
who=$(whoami)
up=$(uptime -p)
cpua=$(echo "100 - $(mpstat 1 1 | tail -n 1 | rev | cut -d' ' -f1 | rev | tr ',' '.')" | bc)
cpub=$(echo $cpua | cut -d'.' -f1)
if [ ${#cpub} -lt 1 ]
then
	cpu=0
	cpu+="."
	cpu+=$(echo $cpua | cut -d'.' -f2)
else
	cpu=$(echo $cpua)
fi
totalmem=$(free | awk '/^Mem/ {printf $2}')
usedmem=$(free | awk '/^Mem/ {printf $3}')
totalmem1=$((totalmem))
usedmem1=$((usedmem))
mem_perc1=$((usedmem * 100 / totalmem))
pack=$(apt-mark showmanual | wc -l)
network=$(speedtest-cli --simple 2>/dev/null)

if [ $? -ne 0 ]; then
  network="Network: Not available"
fi

ios=$(iostat -d | awk '$1 ~ /^(nvme|sda)/ {print $1}')

if [ "$tester" == "resourceful" ]; then
  if [ ! -f "history" ]; then
    >history
  fi

  echo "$moment" >>history
  printf "User: %s\n" "$who" >>history
  printf "Current Uptime: %s\n" "$up" >>history
  printf "CPU usage: %s%%\n" "$cpu" >>history
  printf "Used memory: %s KBs / Total: %s KBs - %s\n" "$usedmem" "$totalmem" "$mem_perc1" >>history
  printf "Manually installed packages: %s\n" "$pack" >>history
  printf "%s\n" "$network" >>history
  echo -n "I/O: " >>history

  if [ -n "$ios" ]; then
    formatted_line=$(echo "$ios" | tr '\n' ', ' | sed 's/,$/ /')
    echo -n "$formatted_line" >>history
    echo -e "\n" >>history
  fi
else
  mkdir resourceful
  mv "$script_name" resourceful
  cd resourceful
  echo "$moment" >history
  printf "User: %s\n" "$who" >>history
  printf "Current Uptime: %s\n" "$up" >>history
  printf "CPU usage: %s%%\n" "$cpu" >>history
  printf "Used memory: %s KBs / Total: %s KBs - %s\n" "$usedmem" "$totalmem" "$mem_perc1" >>history
  printf "Manually installed packages: %s\n" "$pack" >>history
  printf "%s\n" "$network" >>history
  echo -n "I/O: " >>history

  if [ -n "$ios" ]; then
        formatted_line=$(echo "$ios" | tr '\n' ', ' | sed 's/,$/ /')
        echo -n "$formatted_line" >> history;
        fi
  echo -e "\n" >> history;
fi

purple='\033[0;35m'
green='\033[0;32m'
red='\033[0;31m'
yellow='\033[0;33m'
nocolor='\033[0m'

cpu_round=$(echo "$cpu" | awk '{print int($1)}')
totalmem=$((totalmem))
usedmem=$((usedmem))
mem_perc=$((usedmem * 100 / totalmem))
COLUMNS=$(tput cols)
title="resourceful"
subtitle="-----------"

printf "${purple}%*s${nocolor}\n" $(((${#title} + $COLUMNS) / 2)) "$title"
printf "${purple}%*s${nocolor}\n\n" $(((${#title} + $COLUMNS) / 2)) "$subtitle"
echo   "									$moment"
printf "									User: ${purple}%s${nocolor}\n" "$who"
printf "									Current Uptime: %s\n" "$up"

if [ "$cpu_round" -le 33 ]; then
  printf "									CPU usage: ${green}%d%%${nocolor}\n" "$cpu_round"
elif [ "$cpu_round" -le 66 ]; then
  printf "									CPU usage: ${yellow}%d%%${nocolor}\n"  "$cpu_round"
else
  printf "									CPU usage: ${red}%d%%${nocolor}\n" "$cpu_round"
fi

if [ "$mem_perc" -le 33 ]; then
  printf "									Used memory: ${green}%s${nocolor} ${green}KBs${nocolor}(${green}%d%%${nocolor}) / Total: %s KBs\n" "$usedmem" "$mem_perc" "$totalmem"
elif [ "$mem_perc" -le 66 ]; then
  printf "									Used memory: ${yellow}%s${nocolor} ${yellow}KBs${nocolor}(${yellow}%d%%${nocolor}) / Total: %s KBs\n" "$usedmem" "$mem_perc" "$totalmem"
else
  printf "									Used memory: ${red}%s${nocolor} ${red}KBs${nocolor}(${red}%s${nocolor}) / Total: %s KBs\n" "$usedmem" "$mem_perc" "$totalmem"
fi
printf "									Manually installed packages: %s\n" "$pack"

while IFS= read -r line; do
  printf "									%s\n" "$line"
done <<< "$network"
#printf "									%s\n" "$network"
echo -n "									I/O: "

if [ -n "$ios" ]; then
  formatted_line=$(echo "$ios" | tr '\n' ', ' | sed 's/,$/ /')
  echo -n "$formatted_line"
fi


echo -e "\n"

paste <(
echo -e "  ${purple} CPU usage graph:${nocolor}"

echo -e " ____________________"

no=$(cat history | grep CPU | wc -l)

if (($no > 2)); then
  cpus=$(cat history | grep CPU | tail -3 | cut -d' ' -f 3 | cut -d'.' -f1)

  cpu1=$(echo $cpus | cut -d' ' -f1)
  [ ${#cpu1} -lt 1 ] && cpu1=0

  cpu2=$(echo $cpus | cut -d' ' -f2)
  [ ${#cpu2} -lt 1 ] && cpu2=0

  cpu3=$(echo $cpus | cut -d' ' -f3)
  [ ${#cpu3} -lt 1 ] && cpu3=0

  if (($cpu1 < 33)); then
    forma1="$(echo -e "|      \n|      \n|      \n|      \n|   __ \n|  |  |\n|__|  |")"
  elif (($cpu1 < 66)); then
    forma1="$(echo -e "|      \n|      \n|   __ \n|  |  |\n|  |  |\n|  |  |\n|__|  |")"
  else
    forma1="$(echo -e "|   __ \n|  |  |\n|  |  |\n|  |  |\n|  |  |\n|  |  |\n|__|  |")"
  fi

  if (($cpu2 < 33)); then
    forma2="$(echo -e "      \n      \n      \n      \n   __ \n  |  |\n__|  |")"
  elif (($cpu2 < 66)); then
    forma2="$(echo -e "      \n      \n   __ \n  |  |\n  |  |\n  |  |\n__|  |")"
  else
    forma2="$(echo -e "   __ \n  |  |\n  |  |\n  |  |\n  |  |\n  |  |\n__|  |")"
  fi

  if (($cpu3 < 33)); then
    forma3="$(echo -e "      \n      \n      \n      \n   __ \n  |  |\n__|  |__")"
  elif (($cpu3 < 66)); then
    forma3="$(echo -e "      \n      \n   __ \n  |  |\n  |  |\n  |  |\n__|  |__")"
  else
    forma3="$(echo -e "   __ \n  |  |\n  |  |\n  |  |\n  |  |\n  |  |\n__|  |__")"
  fi

  paste -d '' <(echo "$forma1") <(echo "$forma2") <(echo "$forma3")
elif (($no == 2)); then
  cpus=$(cat history | grep CPU | tail -2 | cut -d' ' -f 3 | cut -d'.' -f1)

  cpu1=$(echo $cpus | cut -d' ' -f1)
  [ ${#cpu1} -lt 1 ] && cpu1=0

  cpu2=$(echo $cpus | cut -d' ' -f2)
  [ ${#cpu2} -lt 1 ] && cpu2=0

  if (($cpu1 < 33)); then
    forma1="$(echo -e "|      \n|      \n|      \n|      \n|   __ \n|  |  |\n|__|  |")"
  elif (($cpu1 < 66)); then
    forma1="$(echo -e "|      \n|      \n|   __ \n|  |  |\n|  |  |\n|  |  |\n|__|  |")"
  else
    forma1="$(echo -e "|   __ \n|  |  |\n|  |  |\n|  |  |\n|  |  |\n|  |  |\n|__|  |")"
  fi

  if (($cpu2 < 33)); then
    forma2="$(echo -e "      \n      \n      \n      \n   __ \n  |  |\n__|  |________")"
  elif (($cpu2 < 66)); then
    forma2="$(echo -e "      \n      \n   __ \n  |  |\n  |  |\n  |  |\n__|  |________")"
  else
    forma2="$(echo -e "   __ \n  |  |\n  |  |\n  |  |\n  |  |\n  |  |\n__|  |________")"
  fi

  paste -d '' <(echo "$forma1") <(echo "$forma2")
else
  cpu1=$(cat history | grep CPU | tail -1 | cut -d' ' -f 3 | cut -d'.' -f1)
  [ ${#cpu1} -lt 1 ] && cpu1=0

  if (($cpu1 < 33)); then
    forma1="$(echo -e "|      \n|      \n|      \n|      \n|   __ \n|  |  |\n|__|  |______________")"
  elif (($cpu1 < 66)); then
    forma1="$(echo -e "|      \n|      \n|   __ \n|  |  |\n|  |  |\n|  |  |\n|__|  |______________")"
  else
    forma1="$(echo -e "|   __ \n|  |  |\n|  |  |\n|  |  |\n|  |  |\n|  |  |\n|__|  |______________")"
  fi

  echo "$forma1"
fi
) <(

echo -e "  ${purple} Memory usage graph:${nocolor}"

echo -e " ____________________"

no2=$(cat history | grep memory | wc -l)

if (($no2 > 2)); then
  cpus=$(cat history | grep memory: | rev | cut -d' ' -f1 | rev| tail -3)

  cpu1=$(echo $cpus | cut -d' ' -f1)
  [ ${#cpu1} -lt 1 ] && cpu1=0

  cpu2=$(echo $cpus | cut -d' ' -f2)
  [ ${#cpu2} -lt 1 ] && cpu2=0

  cpu3=$(echo $cpus | cut -d' ' -f3)
  [ ${#cpu3} -lt 1 ] && cpu3=0

  if (($cpu1 < 33)); then
    forma1="$(echo -e "|      \n|      \n|      \n|      \n|   __ \n|  |  |\n|__|  |")"
  elif (($cpu1 < 66)); then
    forma1="$(echo -e "|      \n|      \n|   __ \n|  |  |\n|  |  |\n|  |  |\n|__|  |")"
  else
    forma1="$(echo -e "|   __ \n|  |  |\n|  |  |\n|  |  |\n|  |  |\n|  |  |\n|__|  |")"
  fi

  if (($cpu2 < 33)); then
    forma2="$(echo -e "      \n      \n      \n      \n   __ \n  |  |\n__|  |")"
  elif (($cpu2 < 66)); then
    forma2="$(echo -e "      \n      \n   __ \n  |  |\n  |  |\n  |  |\n__|  |")"
  else
    forma2="$(echo -e "   __ \n  |  |\n  |  |\n  |  |\n  |  |\n  |  |\n__|  |")"
  fi

  if (($cpu3 < 33)); then
    forma3="$(echo -e "      \n      \n      \n      \n   __ \n  |  |\n__|  |__")"
  elif (($cpu3 < 66)); then
    forma3="$(echo -e "      \n      \n   __ \n  |  |\n  |  |\n  |  |\n__|  |__")"
  else
    forma3="$(echo -e "   __ \n  |  |\n  |  |\n  |  |\n  |  |\n  |  |\n__|  |__")"
  fi

  paste -d '' <(echo "$forma1") <(echo "$forma2") <(echo "$forma3")
elif (($no2 == 2)); then
  cpus=$(cat history | grep memory: | rev | cut -d' ' -f1 | rev| tail -2)

  cpu1=$(echo $cpus | cut -d' ' -f1)
  [ ${#cpu1} -lt 1 ] && cpu1=0

  cpu2=$(echo $cpus | cut -d' ' -f2)
  [ ${#cpu2} -lt 1 ] && cpu2=0

  if (($cpu1 < 33)); then
    forma1="$(echo -e "|      \n|      \n|      \n|      \n|   __ \n|  |  |\n|__|  |")"
  elif (($cpu1 < 66)); then
    forma1="$(echo -e "|      \n|      \n|   __ \n|  |  |\n|  |  |\n|  |  |\n|__|  |")"
  else
    forma1="$(echo -e "|   __ \n|  |  |\n|  |  |\n|  |  |\n|  |  |\n|  |  |\n|__|  |")"
  fi

  if (($cpu2 < 33)); then
    forma2="$(echo -e "      \n      \n      \n      \n   __ \n  |  |\n__|  |________")"
  elif (($cpu2 < 66)); then
    forma2="$(echo -e "      \n      \n   __ \n  |  |\n  |  |\n  |  |\n__|  |________")"
  else
    forma2="$(echo -e "   __ \n  |  |\n  |  |\n  |  |\n  |  |\n  |  |\n__|  |________")"
  fi

  paste -d '' <(echo "$forma1") <(echo "$forma2")
else
  cpu1=$(cat history | grep memory: | rev | cut -d' ' -f1 | rev| tail -1)

  [ ${#cpu1} -lt 1 ] && cpu1=0

  if (($cpu1 < 33)); then
    forma1="$(echo -e "|      \n|      \n|      \n|      \n|   __ \n|  |  |\n|__|  |______________")"
  elif (($cpu1 < 66)); then
    forma1="$(echo -e "|      \n|      \n|   __ \n|  |  |\n|  |  |\n|  |  |\n|__|  |______________")"
  else
    forma1="$(echo -e "|   __ \n|  |  |\n|  |  |\n|  |  |\n|  |  |\n|  |  |\n|__|  |______________")"
  fi

  echo "$forma1"
fi
)

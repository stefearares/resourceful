#!/bin/bash

no=$(cat history | grep CPU | wc -l)

if [[ $no > 2 ]]
then

	cpus=$(cat history | grep CPU | tail -3 | cut -d' ' -f 3 | cut -d'.' -f1)

	cpu1=$(echo $cpus | cut -d' ' -f1)
	cpu2=$(echo $cpus | cut -d' ' -f2)
	cpu3=$(echo $cpus | cut -d' ' -f3)

	if [[ $cpu1 < 33 ]]
	then
		forma1="$(echo -e "      \n      \n      \n      \n   __ \n  |  |\n__|  |")"
	else
		if [[ $cpu1 < 66 ]]
		then
			forma1="$(echo -e "      \n      \n   __ \n  |  |\n  |  |\n  |  |\n__|  |")"
		else
			forma1="$(echo -e "   __ \n  |  |\n  |  |\n  |  |\n  |  |\n  |  |\n__|  |")"
		fi
	fi
	if [[ $cpu2 < 33 ]]
	then
		forma2="$(echo -e "      \n      \n      \n      \n   __ \n  |  |\n__|  |")"
	else
		if [[ $cpu2 < 66 ]]
	        then
        	        forma2="$(echo -e "      \n      \n   __ \n  |  |\n  |  |\n  |  |\n__|  |")"
	        else
                	forma2="$(echo -e "   __ \n  |  |\n  |  |\n  |  |\n  |  |\n  |  |\n__|  |")"
        	fi
	fi
	if [[ $cpu3 < 33 ]]
	then
        	forma3="$(echo -e "      \n      \n      \n      \n   __ \n  |  |\n__|  |__")"
	else
        	if [[ $cpu3 < 66 ]]
        	then
        	        forma3="$(echo -e "      \n      \n   __ \n  |  |\n  |  |\n  |  |\n__|  |__")"
	        else
                	forma3="$(echo -e "   __ \n  |  |\n  |  |\n  |  |\n  |  |\n  |  |\n__|  |__")"
        	fi
	fi

	paste -d '' <(echo "$forma1") <(echo "$forma2") <(echo "$forma3")
else 
	cpus=$(cat history | grep CPU | tail -2 | cut -d' ' -f 3 | cut -d'.' -f1)

	cpu1=$(echo $cpus | cut -d' ' -f1)
	cpu2=$(echo $cpus | cut -d' ' -f2)

	if [[ $cpu1 < 33 ]]
        then
                forma1="$(echo -e "      \n      \n      \n      \n   __ \n  |  |\n__|  |")"
        else
                if [[ $cpu1 < 66 ]]
                then
                        forma1="$(echo -e "      \n      \n   __ \n  |  |\n  |  |\n  |  |\n__|  |")"
                else
                        forma1="$(echo -e "   __ \n  |  |\n  |  |\n  |  |\n  |  |\n  |  |\n__|  |")"
                fi
        fi
        if [[ $cpu2 < 33 ]]
        then
                forma2="$(echo -e "      \n      \n      \n      \n   __ \n  |  |\n__|  |__")"
        else
                if [[ $cpu2 < 66 ]]
                then
                        forma2="$(echo -e "      \n      \n   __ \n  |  |\n  |  |\n  |  |\n__|  |__")"
                else
                        forma2="$(echo -e "   __ \n  |  |\n  |  |\n  |  |\n  |  |\n  |  |\n__|  |__")"
                fi
        fi

	paste -d '' <(echo "$forma1") <(echo "$forma2")
fi

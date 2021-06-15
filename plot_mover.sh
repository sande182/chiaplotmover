#!/bin/bash

timestamp() {
	date +"%Y-%m-%d_%H-%M-%S" # current time
}

echo "Starting plot mover script at: " 
timestamp

declare -a AVAIL_SPACE
FILE="/media/christian/Plotter/madmax/"
DISK[0]="/media/christian/Plotter"
DISK[1]="/media/christian/DISK_0"
DISK[2]="/media/christian/DISK_1"
DISK[3]="/media/christian/DISK_2"
DISK[4]="/media/christian/DISK_3"
DISK[5]="/media/christian/DISK_4"
DISK[6]="/media/christian/DISK_5"
DISK[7]="/media/christian/DISK_6"
DISK[8]="/media/christian/DISK_7"
DISK[9]="/media/christian/DISK_8"
DISK[10]="/media/christian/DISK_9"
DISK[11]="/media/christian/DISK_10"
DISK[12]="/media/christian/DISK_11"
DISK[13]="/media/christian/Ext_HDD_0"
DISK[14]="/media/christian/Ext_HDD_1"
DISK[15]="/media/christian/Ext_HDD_2"
move_file="false"


for file in /media/christian/Plotter/madmax/*.plot
do
	if [ -f "${file}" ]
	then
		move_file="true"
	fi

	if [ ${move_file} == 'false' ]
	then
		echo "No plot to transfer."
		timestamp
		echo ""
		exit 0
	fi

		
	#df -h --output=avail /media/christian/DISK_0|grep -v Avail
	
	for i in {1..15}
	do
		AVAIL_SPACE[i]="$(df -h --output=avail ${DISK[i]}|grep -v Avail)"
		if [[ "${AVAIL_SPACE[i]}" == *'T'* ]];
		then
			AVAIL_SPACE[i]="true"
		fi
	
		if [[ "${AVAIL_SPACE[i]}" == *'G'* ]];
		then
			AVAIL_SPACE[i]=${AVAIL_SPACE[i]:: -1}
			
			if [ ${AVAIL_SPACE[i]} -lt 102 ]
			then
				AVAIL_SPACE[i]="false"
				echo "Not enough space in ${DISK[i]}."
			fi
	
			if [ ${AVAIL_SPACE[i]} -gt 102 ]
			then
				AVAIL_SPACE[i]="true"
			fi
		fi
		if [[ "${AVAIL_SPACE[i]}" == "true" ]]
		then
			file=$(ls ${FILE} )
			echo "Transferring ${file} to ${DISK[i]}."
			$(mv ${DISK[0]}/madmax/${file} ${DISK[i]})
			echo "Transfer completed."
			timestamp
			echo ""
			exit 1
		fi
		
	done

	echo "No available HDD space to transfer plots."
	timestamp
	echo ""

done


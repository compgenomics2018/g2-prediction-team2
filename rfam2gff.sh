#!/bin/sh

for file in *.fasta.deoverlapped.tblout
do
	echo "##gff-version 3" > $file.gff
	while read -r line
	do
		readline=$line
		if [[ $readline =~ ^[0-9]+ ]]
		then
			echo $readline | awk '$12 == "+" {printf "%s\tInfernal-1.1.2/Rfam\t%s\t%d\t%d\t%s\t%s\t.\tTarget_Name:%s;Model:%s;Target/RF_ACC:%s;Clan_Name:%s;GC:%s\n" ,$4,$2,$3,$10,$11,$18,$12,$2,$7,$3,$6,$15}' >> $file.gff
			echo $readline | awk '$12 == "-" {printf "%s\tInfernal-1.1.2/Rfam\t%s\t%d\t%d\t%s\t%s\t.\tTarget_Name:%s;Model:%s;Target/RF_ACC:%s;Clan_Name:%s;GC:%s\n" ,$4,$2,$3,$11,$10,$18,$12,$2,$7,$3,$6,$15}' >> $file.gff
		fi
	done < $file
done

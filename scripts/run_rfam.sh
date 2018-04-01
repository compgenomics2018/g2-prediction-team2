#!/bin/sh                                                                                                                                                                                

while getopts "g:c:m:t:o:p:" agrs
do
    case $agrs in
	g)    	      	      	      	      	      	      	      	# Path to list of genomes                                                                                        
        if [ -f $OPTARG ]
		then
            genomepath=$OPTARG;
        else
            echo "[-g] $OPTARG cannot be found in the directory";   # Check for existence of files                                                                                   
		fi;;
    c)																# Path to Rfam.clanin
        if [ -f $OPTARG ]
        then
	        claninpath=$OPTARG;
	    else
	    	echo "[-c] $OPTARG cannot be found in the directory";	# Check for existence of files
		fi;;
	m)																# Path to Rfam.cm
		if [ -f $OPTARG ]
		then
			cmpath=$OPTARG;
		else
			echo "[-m] $OPTARG cannot be found in the directory";   # Check for existence of files
		fi;;
	o)																# Path for tblout output
		gffout=$OPTARG;;
	p)
		pathtogenomes=$OPTARG;;
	t)
	    temp=$OPTARG;;
	esac
done		
		
while read -r line
do
    OUTPUT="$(esl-seqstat "$pathtogenomes$line" | grep "Total" | grep -o [0-9]*$)"
    Z="$(echo $((OUTPUT * 2 / 1000000)))"
    cmscan -Z $Z --verbose --cut_ga --rfam --nohmmonly --cpu 6 --tblout "$temp$line.tblout" --fmt 2 --clanin $claninpath $cmpath "$pathtogenomes$line" > "$temp$line.cmscan"
    grep -v " = " "$temp$line.tblout" > "$temp$line.deoverlapped.tblout"
done < "$genomepath"

for file in $temp*.deoverlapped.tblout
do
	i=$(echo $file | awk -F "/" '{print $5}' |awk -F  "." '{print $1}')
	echo "##gff-version 3" > "$gffout$i.gff"
	while read -r line
	do
		readline=$line
		if [[ $readline =~ ^[0-9]+ ]]
		then
			echo $readline | awk '$12 == "+" {printf "%s\tInfernal-1.1.2/Rfam\t%s\t%d\t%d\t%s\t%s\t.\tTarget_Name:%s;Model:%s;Target/RF_ACC:%s;Clan_Name:%s;GC:%s\n" ,$4,$2,$10,$11,$18,$12,$2,$7,$3,$6,$15}' >> "$gffout$i.gff"
			echo $readline | awk '$12 == "-" {printf "%s\tInfernal-1.1.2/Rfam\t%s\t%d\t%d\t%s\t%s\t.\tTarget_Name:%s;Model:%s;Target/RF_ACC:%s;Clan_Name:%s;GC:%s\n" ,$4,$2,$11,$10,$18,$12,$2,$7,$3,$6,$15}' >> "$gffout$i.gff"
		fi
	done < $file
done
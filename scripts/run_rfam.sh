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
	t)																# Path for tblout output
			tblout=$OPTARG;;
	o)
			cmscan=$OPTARG;;
	p)
			pathtogenomes=$OPTARG;;
	esac
done		
		
while read -r line
do
    OUTPUT="$(esl-seqstat "$pathtogenomes/$line" | grep "Total" | grep -o [0-9]*)"
    Z="$(echo $((OUTPUT * 2 / 1000000)))"
    cmscan -Z $Z --cut_ga --rfam --nohmmonly --cpu 6 --tblout "$tblout/$line.tblout" --fmt 2 --clanin $claninpath $cmpath "$pathtogenomes/$line" > "$cmscan/$line.cmscan"
    grep -v " = " "$tblout/$line.tblout" > "$tblout/$line.deoverlapped.tblout"
done < "$genomepath"

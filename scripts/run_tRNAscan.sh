#!/bin/sh

while getopts "g:o:" agrs
do
    case $agrs in
	g)    	      	      	      	      	      	      	      	# Path to list of genomes                                                                                        
        if [ -f $OPTARG ]
		then
            genomepath=$OPTARG;
        else
            echo "[-g] $OPTARG cannot be found in the directory";   # Check for existence of files  
            exit;                                                                                 
		fi;;
	o)
		if [ -f $OPTARG ]
		then
            outpath=$OPTARG;
        else
            echo "[-o] $OPTARG cannot be found in the directory";   # Check for existence of files
            exit;                                                                                   
		fi;;
	esac
done

while read -r line
do
	tRNAscan-SE -B -o "$outpath/$line.out" "$genomepath/$line";
done

for file in "$outpath/*.out"
do
    i=$(echo $file | awk -F  "." '{print $1}')
    perl tRNAscan_SE_to_GFF_edited.pl --input="$outpath/$file" > $i.gff
done
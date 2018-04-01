#!/bin/sh

while getopts "g:p:o:" agrs
do
    case $agrs in
	g)    	      	      	      	      	      	      	      	# Path to list of genomes                                                                                        
        if [ -f $OPTARG ]
		then
            genome=$OPTARG;
        else
            echo "[-g] $OPTARG cannot be found in the directory";   # Check for existence of files  
            exit;                                                                                 
		fi;;
	p)
        path=$OPTARG;;
	o)
        outpath=$OPTARG;;
	esac
done

while read -r line
do
	tRNAscan-SE -B -o "$outpath$line.out" "$path$line";
done < $genome

for file in $outpath*.out
do
	i=$(echo $file | awk -F "/" '{print $4}' |awk -F  "." '{print $1}')
    perl scripts/tRNAscan_SE_to_GFF_edited.pl --input="$file" > $outpath$i.gff
done
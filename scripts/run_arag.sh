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
		if [ -f $OPTARG ]
		then
            path=$OPTARG;
        else
            echo "[-p] $OPTARG cannot be found in the directory";   # Check for existence of files  
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
	aragorn -m -t -fasta -gcbact -o "$outpath/$line.out" "$path/$line";
done < $genome

for file in "$outpath/*.out"
do
    perl scripts/aragorn_fasta.pl $file "$outpath/$file.fasta";
done

for file in "$outpath/*.out.fasta"
do
	i=$(echo $file | awk -F  "." '{print $1}')
    perl scripts/aragorn_gff.pl $file "$outpath/$i.gff";
done

rm *.out
rm *.fasta
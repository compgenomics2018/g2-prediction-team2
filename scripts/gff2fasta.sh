#!/bin/bash

# Script to extract sequences from GFF files
# Date of last modification: 03/25/2018
# Report issues to: <sarthaksharma@gatech.edu>

# change according to work environment
ASSEMBLIES_PATH="/projects/data/Final_Assemblies"
BEDTOOLS_PATH="/projects/data/gene_prediction_team2/tools/bedtools2/bin"
MERGED_GFF_PATH="/projects/data/gene_prediction_team2/ab_initio_merged/"
OUTPUT_FASTA_PATH="/projects/data/gene_prediction_team2/fasta_ab_initio_merged/"

for fullFilePath in $MERGED_GFF_PATH/*.gff;
do
	filename=$(basename $fullFilePath)
	$BEDTOOLS_PATH/bedtools getfasta -fi $ASSEMBLIES_PATH/${filename%.*}.fasta -bed $MERGED_GFF_PATH/${filename%.*}.gff > $OUTPUT_FASTA_PATH/${filename%.*}_genes.fa
done

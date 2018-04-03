#!/bin/bash

# Script to extract sequences from GFF files
# Date of last modification: 03/25/2018
# Report issues to: <sarthaksharma@gatech.edu>

# Format for paths - note that there's no '/' at the end of paths
# ASSEMBLIES_PATH="/projects/data/Final_Assemblies"
# BEDTOOLS_PATH="/projects/data/gene_prediction_team2/tools/bedtools2/bin"
# MERGED_GFF_PATH="/projects/data/gene_prediction_team2/ab_initio_merged"
# OUTPUT_FASTA_PATH="/projects/data/gene_prediction_team2/fasta_ab_initio_merged"

ARGS=()
while [[ $# -gt 0 ]]
do
arg="$1"

case $arg in
	-a|--assemblies_path)
	ASSEMBLIES_PATH="$2"
	shift
	shift
	;;
	-b|--bedtools_path)
	BEDTOOLS_PATH="$2"
	shift
	shift
	;;
	-m|--merged_gff_path)
	MERGED_GFF_PATH="$2"
	shift
	shift
	;;
	-o|--output_fasta_path)
	OUTPUT_FASTA_PATH="$2"
	shift
	shift
	;;
	-h|--help)
	echo "$(basename "$0") <OPTIONS>"
	echo "Note: All of the following are required options"
	echo "-a | --assemblies_path"
	echo "		Path to final assemblies (Fasta Files)"
	echo "-b | --bedtools_path"
	echo "		Path to Bedtools binaries"
	echo "-m | --merged_gff_path"
	echo "		Path to final GFF files (merged after running all gene prediction tools)"
	echo "-o | --output_fasta_path"
	echo "		Path where the converted fasta files should be written"
	exit 
	;;
esac
done

set --"${ARGS[@]}"

for fullFilePath in $MERGED_GFF_PATH/*.gff;
do
	filename=$(basename $fullFilePath)
	$BEDTOOLS_PATH/bedtools getfasta -name+ -fi $ASSEMBLIES_PATH/${filename%.*}.fasta -bed $MERGED_GFF_PATH/${filename%.*}.gff > $OUTPUT_FASTA_PATH/${filename%.*}_genes.fa
	echo "${filename%.*}.gff converted to ${filename%.*}_genes.fa"
done

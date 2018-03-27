#!/bin/bash

# Paths to clean GFFs
ncRNA_path="/projects/data/gene_prediction_team2/gff_ncRNA_merged/clean"
abInitio_path="/projects/data/gene_prediction_team2/gff_ab_initio_merged/clean"
output_path="/projects/data/gene_prediction_team2/Final_Predictions_Merged"

for f in $ncRNA_path/*.gff;
do
	# both the gffs have the same name
	ncRNA_gff=$(basename $f)
	abInitio_gff=$(basename $f)
	# even the output file should have the same name
	output_gff=$(basename $f)
	cat $ncRNA_path/$ncRNA_gff $abInitio_path/$abInitio_gff > $output_path/${output_gff}
done
	

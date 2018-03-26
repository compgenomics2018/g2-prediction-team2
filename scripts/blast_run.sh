#!/bin/bash

# Shell script for running blast
# Date of last modification: 03/25/2018
# Report issues to: <sarthaksharma@gatech.edu>

# change these according to your work environment
BLAST_PATH="/projects/data/gene_prediction_team2/tools/comparative/blast+/ncbi-blast-2.7.1+/bin"
DATABASE_PATH="/projects/data/gene_prediction_team2/validation/makeblastdb" 
OUTPUT_PATH="/projects/data/gene_prediction_team2/validation/blast_hits/ncRNA_merged_blast"
PREDICTED_GENES_PATH="/projects/data/gene_prediction_team2/fasta_ncRNA_merged"

for fullFilePath in $PREDICTED_GENES_PATH/*.fa; 
do
	filename=$(basename $fullFilePath)
	$BLAST_PATH/blastn -db $DATABASE_PATH/klebsiella_ref_db -query $PREDICTED_GENES_PATH/$filename -num_threads 4 -outfmt 6 -max_target_seqs 1 -best_hit_score_edge 0.05 -best_hit_overhang 0.25 -out $OUTPUT_PATH/${filename%.*}_blast.gff 
done;

#!/bin/sh

for file in *.out
do
    i=$(echo $file | awk -F  "." '{print $1}')
    perl /projects/data/gene_prediction_team2/predicted_genes/tRNAscan_results/tRNAscan_SE_to_GFF_edited.pl --input=/projects/data/gene_prediction_team2/predicted_genes/tRNAscan_results/$file > $i.gff
done

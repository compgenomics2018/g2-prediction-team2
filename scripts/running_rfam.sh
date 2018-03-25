#!/bin/sh

for file in *.fasta
do
	OUTPUT="$(esl-seqstat $file | grep "Total" | grep -o [0-9]*)"
    Z="$(echo $((OUTPUT * 2 / 1000000)))"
    cmscan -Z $Z --cut_ga --rfam --nohmmonly --cpu 6 --tblout /projects/data/gene_prediction_team2/predicted_genes/rfam_results/$file.tblout --fmt 2 --clanin /projects/data/gene_prediction_team2/tools/ncRNAs/Rfam_database/Rfam.clanin /projects/data/gene_prediction_team2/tools/ncRNAs/Rfam_database/Rfam.cm $file > /projects/data/gene_prediction_team2/predicted_genes/rfam_results/$file.cmscan
    grep -v " = " /projects/data/gene_prediction_team2/predicted_genes/rfam_results/$file.tblout > /projects/data/gene_prediction_team2/predicted_genes/rfam_results/$file.deoverlapped.tblout
done

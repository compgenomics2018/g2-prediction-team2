#!/bin/sh


#require to be at the assembly output genomes directory
#inputs are fasta files


# cd /projects/data/Final_Assemblies/
for f in *.fasta
do
    f2=${f%.fasta}.out;
    /projects/data/gene_prediction_team2/tools/ncRNAs/tRNAscan_installed/bin/tRNAscan-SE -B -o /projects/data/gene_prediction_team2/predicted_genes/tRNAscan_results/$f2 $f;
done

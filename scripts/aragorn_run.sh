#!/bin/sh


#require to be at the assembly output genomes directory
#inputs are fasta files


# cd /projects/data/Final_Assemblies/
for f in *.fasta
do
  f2=${f%.fasta}.out;
  /projects/data/gene_prediction_team2/tools/ncRNAs/aragorn1.2.38_installed/aragorn -m -t -fasta -gcbact -o /projects/data/gene_prediction_team2/predicted_genes/aragron_results/$f2 $f;
done

#!/bin/

#aragorn output format to fasta format
#require to be at the aragorn outputs directory
#perl script aragorn_fasta.pl is required

#cd /projects/data/gene_prediction_team2/predicted_genes/aragron_results/
for f in *.out; do f2=${f%.out}.fasta; perl aragorn_fasta.pl $f $f2; done

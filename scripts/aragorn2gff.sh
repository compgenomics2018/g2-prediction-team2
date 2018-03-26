#!/bin/

#aragorn output format to fasta format
#require to be at the aragorn fasta files directory
#perl script aragorn_gff.pl is required

#cd /projects/data/gene_prediction_team2/predicted_genes/aragron_results/
for f in *.fasta; do f2=${f%.fasta}.gff; perl aragorn_gff.pl $f $f2; done

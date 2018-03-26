#!/bin/sh

for file in *.fasta.deoverlapped.tblout.gff
do
	i=$(echo $file | awk -F  "." '{print $1}')
	mv $file $i.gff
done


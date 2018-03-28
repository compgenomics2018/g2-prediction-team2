#!/bin/bash

# Wrapper around the python gff sorter ('sort_gff.py')
# @author: Sarthak Sharma <sarthaksharma@gatech.edu>
# Date of Last Modification: 03/27/2018

# Change the paths according to work environment
input_gff_path="temp/merging/allFiles"
output_path="results"

for f in $input_gff_path/*.gff;
do
        filename=$(basename $f)
        output_file=${filename%.*}
        echo $filename
        ./sort_gff.py $f $output_path/$output_file
done
echo "Sorted GFF Files saved in $output_path."


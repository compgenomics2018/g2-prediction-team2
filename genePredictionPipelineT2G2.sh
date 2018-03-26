#!/bin/bash

##### Final pipeline for Comp. Genomics 2018 Team 2, Group 2 (Gene Prediction)
##### This script will predict genes in any number of assembled genomes

##### HOW TO RUN
### put all of the assembled genomes into a directory
### ./genePredictionPipelineT2G2 /path/to/assemblies

##### Input and Outputs
### input: path to assemblies
### temp: results from each individual tool and a file containing a list of the assembled genomes (this directory will be removed unless otherwise stated)
### output: one gff file per sample containing all predicted genes

###################################################################### Command line Arguments
t=0
v=0

while getopts ":p:tv" opt; do
  case ${opt} in
    p ) path=$OPTARG
	  ;;
      t )t=1
	  ;;
    v ) v=1
	  ;;
    \? ) echo "Usage: [-p path/to/assembledGenomes], [-t if you want to keep the temp directories], [-v for verbose mode]"
      ;;
  esac
done

###################################################################### Create directory structure

if [ $v == 1 ]; then
    printf "Creating directory structure...\\n"
fi

mkdir temp
mkdir temp/genePrediction
mkdir temp/merging
mkdir temp/genePrediction/prodigalResults
mkdir temp/genePrediction/geneMarkResults
mkdir temp/genePrediction/rfamResults
mkdir temp/genePrediction/aragonResults
mkdir temp/genePrediction/tRNAscanResults
mkdir temp/merging/abinitioMerge
mkdir temp/merging/ncRNAMerge
mkdir results

if [ $v == 1 ]; then
    printf "Done!\\n"
fi

if [ $v == 1 ]; then
    printf "Creating a file containing the list of the filenames of the asselbles genomes...\\n"
fi

#create file with a list of the assemblies
ls $path > temp/fileList.txt

if [ $v == 1 ]; then
    printf "Done!\\n"
fi

###################################################################### Run all gene prediction tools

if [ $v == 1 ]; then
    printf "Starting to predict genes, this might take a while...\\n"
fi

##### Prodigal

if [ $v == 1 ]; then
    printf "Predicting genes using prodigal...\\n"
fi

./scripts/run_prodigal temp/fileList.txt $path temp/genePrediction/prodigalResults/

if [ $v == 1 ]; then
    printf "Done!\\n"
fi

##### GeneMarkS

if [ $v == 1 ]; then
    printf "Predicting genes using GeneMarkS...\\n"
fi

python scripts/gm_script.py -a temp/fileList.txt -i $path -o temp/genePrediction/geneMarkResults/ -f GFF

if [ $v == 1 ]; then
    printf "Done!\\n"
fi

##### Rfam

if [ $v == 1 ]; then
    printf "Starting to predict genes on non-Coding RNA. Almost there!!\\n"
fi

if [ $v == 1 ]; then
    printf "Predicting genes on non-coding RNA using Rfam...\\n"
fi

#script to run Rfam

if [ $v == 1 ]; then
    printf "Done!\\n"
fi

##### Aragon

if [ $v == 1 ]; then
    printf "Predicting genes on non-coding RNA using Aragon...\\n"
fi

#script to run Aragon

if [ $v == 1 ]; then
    printf "Done!\\n"
fi

##### tRNAscan

if [ $v == 1 ]; then
    printf "Predicting genes on non-coding RNA using tRNAscan...\\n"
fi

#script to run tRNAscan

if [ $v == 1 ]; then
    printf "Done!\\n"
fi

if [ $v == 1 ]; then
    printf "Finally finished predicting genes!\\n"
fi

###################################################################### Merge everything into one file

if [ $v == 1 ]; then
    printf "Starting to merge results...\\n"
fi

##### Merge Prodigal + GeneMarkS Results

if [ $v == 1 ]; then
    printf "Merging Prodigal and GeneMarkS results...\\n"
fi

python ab_initio_merged.py -a temp/fileList.txt -i1 temp/genePrediction/geneMarkResults -i2 temp/genePrediction/prodigalResults -o temp/merging/abinitioMerge/ -f gff

if [ $v == 1 ]; then
    printf "Done!\\n"
fi

##### Merge ncRNA Results

if [ $v == 1 ]; then
    printf "Merging non-coding RNA results...\\n"
fi

#script to merge Prodigal + GeneMark

if [ $v == 1 ]; then
    printf "Done!\\n"
fi

##### Merge all results

if [ $v == 1 ]; then
    printf "Merging all results...\\n"
fi

#script to merge abinitio + ncRNA

if [ $v == 1 ]; then
    printf "Done!\\n"
fi

if [ $v == 1 ]; then
    printf "Finished merging everything!!\\n"
fi

###################################################################### Clean everything

if [ $t == 0 ]; then
    rm -r temp
elif [ $t == 1 ]; then
    echo "Temp directory will not be deleted.\\n"
fi

if [ $v == 1 ]; then
    printf "Everything is ready, you should now have high-quality gene predictions in the /results directory\\n"
fi

#!/bin/bash

##### Final pipeline for Comp. Genomics 2018 Team 2, Group 2 (Gene Prediction)
##### This script will predict genes in any number of assembled genomes

##### HOW TO RUN
### put all of the assembled genomes into a directory
### Run this command:  ./genePredictionPipelineT2G2.sh -p /path/to/assemblies [-t and -v are optional]
### Usage: [-p /path/to/assemblies], [-h for faster predictions, will run GeneMarkHMM instead of GeneMarkS],
### [-g for faster predictions, will run GeneMarkHMM instead of GeneMarkS],
### [-t to keep temp filed and directories], and [-v for verbose mode]

##### Input and Outputs
### input: path to assemblies
### temp: results from each individual tool (this directory will be removed unless otherwise stated)
### output: one gff file per sample containing all predicted genes (union of all 5 tools)
###         if '-f' is used, fasta files will also be created

###################################################################### Command line Arguments
t=0
v=0
g=0
f=0

while getopts ":p:ftv" opt; do
  case ${opt} in
      p ) path=$OPTARG
	  ;;
      g )g=1
	  ;;
      t )t=1
	  ;;
      f )f=1
	  ;;
      v )v=1
	  ;;
      h ) printf "Usage: [-p path/to/assembledGenomes], [-h for faster predictions, will run GeneMarkHMM instead of GeneMarkS], [-f to create both gff and fasta files], [-t to keep temp files and directories], and [-v for verbose mode]\\n"
	  ;;
    \? ) printf "Usage: [-p path/to/assembledGenomes], [-h for faster predictions, will run GeneMarkHMM instead of GeneMarkS], [-f to create both gff and fasta files], [-t to keep temp files and directories], and [-v for verbose mode]\\n"
	  ;;
  esac
done

###################################################################### Create directory structure

#warning statement when fast version of script is run
if [ $g == 1 ]; then
    printf "****************************************************************************\\n\\n"
    printf "WARNING!\\n"
    printf "You are running the fast version of the script, this might affect the quality of your results.\\n"
    printf "GeneMark-S will not be run. GeneMark-HMM will be run instead.\\n"
    printf "****************************************************************************\\n\\n"
fi


if [ $v == 1 ]; then
    printf "Creating directory structure...\\n"
fi

mkdir temp
mkdir temp/genePrediction
mkdir temp/genePrediction/prodigalResults
mkdir temp/genePrediction/geneMarkResults
mkdir temp/genePrediction/rfamResults
mkdir temp/genePrediction/rfamResults/other
mkdir temp/genePrediction/aragornResults
mkdir temp/genePrediction/tRNAscanResults
mkdir temp/merging
mkdir temp/merging/abinitioMerge
mkdir temp/merging/ncRNAMerge
mkdir temp/merging/allFiles
mkdir results

if [ $f == 1 ]; then
    mkdir results/gff
    mkdir results/fasta
fi

if [ $v == 1 ]; then
    printf "Done!\\n"
fi

if [ $v == 1 ]; then
    printf "Creating a list of the filenames of the asselbles genomes...\\n"
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

##### GeneMark (if -f flag is used, GeneMarkHMM will be run, otherwise GeneMarkS will run)

if [ $g == 0 ]; then
    if [ $v == 1 ]; then
	printf "Predicting genes using GeneMark-S...\\n"
	fi
    
    python scripts/gm_script.py -a temp/fileList.txt -i $path -o temp/genePrediction/geneMarkResults/ -f GFF
    
    rm GeneMark_hmm*
    rm gms.log
    
    if [ $v == 1 ]; then
	printf "Done!\\n"
	fi
elif [ $g == 1 ]; then
    if [ $v == 1 ]; then
	printf "Predicting genes using GeneMark-HMM...\\n"
	fi
    
    python scripts/gmhmmp.py -a temp/fileList.txt -i $path -o temp/genePrediction/geneMarkResults/ -f GFF
    
    rm GeneMark_hmm*
    rm gms.log

    if [ $v == 1 ]; then
	printf "Done!\\n"
	fi
fi

##### Rfam

if [ $v == 1 ]; then
    printf "Starting to predict genes on non-Coding RNA. Almost there!!\\n"
fi

if [ $v == 1 ]; then
    printf "Predicting genes on non-coding RNA using Rfam...\\n"
fi

unzip scripts/other/Rfam*

./scripts/run_rfam.sh -g temp/fileList.txt -c scripts/other/Rfam.clanin -m scripts/other/Rfam.cm -t temp/genePrediction/rfamResults/ -o temp/genePrediction/rfamResults/other/ -p $path

gunzip scripts/other/Rfam*

if [ $v == 1 ]; then
    printf "Done!\\n"
fi

##### aragorn

if [ $v == 1 ]; then
    printf "Predicting genes on non-coding RNA using aragorn...\\n"
fi

./scripts/run_arag.sh -g temp/fileList.txt -p $path -o temp/genePrediction/aragornResults/

if [ $v == 1 ]; then
    printf "Done!\\n"
fi

##### tRNAscan

if [ $v == 1 ]; then
    printf "Predicting genes on non-coding RNA using tRNAscan...\\n"
fi

./scripts/run_tRNAscan.sh -g temp/fileList.txt -p $path -o temp/genePrediction/tRNAscanResults/

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

python scripts/ab_initio_merged.py -a temp/fileList.txt -i1 temp/genePrediction/geneMarkResults/ -i2 temp/genePrediction/prodigalResults/ -o temp/merging/abinitioMerge/ -f gff

ls temp/merging/abinitioMerge/ > temp/abinitioMerge_list.txt

mkdir temp/merging/abinitioMerge/clean

perl scripts/clean_gff.pl temp/abinitioMerge_list.txt temp/merging/abinitioMerge/ temp/merging/abinitioMerge/clean/

if [ $v == 1 ]; then
    printf "Done!\\n"
fi


##### Merge ncRNA Results

if [ $v == 1 ]; then
    printf "Merging non-coding RNA results...\\n"
fi

python scripts/ncRNA_merged.py -a temp/fileList.txt -i1 temp/genePrediction/rfamResults/ -i2 temp/genePrediction/tRNAscanResults/ -i3 temp/genePrediction/aragornResults/ -o temp/merging/ncRNAMerge/ -f gff

ls temp/merging/ncRNAMerge/ > temp/ncRNAMerge_list.txt

mkdir temp/merging/ncRNAMerge/clean

perl scripts/clean_gff.pl temp/ncRNAMerge_list.txt temp/merging/ncRNAMerge/ temp/merging/ncRNAMerge/clean/

if [ $v == 1 ]; then
    printf "Done!\\n"
fi

##### Merge all results

if [ $v == 1 ]; then
    printf "Merging all results...\\n"
fi

./scripts/cat_gff.sh

if [ $v == 1 ]; then
    printf "Done!\\n"
fi

if [ $v == 1 ]; then
    printf "Finished merging everything!!\\n"
fi

ls temp/merging/allFiles/ > temp/mergedFilesList.txt

###################################################################### Clean gff files

if [ $v == 1 ]; then
    printf "Cleaning the files...\\n"
fi

if [ $f == 0 ]; then
perl scripts/clean_gff.pl temp/mergedFilesList.txt temp/merging/allFiles/ results/
fi

if [ $f == 1 ]; then
perl scripts/clean_gff.pl temp/mergedFilesList.txt temp/merging/allFiles/ results/gff/
fi

if [ $v == 1 ]; then
    printf "Done!\\n"
fi

###################################################################### Final Steps

##### Create fasta files if '-f' is used                                                                           

if [ $f == 1 ]; then

    if [ $v == 1 ]; then
        printf "Converting GFF files to Fasta format...\\n"
    fi

    ./scripts/gff2fasta.sh -a $path -m results/gff/ -o results/fasta/                                                                             

    if [ $v == 1 ]; then
        printf "Done!\\n"
    fi
fi

##### Final Statements

if [ $t == 0 ]; then
    rm -r temp
elif [ $t == 1 ]; then
    printf "Temp directory will not be deleted.\\n"
fi

if [ $v == 1 ]; then
    printf "Everything is ready, you should now have high-quality gene predictions in the /results directory.\\n"
fi

#!/bin/bash

##### Final pipeline for Comp. Genomics 2018 Team 2, Group 2 (Gene Prediction)
##### This script will predict genes in any number of assembled genomes

##### HOW TO RUN
### put all of the assembled genomes into a directory
### Run this command:  ./genePredictionPipelineT2G2.sh -p /path/to/assemblies [-t and -v are optional]
### Usage: [-p /path/to/assemblies], [-f for faster predictions, will run GeneMarkHMM instead of GeneMarkS, will not run Rfam],
###[-t to keep temp filed and directories], [-v for verbose mode]

##### Input and Outputs
### input: path to assemblies
### temp: results from each individual tool (this directory will be removed unless otherwise stated)
### output: one gff file per sample containing all predicted genes (union of all 5 tools)

###################################################################### Command line Arguments
t=0
v=0
f=0

while getopts ":p:ftv" opt; do
  case ${opt} in
    p ) path=$OPTARG
	  ;;
      f )f=1
	  ;;
      t )t=1
	  ;;
    v ) v=1
	  ;;
    \? ) echo "Usage: [-p path/to/assembledGenomes], [[-f for faster predictions, will run GeneMarkHMM instead of GeneMarkS, will not run Rfam], [-t to keep temp files and directories], [-v for verbose mode]"
      ;;
  esac
done

###################################################################### Create directory structure

#warning statement when fast version of script is run
if [ $f == 1 ]; then
    printf "****************************************************************************\\n\\n"
    printf "WARNING!\\n"
    printf "You are running the fast version of the script, this might affect the quality of your results.\\n"
    printf "GeneMark-S will not be run. GeneMark-HMM will be run instead.\\n"
    printf "Rfam will not be run. Results might contain less sRNA gene predictions.\\n\\n"
    printf "****************************************************************************\\n\\n"
fi


if [ $v == 1 ]; then
    printf "Creating directory structure...\\n"
fi

mkdir temp
mkdir temp/genePrediction
mkdir temp/merging
mkdir temp/genePrediction/prodigalResults
mkdir temp/genePrediction/geneMarkResults
mkdir temp/genePrediction/rfamResults
mkdir temp/genePrediction/rfamResults/other
mkdir temp/genePrediction/aragonResults
mkdir temp/genePrediction/tRNAscanResults
mkdir temp/merging/abinitioMerge
mkdir temp/merging/abinitioMerge/clean
mkdir temp/merging/ncRNAMerge
mkdir temp/merging/ncRNAMerge/clean
mkdir results

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

if [ $f == 0 ]; then
    if [ $v == 1 ]; then
	printf "Predicting genes using GeneMark-S...\\n"
	fi
    
    python scripts/gm_script.py -a temp/fileList.txt -i $path -o temp/genePrediction/geneMarkResults/ -f GFF
    
    rm GeneMark_hmm*
    rm gms.log
    
    if [ $v == 1 ]; then
	printf "Done!\\n"
	fi
elif [ $f == 1 ]; then
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

if [ $f == 0 ]; then
    if [ $v == 1 ]; then
	printf "Predicting genes on non-coding RNA using Rfam...\\n"
	fi

    ./run_rfam.sh -g temp/fileList.txt -c scripts/other/Rfam.clanin -m scripts/other/Rfam.cm -t temp/genePrediction/rfamResults/ -o temp/genePrediction/other/rfamResults/other/ -p $path

    if [ $v == 1 ]; then
	printf "Done!\\n"
	fi
fi

##### Aragon

if [ $v == 1 ]; then
    printf "Predicting genes on non-coding RNA using Aragon...\\n"
fi

./run_arag.sh -g temp/fileList.txt -p $path -o temp/genePrediction/aragonResults/

if [ $v == 1 ]; then
    printf "Done!\\n"
fi

##### tRNAscan

if [ $v == 1 ]; then
    printf "Predicting genes on non-coding RNA using tRNAscan...\\n"
fi

./run_tRNAscan.sh -g temp/fileList.txt -p $path -o temp/genePrediction/tRNAscanResults/

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

if [ $f == 0 ]; then
    if [ $v == 1 ]; then
	printf "Merging Prodigal and GeneMarkS results...\\n"
	fi

    python ab_initio_merged.py -a temp/fileList.txt -i1 temp/genePrediction/geneMarkResults -i2 temp/genePrediction/prodigalResults -o temp/merging/abinitioMerge/ -f gff

    ls temp/merging/abinitioMerge/ > temp/abinitioMerge_list.txt

    perl scripts/clean_gff.pl temp/abinitioMerge_list.txt temp/merging/abinitioMerge/ temp/merging/abinitioMerge/clean/

    if [ $v == 1 ]; then
	printf "Done!\\n"
	fi
fi

##### Merge ncRNA Results

if [ $v == 1 ]; then
    printf "Merging non-coding RNA results...\\n"
fi

#script to merge all ncRNA results > write too /merging/ncRNAMerge

ls temp/merging/ncRNAMerge/ > temp/ncRNAMerge_list.txt

perl scripts/clean_gff.pl temp/ncRNAMerge_list.txt temp/merging/ncRNAMerge/ temp/merging/ncRNAMerge/clean/

if [ $v == 1 ]; then
    printf "Done!\\n"
fi

##### Merge all results

if [ $v == 1 ]; then
    printf "Merging all results...\\n"
fi

# script to cat results

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
    printf "Everything is ready, you should now have high-quality gene predictions in the /results directory.\\n"
fi

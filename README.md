Team 2, Group 2 - Gene Prediction

This repository contains a pipeline to predict genes from assembled genomes in fasta format. 

##### Tools used by this pipeline:
      Prodigal, GeneMark-S (or GeneMark-HMM when '-f' flag is used), Rfam, Aragorn, and tRNAscan


##### HOW TO RUN
    
    1. Put all of the assembled genomes (in fasta format) into a directory
    2. Run this command:  ./genePredictionPipelineT2G2.sh -p /path/to/assemblies [-f, -h, -t, and -v are optional]

    Usage: [-p /path/to/assemblies], [-f to create fasta and gff files], [-g for faster predictions, will run GeneMarkHMM instead of GeneMarkS], [-t to keep temp files and directories], [-v for verbose mode], [-h for help/usage]


##### Input and Outputs
      input: path to assemblies
      temp: results of each individual tool and step (this directory will be removed unless otherwise stated)
      output: one gff file per sample containing all predicted genes (union of all 5 tools)
      	      if '-f' is used, fasta files will also be created

#####
For general info, see the [project's wiki page](http://www.compgenomics2018.biosci.gatech.edu/index.php?title=Team_II_Gene_Prediction_Group).
#####


##### Directory structure:

The repository is organized as follows:

    
    ├── final_pipeline.sh       # Final gene prediction pipeline
    ├── README.md         	# Document you are currently reading, describes the pipeline
    ├── scripts/		# Directory containing all of the scripts necessary to run the pipeline 
    ├──	results			# Directory containing the final results (will be created when pipeline is run)
    	├── gff			# If '-f' is used, results in gff format will be stored here
        ├── fasta		# If '-f' is used, gff to fasta conversion results will be placed here
    ├── temp			# Directory containing temporary files (will be deleted unless '-t' is used)

The temp/ directory is organized as follows:

	├── temp/
	    ├── genePrediction
		├── prodigalResults	# Directory containing results from Prodigal
		├── geneMarkResults	# Directory containing results from GeneMark-S (or GeneMark-HMM if '-g' is used)
		├── rfamResults		# Directory containing results from Rfam
		    ├── other		# Directory containing files created when Rfam is run
		├── aragnoResults	# Directory containing results from Aragorn
		├──tRNAscanResults	# Directory containing results from tRNAscan
	    ├── merging			# Directory containing all of the merged results
		├── abinitioMerge	# Directory containing the merged results of Prodigal and GeneMark
		├── ncRNAMerge		# Directory containing the merged results of Rfam, Aragorn, and tRNAscan
		├── allFiles		# Directory containing the merged gff files (before cleaning)
	    ├── results			# Directory containing the final results
		├── gff			# If '-f' is used, results in gff format will be stored here
		├── fasta		# If '-f' is used, gff to fasta conversion results will be placed here


##### Installation & Dependencies

No installation is needed, only thing required is to clone the repository and run the `final_pipeline.sh` script.

However, several dependencies are assumed in the path:

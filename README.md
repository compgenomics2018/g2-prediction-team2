# g2-prediction-team2

This repository contains a set of gene prediction scripts for Team II's Gene Prediction Group. 

For general info, see the [project's wiki page](http://www.compgenomics2018.biosci.gatech.edu/index.php?title=Team_II_Gene_Prediction_Group).

## File Structure and Usage

The repository is organized as follows:

    .
    ├── final_pipeline.sh       # Final gene prediction pipeline
    ├── gene prediction         # A set of scripts for the actual gene prediction
    │   ├── ab-initio           # ab-initio gene prediction scripts
    │   ├── reference           # Homology gene prediction scripts
    ├── validation              # Blast
    └

To predict a gene, run

    ./final_pipeline 

To display additional options, run

    ./final_pipeline -h

The remaining folders contain individual scripts which are not necessarily included in the final pipeline. Some of these scripts **might only work on** `biogenome2018b.biology.gatech.edu` server since they rely on specific files present on this server.

## Installation & Dependencies

No installation is needed, only thing required is to clone the repository and run the `final_pipeline.sh` script.

However, several dependencies are assumed in the path:


	
A description of each of these tools is available in the [project's wiki](http://www.compgenomics2018.biosci.gatech.edu/Team_II_Genome_Assembly_Group).

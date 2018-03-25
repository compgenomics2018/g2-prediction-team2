import os
import sys
import argparse

# parsing the arguments                                                                                                                                       
parser = argparse.ArgumentParser(description='Process some files')
parser.add_argument('-a', '--assembly_list', type=str, help='genome list file')
parser.add_argument('-i1', '--input_GeneMark_files_loc', type=str, help='Path to genome files')
parser.add_argument('-i2', '--input_prodigal_files_loc', type=str, help='Path to genome files')
parser.add_argument('-o', '--output_directory', type=str, help='Path to output file')
parser.add_argument('-f', '--output_format', type=str, help='format - GFF or LST')
args = parser.parse_args()

# assigning variables                                                                                                                                         
assembly_list = args.assembly_list
GeneMark_files_loc = args.input_GeneMark_files_loc
profigal_files_loc = args.input_prodigal_files_loc
output_directory = args.output_directory
output_format = args.output_format

assembly_files = open(assembly_list, 'r')

# running bedtools intersect and merging files                                                                                                                   
for line in assembly_files:
    assembly_file_name = line.rstrip()
    file_name, extension = os.path.splitext(assembly_file_name)
    gene_mark_predicted = GeneMark_files_loc + file_name + "." + "GFF"
    prodigal_predicted = profigal_files_loc + file_name + "." + "gff"
    output_file = output_directory + file_name + "." + "gff"
    cmd_1 = 'bedtools intersect -s -v -f 0.8 -F 0.8 -a %s -b %s > merged_file'%(gene_mark_predicted, prodigal_predicted)
    cmd_2 = 'cat %s %s >> %s'%(prodigal_predicted,"merged_file",output_file)
    os.system(cmd_1)
    os.system(cmd_2)
    os.system("rm merged_file")

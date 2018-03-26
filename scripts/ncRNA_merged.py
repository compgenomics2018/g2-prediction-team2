import os
import sys
import argparse

# parsing the arguments                                                                                                                                       
parser = argparse.ArgumentParser(description='Process some files')
parser.add_argument('-a', '--assembly_list', type=str, help='genome list file')
parser.add_argument('-i1', '--input_rfam_files_loc', type=str, help='Path to rfam files')
parser.add_argument('-i2', '--input_tRNAscan_files_loc', type=str, help='Path to tRNAscan files')
parser.add_argument('-i3', '--input_aragron_files_loc', type=str, help='Path to aragron files')
parser.add_argument('-o', '--output_directory', type=str, help='Path to output file')
parser.add_argument('-f', '--output_format', type=str, help='format - GFF or LST')
args = parser.parse_args()

# assigning variables                                                                                                                                         
assembly_list = args.assembly_list
rfam_files_loc = args.input_rfam_files_loc
tRNAscan_files_loc = args.input_tRNAscan_files_loc
aragron_files_loc = args.input_aragron_files_loc
output_directory = args.output_directory
output_format = args.output_format

assembly_files = open(assembly_list, 'r')

# running bedtools intersect and merging files                                                                                                                   
for line in assembly_files:
    assembly_file_name = line.rstrip()
    file_name, extension = os.path.splitext(assembly_file_name)
    rfam_predicted = rfam_files_loc + file_name + "." + "gff"
    tRNAscan_predicted = tRNAscan_files_loc + file_name + "." + "gff"
    aragron_predicted = aragron_files_loc + file_name + "." + "gff"
    output_file = output_directory + file_name + "." + "gff"
    cmd_1 = 'bedtools intersect -s -v -f 0.8 -F 0.8 -a %s -b %s > merged_tRNA_file'%(tRNAscan_predicted, rfam_predicted)
    cmd_2 = 'bedtools intersect -s -v -f 0.8 -F 0.8 -a %s -b %s > merged_ara_file'%(aragron_predicted, rfam_predicted) 
    cmd_3 = 'cat %s %s %s >> %s'%(rfam_predicted,"merged_tRNA_file","merged_ara_file",output_file)
    os.system(cmd_1)
    os.system(cmd_2)
    os.system(cmd_3)
    os.system("rm merged_tRNA_file")
    os.system("rm merged_ara_file")

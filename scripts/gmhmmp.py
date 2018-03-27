import os
import sys
import argparse

# parsing the arguments
parser = argparse.ArgumentParser(description='Process some files')
parser.add_argument('-a', '--assembly_list_loc', type=str, help='Path to genome list file')
parser.add_argument('-i', '--input_files_loc', type=str, help='Path to genome files')
parser.add_argument('-o', '--output_directory', type=str, help='Path to output file')
parser.add_argument('-f', '--output_format', type=str, help='format - GFF or LST')
args = parser.parse_args()

# assigning variables
assembly_list_loc = args.assembly_list_loc
input_files_loc = args.input_files_loc
output_directory = args.output_directory
output_format = args.output_format

assembly_files = open( assembly_list_loc, 'r')
 
# running GeneMark for each assembled file 
for line in assembly_files:
    assembly_file_name = line.rstrip()
    assembly_file = input_files_loc + assembly_file_name
    file_name, extension = os.path.splitext(assembly_file_name)
    output_file = output_directory + file_name + "." + "GFF"
    cmd = 'gmsn.pl %s --format %s --output %s'%(assembly_file, output_format , output_file)
    os.system(cmd)
    break
cmd2 = "rm %s*.GFF"%(output_directory)
os.system(cmd2)

for line in assembly_files:
    assembly_file_name = line.rstrip()
    assembly_file = input_files_loc + assembly_file_name
    file_name, extension = os.path.splitext(assembly_file_name)
    output_file = output_directory + file_name + "." + "GFF"
    cmd = 'gmhmmp -r -p 0 -m GeneMark_hmm.mod -f %s -o %s %s'%(output_format, output_file, assembly_file)
    os.system(cmd)
    
os.system("rm startseq*")
os.system("rm gibbs_out*")
os.system("rm itr*")
os.system("rm sequence")

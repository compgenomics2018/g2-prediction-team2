#!/usr/bin/python

# Program to sort gff files by
# scaffold number and then by start position 
# @author: Sarthak Sharma <sarthaksharma@gatech.edu>
# Date of Last Modification: 03/27/2018

import sys

def getFileLines(fileName):
    with open(fileName, 'r') as inFile:
        fileLines = inFile.readlines()
        return fileLines

def getSortedFileLines(fileLines):
    sortedFileLines = _sortFileLines(fileLines)
    return sortedFileLines

def writeSortedFile(sortedFileLines,sortedFileName):
    with open(sortedFileName,'w') as outFile:
        for line in sortedFileLines:
            line = "\t".join(line)
            outFile.write(str(line)+'\n')

def _sortFileLines(fileLines):
    fileLines = [line.strip().split("\t") for line in fileLines]
    # extracting the number from the scaffold ID and using it to sort, and using the start site to sort
    sortedFileLines = sorted(fileLines, key = lambda x: (int(x[0].split('|')[0][8:]),int(x[3])))
    return sortedFileLines

def main():
    fileName = sys.argv[1]
    sortedFileName = sys.argv[2] + "_sorted.gff"
    fileLines = getFileLines(fileName)
    sortedFileLines = getSortedFileLines(fileLines)
    #sortedFileName = fileName[:-4] + "_sorted"
    writeSortedFile(sortedFileLines,sortedFileName)

if __name__ == '__main__':
    main()


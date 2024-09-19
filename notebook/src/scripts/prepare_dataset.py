#!/usr/bin/python3
import sys
import os
import shutil
import glob


def move_files(source, destination):
    realpath_source = os.path.abspath(source)
    realpath_dest = os.path.abspath(destination)
    allfiles = glob.glob(os.path.join(realpath_source, '*'), recursive=True)
    print("Files to move", allfiles)
    
    # # iterate on all files to move them to destination folder
    for file_path in allfiles:
        dst_path = os.path.join(realpath_dest, os.path.basename(file_path))
        shutil.move(file_path, dst_path)
        print(f"Moved {file_path} -> {dst_path}")

dataset_path = None

try:
    dataset_path = sys.argv[1]
except IndexError:
    print("You must provide the path to the dataset")
    sys.exit(1)

unknown_path = dataset_path + "/unknown"

species = [
    "celtis_australis",
    "juniperus_procera",
    "juniperus_thurifera",
    "markhamia_lutea",
    "milicia_excelsa",
    "pino_halepensis",
    "prunus_africana",
    "unknown"
]

dirlist = [ item for item in os.listdir(dataset_path) if os.path.isdir(os.path.join(dataset_path, item)) ]
if not os.path.isdir(unknown_path):
    os.mkdir(unknown_path)

for specie in dirlist:
    if specie not in species:
        specie_path = os.path.join(dataset_path, specie)
        move_files(specie_path, unknown_path)
        if not os.listdir(specie_path): 
            shutil.rmtree(specie_path)
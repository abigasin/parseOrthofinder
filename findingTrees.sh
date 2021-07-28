#!/bin/bash
#SBATCH --job-name=parseOrthofinder
#SBATCH --partition=shared
#SBATCH --nodes=1
#SBATCH --cpus-per-task=1
#SBATCH -t 48:00:00
grep -o 'path' config.txt | cut -f2- -d:
while IFS= read -r line || [[ -n $line ]]; do
    echo "Gene: $line"
    mkdir $line
    grep -l $line /Volumes/LaCie/Documents/lyonslab/orthofinder/select_genetrees/* > $line/trees.txt
    grep -l $line /Volumes/LaCie/Documents/lyonslab/orthofinder/select_genetrees/* | xargs cp -t $line
done < gene_names.txt
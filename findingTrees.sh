#!/bin/bash
#SBATCH --job-name=parseOrthofinder
#SBATCH --partition=shared
#SBATCH --nodes=1
#SBATCH --cpus-per-task=1
#SBATCH -t 48:00:00
OUTPUT=$(dirname $(grep -w 'pathtree' config.txt | cut -f2 -d:))
SEQOUTPUT=$(dirname $(grep -w 'pathseq' config.txt | cut -f2 -d:))

while IFS= read -r line || [[ -n $line ]]; do
    echo "Gene: $line"
    mkdir $line
    grep -l $line ${OUTPUT}/* > $line/trees.txt
    grep -l $line ${OUTPUT}/* | xargs -I '{}' cp '{}' $line/
    grep -l $line ${SEQOUTPUT}/* | xargs -I '{}' cp '{}' $line/
done < gene_names.txt
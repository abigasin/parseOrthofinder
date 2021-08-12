#!/bin/bash
#SBATCH --job-name=parseOrthofinder
#SBATCH --partition=shared
#SBATCH --nodes=1
#SBATCH --account=sio138
#SBATCH --ntasks-per-node=16
#SBATCH -t 2:00:00
#SBATCH --mem=25GB
#SBATCH --output=output-%x.%j.out
OUTPUT=$(dirname $(grep -w 'pathtree' config.txt | cut -f2 -d:))
day=$(date +'%B_%d')
mkdir Results_${day}
cd Results_${day}/

while IFS= read -r line || [[ -n $line ]]; do
    echo "Gene: $line"
    mkdir $line
    ORTHOGROUP=$(grep -w $line ${OUTPUT}/Orthogroups/Orthogroups.tsv | awk '{print $1}')
    grep -w $line ${OUTPUT}/Orthogroups/Orthogroups.tsv | awk '{print $1}' > $line/orthologue.txt
    head -1 ${OUTPUT}/Orthogroups/Orthogroups.tsv > $line/orthogroup.tsv
    grep -w $line ${OUTPUT}/Orthogroups/Orthogroups.tsv >> $line/orthogroup.tsv
    grep -w ${ORTHOGROUP} ${OUTPUT}/Orthogroups/Orthogroups.GeneCount.tsv >> $line/orthogroup.tsv
    mkdir $line/Resolved_Gene_Trees
    cp ${OUTPUT}/Resolved_Gene_Trees/${ORTHOGROUP}_tree.txt $line/Resolved_Gene_Trees/
    mkdir $line/Orthologues
    cp ${OUTPUT}/Orthogroup_Sequences/${ORTHOGROUP}.fa $line/Orthologues/
    
done < ../gene_names.txt
#!/bin/bash


# Path to the directory containing MSA files
msa_dir="/home/taraneh/projects/iqtree-experiments/benchmark/alignments"
output_dir="/home/taraneh/projects/iqtree_results/len_pow_alpha/alpha_2"


# Loop through all MSA files in the directory
for msa_file in $msa_dir/s*.fasta; do
   # Get the base name of the MSA file (without path and extension)
   base_name=$(basename "$msa_file" .fasta)
   output_path="$output_dir/$base_name/$base_name.fasta"
   # Run IQ-TREE on the current MSA file
   iqtree3 -s "$msa_file" -m LG+G4 -pre "$output_path"


   echo "Finished analyzing $msa_file"
done

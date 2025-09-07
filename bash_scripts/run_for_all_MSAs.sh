#!/usr/bin/env bash
#SBATCH --account=scc_mgmn_soeding
#SBATCH --partition=soeding
#SBATCH --cpus-per-task=2
#SBATCH -o /user/t.khosrojerdi/u20070/logs/%x-%j.out
#SBATCH -e /user/t.khosrojerdi/u20070/logs/%x-%j.err
#SBATCH --chdir=/user/t.khosrojerdi/u20070

set -Eeuo pipefail
set -x
shopt -s nullglob

# --- IQ-TREE binary (FIXED) ---
IQTREE=/user/t.khosrojerdi/u20070/iqtree-experiments/build/iqtree3
test -x "$IQTREE" || { echo "IQ-TREE not found at $IQTREE"; exit 127; }

# --- I/O paths ---
msa_dir="/user/t.khosrojerdi/u20070/iqtree-experiments/benchmark/alignments"
output_dir="/user/t.khosrojerdi/u20070/iqtree_results/short_branch_bias/len_pow_alpha/alpha_2"
mkdir -p "$output_dir"

# --- Input sanity check ---
mapfile -t MSAS < <(printf '%s\n' "$msa_dir"/*.fasta)
echo "Found ${#MSAS[@]} FASTA files in $msa_dir"
(( ${#MSAS[@]} > 0 )) || { echo "No *.fasta in $msa_dir"; exit 1; }

# --- Loop ---
for msa_file in "${MSAS[@]}"; do
  base_name=$(basename "$msa_file" .fasta)
  subdir="$output_dir/$base_name"
  mkdir -p "$subdir"
  output_prefix="$subdir/$base_name"

  # Use srun so SLURM tracks resources; set threads to cpus-per-task
  srun -c "${SLURM_CPUS_PER_TASK:-1}" "$IQTREE" \
      -s "$msa_file" -m LG+G4 -T "${SLURM_CPUS_PER_TASK:-1}" -pre "$output_prefix"

  echo "Finished $msa_file → $subdir"
done
-s 
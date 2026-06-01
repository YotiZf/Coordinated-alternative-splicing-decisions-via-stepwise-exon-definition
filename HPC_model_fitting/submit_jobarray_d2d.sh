#!/bin/bash

#SBATCH --array=1
#SBATCH --time 40:29:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=20
#SBATCH --output=./outputs/array_%A-%a.out
#SBATCH --error=./outputs/array_%A-%a.err
#SBATCH --mem=100G
#SBATCH --mail-type=all          # send email on job start, end and fault
#SBATCH --mail-user=panajot-kristofori@hotmail.com



module load math/matlab/R2024b
# Set up paths or other environment variables if needed

moo_value=2 #two step model
fit_value=1000

# Run MATLAB with arguments

matlab -nodisplay -r "Setup($moo_value, $fit_value); exit;"


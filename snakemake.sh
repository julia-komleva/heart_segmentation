#!/bin/bash

# Set execute permission on your script:
# chmod +x snakemake.sh
# To run your script, enter:
# ./snakemake.sh
snakemake --cores 4 -s snakefile_acdc
snakemake --cores 1 -s snakefile_emidec

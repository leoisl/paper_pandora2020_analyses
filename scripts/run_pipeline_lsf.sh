#!/usr/bin/env bash
set -eux

PROFILE="lsf"
LOG_DIR=logs/

snakemake --snakefile Snakefile_setup --restart-times 0 --profile "$PROFILE" "$@"
sleep 60 # avoid locked directory issues
snakemake --snakefile Snakefile_run   --restart-times 0 --profile "$PROFILE" --keep-going "$@"
exit 0

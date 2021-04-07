#!/usr/bin/env bash
set -eux

MEMORY=350000
LOCAL_CORES=95
LOG_DIR=logs/
JOB_NAME="pandora1_paper_full_pipeline"
SINGULARITY_PREFIX="/hps/nobackup/iqbal/leandro/singularity_cache"
profile="lsf"

mkdir -p "$LOG_DIR"

bsub -R "select[mem>$MEMORY] rusage[mem=$MEMORY] span[hosts=1]" \
    -n "$LOCAL_CORES" \
    -M "$MEMORY" \
    -e "$LOG_DIR"/"$JOB_NAME".e \
    -o "$LOG_DIR"/"$JOB_NAME".o \
    -J "$JOB_NAME" \
      scripts/run.sh "${SINGULARITY_PREFIX}" "${LOCAL_CORES}" "$profile" "$@"

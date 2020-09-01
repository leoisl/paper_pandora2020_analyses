#!/usr/bin/env bash
set -eux

MEMORY=20000
LOCAL_CORES=16
LOG_DIR=logs/
JOB_NAME="pandora1_paper_full_pipeline"

mkdir -p "$LOG_DIR"

bsub -R "select[mem>$MEMORY] rusage[mem=$MEMORY] span[hosts=1]" \
    -n "$LOCAL_CORES" \
    -M "$MEMORY" \
    -o "$LOG_DIR"/"$JOB_NAME".o \
    -e "$LOG_DIR"/"$JOB_NAME".e \
    -J "$JOB_NAME" \
      bash run.sh

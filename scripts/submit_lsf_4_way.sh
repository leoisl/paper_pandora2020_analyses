#!/usr/bin/env bash
set -eux

MEMORY=20000
LOCAL_CORES=20
LOG_DIR=logs_4_way/
JOB_NAME="pandora1_paper_full_pipeline_4_way"

mkdir -p "$LOG_DIR"

bsub -R "select[mem>$MEMORY] rusage[mem=$MEMORY] span[hosts=1]" \
    -n "$LOCAL_CORES" \
    -M "$MEMORY" \
    -eo "$LOG_DIR"/"$JOB_NAME".o \
    -J "$JOB_NAME" \
      scripts/run_4_way.sh "$@"

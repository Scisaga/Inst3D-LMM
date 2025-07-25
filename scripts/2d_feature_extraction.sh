#!/bin/bash
source "$(dirname "$0")/export_paths.sh"
export OMP_NUM_THREADS=3  # speeds up MinkowskiEngine

SCANS_PATH="$SCANS_PATH"
SCANNET_PROCESSED_DIR="$SCANNET_PROC"
# model ckpt paths
MASK_MODULE_CKPT_PATH="$CKPT_MASK3D"
SAM_CKPT_PATH="$CKPT_SAM"
# output directories to save 3D instances and their features
EXPERIMENT_NAME="scannet200"
OUTPUT_DIRECTORY="$OUTPUT_ROOT"
TIMESTAMP=$(date +"%Y-%m-%d-%H-%M-%S")
OUTPUT_FOLDER_DIRECTORY="${OUTPUT_DIRECTORY}/${TIMESTAMP}-${EXPERIMENT_NAME}"
MASK_SAVE_DIR="$MASKS_DIR"
MASK_FEATURE_SAVE_DIR="$FEATS2D_DIR"
SAVE_VISUALIZATIONS=false #if set to true, saves pyviz3d visualizations

# Paremeters below are AUTOMATICALLY set based on the parameters above:
SCANNET_LABEL_DB_PATH="${SCANNET_PROCESSED_DIR%/}/label_database.yaml"
SCANNET_INSTANCE_GT_DIR="${SCANNET_PROCESSED_DIR%/}/instance_gt/train"
# gpu optimization
OPTIMIZE_GPU_USAGE=true

set -e

# Extract multi-view 2D features using SAM and CLIP
python 2d_feature_extraction/get_2D_features.py \
data.scans_path=${SCANS_PATH} \
data.masks.masks_path=$MASKS_DIR \
output.output_directory=$MASK_FEATURE_SAVE_DIR \
output.experiment_name=${EXPERIMENT_NAME} \
external.sam_checkpoint=${SAM_CKPT_PATH} \
gpu.optimize_gpu_usage=${OPTIMIZE_GPU_USAGE} \
hydra.run.dir="${OUTPUT_FOLDER_DIRECTORY}/hydra_outputs/mask_features_computation"

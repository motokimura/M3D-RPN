#!/bin/bash

THIS_DIR=$(cd $(dirname $0); pwd)
PROJ_DIR=`dirname ${THIS_DIR}`

# NOTICE: Change `KITTI_DIR`, `WEIGHT_DIR`, and `OUT_DIR` bellow based on your settings
# NOTICE: The paths must be absolute ones!

# Directory containing the input KITTI object3d data
KITTI_DIR=${PROJ_DIR}/data/kitti

# Directory containing the pretrained weight and config (necessary to run testing)
WEIGHT_DIR=${PROJ_DIR}/M3D-RPN-Release

# Directory to which training/testing results will be saved
OUT_DIR=${PROJ_DIR}/output
mkdir -p -m 777 ${OUT_DIR}

nvidia-docker run --rm -it --ipc=host \
    -v ${KITTI_DIR}:/work/data/kitti \
    -v ${WEIGHT_DIR}:/work/M3D-RPN-Release \
    -v ${OUT_DIR}:/work/output \
    -p 8100:8100 \
    --name m3d_rpn \
    m3d_rpn /bin/bash

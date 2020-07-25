#!/bin/bash

THIS_DIR=$(cd $(dirname $0); pwd)
PROJ_DIR=`dirname ${THIS_DIR}`

OUT_DIR=${PROJ_DIR}/output
mkdir -p -m 777 ${OUT_DIR}

nvidia-docker run --rm -it \
    -v ${PROJ_DIR}/data/kitti:/work/data/kitti \
    -v ${PROJ_DIR}/models:/work/models \
    -v ${OUT_DIR}:/work/output \
    -v ${PROJ_DIR}/scripts:/work/scripts \
    -v ${PROJ_DIR}/weights:/work/weights \
    -p 8100:8100 \
    --name m3d_rpn \
    m3d_rpn /bin/bash

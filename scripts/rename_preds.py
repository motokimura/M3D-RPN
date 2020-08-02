# Usage:
# python scripts/rename_pred.py

import os
import shutil
import scipy.io as sio

from glob import glob

def rename_preds(src_dir, dst_dir, dst_idxs):
    dst_paths = [
        os.path.join(dst_dir, "{}.txt".format(idx)) for idx in dst_idxs
    ]

    os.makedirs(dst_dir, exist_ok=True)
    N = len(dst_paths)
    for i in range(N):
        src_path = os.path.join(src_dir, "{:06}.txt".format(i))
        dst_path = dst_paths[i]
        shutil.copy(src_path, dst_path)
    

# rename preds to split1 val
dst_dir = "output/m3d_rpn_depth_aware_val1/data_renamed"
src_dir = "output/m3d_rpn_depth_aware_val1/data"

with open("data/kitti_split1/val.txt") as f:
    tmp_idxs = f.readlines()
dst_idxs = [idx.rstrip("\n") for idx in tmp_idxs]

rename_preds(src_dir, dst_dir, dst_idxs)


# rename preds to split2 val
dst_dir = "output/m3d_rpn_depth_aware_val2/data_renamed"
src_dir = "output/m3d_rpn_depth_aware_val2/data"

tmp_idxs = sio.loadmat("data/kitti_split2/kitti_ids_new.mat")["ids_val"][0]
dst_idxs = ["{:06}".format(idx) for idx in tmp_idxs]

rename_preds(src_dir, dst_dir, dst_idxs)

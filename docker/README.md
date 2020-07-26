# Train & Test M3D-RPN with NVIDIA Docker

[Motoki Kimura](https://github.com/motokimura)

Tested with:

```
- OS: Ubuntu 18.04 LTS
- NVIDIA Driver: 450.51.05
- Docker: 19.03.12
- NVIDIA Docker 2: 2.4.0
```

May work with other versions.

## Setup

- **NVIDIA Driver**

    Find an appropriate version to your NVIDIA device from [here](https://www.nvidia.com/Download/index.aspx) and install it.

- **Docker & NVIDIA Docker 2**

    Install [Docker](https://docs.docker.com/engine/install/ubuntu/)
and [NVIDIA Docker 2](https://github.com/NVIDIA/nvidia-docker/wiki/Installation-(version-2.0)).

- **KITTI dataset**

    Download [KITTI 3D Object Detection](http://www.cvlibs.net/datasets/kitti/eval_object.php?obj_benchmark=3d) dataset and extract them.

    Default path is set to `M3D-RPN/data/kitti`.

- **M3D-RPN weights**

    Download a zip file by following [the original README](https://github.com/garrickbrazil/M3D-RPN#testing)
and extract it.

    Default path is set to `M3D-RPN/weights/M3D-RPN-Release`.

## Testing

Build docker image:

```
./docker/build.sh
```

Run container:

```
./docker/run.sh
```

Notice: if your KITTI data or pretrained weights are not located in the default paths described above,
you have to update `KITTI_DIR` and `WEIGHT_DIR` in `run.sh`.

Now you should be in the container, and can apply trainval spliting by:

```
(in container) python data/kitti_split1/setup_split.py
(in container) python data/kitti_split2/setup_split.py
```

Start testing:

```
# trainval split #1
(in container) python scripts/test_rpn_3d.py --config=weights/M3D-RPN-Release/m3d_rpn_depth_aware_val1_config.pkl --weight=weights/M3D-RPN-Release/m3d_rpn_depth_aware_val1

# trainval split #2
(in container) python scripts/test_rpn_3d.py --config=weights/M3D-RPN-Release/m3d_rpn_depth_aware_val2_config.pkl --weight=weights/M3D-RPN-Release/m3d_rpn_depth_aware_val2
```

After waiting for a while, you will see:

```
# trainval split #1
test_iter m3d_rpn_depth_aware_val1 2d car --> easy: 0.9024, mod: 0.8367, hard: 0.6769
test_iter m3d_rpn_depth_aware_val1 gr car --> easy: 0.2594, mod: 0.2118, hard: 0.1790
test_iter m3d_rpn_depth_aware_val1 3d car --> easy: 0.2027, mod: 0.1706, hard: 0.1521
test_iter m3d_rpn_depth_aware_val1 2d pedestrian --> easy: 0.6622, mod: 0.5838, hard: 0.5018
test_iter m3d_rpn_depth_aware_val1 gr pedestrian --> easy: 0.1305, mod: 0.1160, hard: 0.1115
test_iter m3d_rpn_depth_aware_val1 3d pedestrian --> easy: 0.1142, mod: 0.1128, hard: 0.1034
test_iter m3d_rpn_depth_aware_val1 2d cyclist --> easy: 0.6680, mod: 0.4901, hard: 0.4206
test_iter m3d_rpn_depth_aware_val1 gr cyclist --> easy: 0.1196, mod: 0.1013, hard: 0.1013
test_iter m3d_rpn_depth_aware_val1 3d cyclist --> easy: 0.1050, mod: 0.1001, hard: 0.0909
```

```
# trainval split #2
test_iter m3d_rpn_depth_aware_val2 2d car --> easy: 0.9362, mod: 0.8473, hard: 0.6765
test_iter m3d_rpn_depth_aware_val2 gr car --> easy: 0.2686, mod: 0.2115, hard: 0.1714
test_iter m3d_rpn_depth_aware_val2 3d car --> easy: 0.2040, mod: 0.1648, hard: 0.1334
test_iter m3d_rpn_depth_aware_val2 2d pedestrian --> easy: 0.7691, mod: 0.6016, hard: 0.5192
test_iter m3d_rpn_depth_aware_val2 gr pedestrian --> easy: 0.1340, mod: 0.1144, hard: 0.1151
test_iter m3d_rpn_depth_aware_val2 3d pedestrian --> easy: 0.1280, mod: 0.1130, hard: 0.1117
test_iter m3d_rpn_depth_aware_val2 2d cyclist --> easy: 0.5147, mod: 0.4277, hard: 0.3491
test_iter m3d_rpn_depth_aware_val2 gr cyclist --> easy: 0.0290, mod: 0.0909, hard: 0.0909
test_iter m3d_rpn_depth_aware_val2 3d cyclist --> easy: 0.0222, mod: 0.0909, hard: 0.0909
```

Detailed results are saved under `M3D-RPN/data/output` 
(defined as `OUT_DIR` in `run.sh`).

You can test your own model by setting paths to the config and weight files
with `--weight` and `--config` options in the same way.

## Training

Build docker image:

```
./docker/build.sh
```

Run container:

```
./docker/run.sh
```

Notice: if your KITTI data or pretrained weights are not located in the default paths described above,
you have to update `KITTI_DIR` and `WEIGHT_DIR` defined in `run.sh`.

Now you should be in the container, and can apply trainval spliting by:

```
(in container) python data/kitti_split1/setup_split.py
(in container) python data/kitti_split2/setup_split.py
```

Before training, launch visdom server:

```
(in container) python -m visdom.server -port 8100 -readonly
```

Launch **a new terminal**.
Then, start a new bash session in the container:

```
./docker/exec.sh
```

Start training:

```
# First train the warmup (without depth-aware)
(in container) python scripts/train_rpn_3d.py --config=kitti_3d_multi_warmup

# Then train the main experiment (with depth-aware)
(in container) python scripts/train_rpn_3d.py --config=kitti_3d_multi_main
```

The training status can be monitored at [http://localhost:8100](http://localhost:8100).

The training config, trained weights, etc. are saved under `M3D-RPN/data/output` 
(defined as `OUT_DIR` in `run.sh`).

You can configure hyper parameters (e.g., trainval split) by changing
`M3D-RPN/scripts/config/kitti_3d_multi_warmup.py` and `M3D-RPN/scripts/config/kitti_3d_multi_main.py`.

Notice: if you changed the files, you have to re-build and re-launch the container
to reflect the changes.

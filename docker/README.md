# M3D-RPN training and testing with nvidia-docker

[Motoki Kimura](https://github.com/motokimura)

Tested with:

```
- OS: Ubuntu 18.04 LTS
- NVIDIA Driver: 450.51.05
- Docker: 19.03.12
- NVIDIA Docker 2: 2.4.0
```

## Setup

- **NVIDIA Driver**

    Find an appropriate version from [here](https://www.nvidia.com/Download/index.aspx) and install it.

- **Docker & NVIDIA Docker 2**

    Install [Docker](https://docs.docker.com/engine/install/ubuntu/)
and [NVIDIA Docker 2](https://github.com/NVIDIA/nvidia-docker/wiki/Installation-(version-2.0)).

- **KITTI**

    Download [KITTI 3D Object Detection](http://www.cvlibs.net/datasets/kitti/eval_object.php?obj_benchmark=3d) dataset and extract them.

    Default path is set to `M3D-RPN/data/kitti`.

- **Pretrained weights**

    Download a zip file by following [the original README](https://github.com/garrickbrazil/M3D-RPN#testing)
and extract it.

    Default path is set to `M3D-RPN/data/M3D-RPN-Release`.

## Testing

Build docker image:

```
./docker/build.sh
```

Run container:

```
./docker/run.sh
```

Notice: if your KITTI data or pretrained weights are not located in the default paths written above,
you need to update `KITTI_DIR` and `WEIGHT_DIR` defined in `run.sh`.

Now you should be in the container, and can apply trainval spliting by:

```
(in container) python data/kitti_split1/setup_split.py
(in container) python data/kitti_split2/setup_split.py
```

Start testing:

```
(in container) python scripts/test_rpn_3d.py
```

Results will be saved under `M3D-RPN/data/output` 
(defined by `OUT_DIR` in `run.sh`).

## Training

Build docker image:

```
./docker/build.sh
```

Run container:

```
./docker/run.sh
```

Notice: if your KITTI data or pretrained weights are not located in the default paths written above,
you need to update `KITTI_DIR` and `WEIGHT_DIR` defined in `run.sh`.

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

Results will be saved under `M3D-RPN/data/output` 
(defined by `OUT_DIR` in `run.sh`).

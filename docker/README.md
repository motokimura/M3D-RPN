# M3D-RPN training and testing with nvidia-docker

[Motoki Kimura](https://github.com/motokimura)

Tested with:

```
- Ubuntu 18.04 LTS
- nvidia-driver==450.51.05
- docker==19.03.12
- nvidia-driver==2.4.0
```

## Setup

### nvidia-driver

Install nvidia-driver appropriate to your NVIDIA GPU.

### docker/nvidia-docker2

Install [docker](https://docs.docker.com/engine/install/ubuntu/)
and [nvidia-docker2](https://github.com/NVIDIA/nvidia-docker/wiki/Installation-(version-2.0)).

### KITTI

Download the full [KITTI](http://www.cvlibs.net/datasets/kitti/eval_object.php?obj_benchmark=3d) detection dataset and extract them.

Default path is set to `M3D-RPN/data/kitti`.

### Pretrained weights

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

NOTICE: if your KITTI data or pretrained weights are not located in the default paths written above,
you need to update `KITTI_DIR` and `WEIGHT_DIR` defined in `run.sh`.

Now you should be in the container, and can apply trainval spliting by:

```
(in container) python data/kitti_split1/setup_split.py
(in container) python data/kitti_split2/setup_split.py
```

Finally you can start testing:

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

NOTICE: if your KITTI data or pretrained weights are not located in the default paths written above,
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

Launch **a new terminal (session)** and run a new process in the container:

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

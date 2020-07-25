FROM nvidia/cuda:9.2-cudnn7-devel-ubuntu16.04

RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

# Install some basic utilities
RUN apt-get update && apt-get install -y \
    build-essential \
    bzip2 \
    ca-certificates \
    git \
    curl \
    libboost-dev \
    libgl1-mesa-dev \
    libsm6 \
    libx11-6 \
    libxext-dev \
    libxrender1 \
    sudo \
 && rm -rf /var/lib/apt/lists/*

# Create a working directory
RUN mkdir /work
WORKDIR /work

# Install Miniconda and Python 3.6
ENV CONDA_AUTO_UPDATE_CONDA=false
ENV PATH=/root/miniconda/bin:$PATH
RUN curl -sLo ~/miniconda.sh https://repo.continuum.io/archive/Anaconda3-5.2.0-Linux-x86_64.sh \
 && chmod +x ~/miniconda.sh \
 && ~/miniconda.sh -b -p ~/miniconda \
 && rm ~/miniconda.sh \
 && conda install -y python==3.6.8 \
 && conda clean -ya

# CUDA 9.2-specific steps
RUN conda install -y -c pytorch \
    cuda92 \
    "pytorch=0.4.1=py36_cuda9.2.148_cudnn7.1.4_1" \
    "torchvision=0.2.1=py36_1" \
 && conda clean -ya

# Install Python modules
COPY docker/requirements.txt /tmp/requirements.txt
RUN pip install -r /tmp/requirements.txt

# Build NMS
COPY lib /work/lib
RUN cd /work/lib/nms && make

# Build KITTI devkit for kitti_split1
# TODO: check if this is necessary or not
RUN mkdir -p /work/data/kitti_split1
COPY data/kitti_split1/devkit /work/data/kitti_split1/devkit
COPY data/kitti_split1/setup_split.py /work/data/kitti_split1/setup_split.py
COPY data/kitti_split1/test.txt /work/data/kitti_split1/test.txt
COPY data/kitti_split1/train.txt /work/data/kitti_split1/train.txt
COPY data/kitti_split1/trainval.txt /work/data/kitti_split1/trainval.txt
COPY data/kitti_split1/val.txt /work/data/kitti_split1/val.txt
RUN cd /work && sh data/kitti_split1/devkit/cpp/build.sh

# Build KITTI devkit for kitti_split_2
# TODO: check if this is necessary or not
RUN mkdir -p /work/data/kitti_split2
COPY data/kitti_split2/devkit /work/data/kitti_split2/devkit
COPY data/kitti_split2/kitti_ids_new.mat /work/data/kitti_split2/kitti_ids_new.mat
COPY data/kitti_split2/setup_split.py /work/data/kitti_split2/setup_split.py
RUN cd /work && sh data/kitti_split2/devkit/cpp/build.sh

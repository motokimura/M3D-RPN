FROM nvidia/cuda:9.2-cudnn7-devel-ubuntu16.04

RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

# Install some basic utilities
RUN apt-get update && apt-get install -y \
    build-essential \
    bzip2 \
    ca-certificates \
    git \
    curl \
    libx11-6 \
    sudo \
 && rm -rf /var/lib/apt/lists/*

# Create a working directory
RUN mkdir /work
WORKDIR /work

# Create a non-root user and switch to it
RUN adduser --disabled-password --gecos '' --shell /bin/bash user \
 && chown -R user:user /work
RUN echo "user ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/90-user
USER user

# All users can use /home/user as their home directory
ENV HOME=/home/user
RUN chmod 777 /home/user

# Install Miniconda and Python 3.6
ENV CONDA_AUTO_UPDATE_CONDA=false
ENV PATH=/home/user/miniconda/bin:$PATH
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

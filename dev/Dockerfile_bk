# Summary: 3D reconstruction pipeline using Colmap based on CUP or GPU on HPC(Puma)
# Author: Suxing Liu
# Create date: 02202025


FROM nvidia/cuda:12.2.2-devel-ubuntu22.04

# setup Colmap version and CUDA version for ubuntu22.04
ARG COLMAP_VERSION=3.9
ARG CUDA_ARCHITECTURES=70
ENV QT_XCB_GL_INTEGRATION=xcb_egl

# Prevent stop building ubuntu at time zone selection.  
ENV DEBIAN_FRONTEND=noninteractive

# Prepare and empty machine for building
RUN apt-get update && apt-get install -y \
    git \
    cmake \
    ninja-build \
    build-essential \
    libboost-program-options-dev \
    libboost-filesystem-dev \
    libboost-graph-dev \
    libboost-system-dev \
    libeigen3-dev \
    libflann-dev \
    libfreeimage-dev \
    libmetis-dev \
    libgoogle-glog-dev \
    libgtest-dev \
    libsqlite3-dev \
    libglew-dev \
    qtbase5-dev \
    libqt5opengl5-dev \
    libcgal-dev \
    libceres-dev \
    libcurl4-openssl-dev



# Build and install COLMAP
RUN git clone https://github.com/colmap/colmap.git
RUN cd colmap && \
    git checkout tags/${COLMAP_VERSION} -b ${COLMAP_VERSION}-branch && \
    mkdir build && \
    cd build && \
    cmake .. -GNinja -DCMAKE_CUDA_ARCHITECTURES=${CUDA_ARCHITECTURES} && \
    ninja && \
    ninja install && \
    cd .. && rm -rf colmap

      
        
# Copy all files into the docker container
COPY . /opt/code
WORKDIR /opt/code

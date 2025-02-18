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

#
# Docker runtime stage.
#
FROM nvidia/cuda:12.2.2-devel-ubuntu22.04 as runtime

# Minimal dependencies to run COLMAP binary compiled in the builder stage.
# Note: this reduces the size of the final image considerably, since all the
# build dependencies are not needed.
RUN apt-get update && \
    apt-get install -y --no-install-recommends --no-install-suggests \
        libboost-program-options1.74.0 \
        libc6 \
        libceres2 \
        libfreeimage3 \
        libgcc-s1 \
        libgl1 \
        libglew2.2 \
        libgoogle-glog0v5 \
        libqt5core5a \
        libqt5gui5 \
        libqt5widgets5 \
        libcurl4
        
        
# Copy all files into the docker container
COPY . /opt/code
WORKDIR /opt/code

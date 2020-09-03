#!/bin/sh
sudo apt-get update
sudo apt-get install -y \
    cmake \
    g++ \
    git \
    google-mock \
    libboost-all-dev \
    libcairo2-dev \
    libeigen3-dev \
    libgflags-dev \
    libgoogle-glog-dev \
    liblua5.2-dev \
    libprotobuf-dev \
    libsuitesparse-dev \
    libwebp-dev \
    ninja-build \
    protobuf-compiler \
    python-sphinx

cd dependencies

cd abseil-cpp
mkdir build
cd build
cmake ..
make -j2
sudo make install

cd ../../ceres-solver/
mkdir build
cd build
cmake ..
make -j2
sudo make install

cd ../../protobuf
./autogen.sh
./configure
make -j2
sudo make install
sudo ldconfig

cd ../../
mkdir build
cd build
cmake ..
make -j2
sudo make install

#在ARM64板子上会不存在/usr/lib/aarch64-linux-gnu/libGL.so，导致后续的cartographer_rviz编译失败，链接生成，请取消注释
#sudo ln -s /usr/lib/aarch64-linux-gnu/libGL.so.1 /usr/lib/aarch64-linux-gnu/libGL.so

cd ../
mkdir -p ~/carto_ws/src/
cp -r cartographer_ros/ ~/carto_ws/src/
cd ~/carto_ws/
catkin_make -j2

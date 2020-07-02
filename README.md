# ubuntu18.04安装cartographer以及cartographer_ros

## 前言

cartographer一直在维护，从之前的tf1到现在melodic版本上的tf2_ros都有更新支持。

而且cartographer所依赖的库也在一直更新，包括abseil-cpp，ceres-solver，protobuf等，其依赖的版本混乱，并不能相互兼容。

经过测试，在2019年的某个版本解决好依赖问题之后，同样的方法在2020年clone新的官方代码就编译出错了。

并且，貌似官方只更新代码，并没有对安装文档进行对应的更新，所以直接按照cartographer/scripts中的安装脚本操作，而又使用最新代码，是必然会出错的。

为了解决此问题，本仓库固化依赖以及cartographer的版本，经过多次测试，该方法有效。

版本固化时间为2020年07月01日16:58:57。

> 该仓库的carto以及carto_ros代码均为当前官方github最新代码，依赖调教好版本的依赖包也都已经放在dependencies文件夹，所有代码均使用cmake编译方式，无官方推荐的ninjia（对持续源码修改以及开发不方便），该仓库的方法不保证对后续谷歌更新的carto以及carto_ros有效，请使用本仓库下的代码版本。建议将仓库克隆到catkin_ws/下与src平级目录，后续修改源码或者查看代码实现可直接跳转。

## 安装基础依赖

```bash
# Install the required libraries that are available as debs.
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
    python-sphinx \
```

## 安装abseil-cpp

版本：[lts_2020_02_25](https://github.com/abseil/abseil-cpp/tree/lts_2020_02_25)

```
# Install abseil-cpp
cd  ~/Downloads
git clone https://github.com/abseil/abseil-cpp.git
cd abseil-cpp
git checkout lts_2020_02_25
mkdir build
cd build
cmake ..
make -j2
sudo make install
```



## 安装ceres solver

版本：[1.13.0](https://github.com/ceres-solver/ceres-solver/tree/1.13.0)

```bash
# Install ceres solver
cd  ~/Downloads
git clone https://github.com/ceres-solver/ceres-solver.git
cd ceres-solver
git checkout 1.13.0
mkdir build
cd build
cmake ..
make -j2
sudo make install
```



## 安装protobuf

版本：[master@d4c5992352aae1ed18f44c1a40d2149006bf8704](https://github.com/protocolbuffers/protobuf)

```bash
# Install prtobuf 3.0
cd  ~/Downloads
git clone https://github.com/protocolbuffers/protobuf.git
cd protobuf
git checkout d4c5992352aae1ed18f44c1a40d2149006bf8704
mkdir build
cd build
cmake ..
make -j2
sudo make install
sudo ldconfig
```

> 此处注意如果安装完没有执行sudo ldconfig指令时会报错找不到shared libraries protobuf.so.23。

## 安装cartographer

版本：[master@e5894cce1f8047d5c807158711e468b3f5550f1a](https://github.com/cartographer-project/cartographer)

```bash
# Install cartographer

cd  ~/Downloads
git clone https://github.com/cartographer-project/cartographer.git
git checkout e5894cce1f8047d5c807158711e468b3f5550f1a
cd cartographer
mkdir build
cd build
cmake ..
make -j2
sudo make install
```



> 在rk3399下会不存在/usr/lib/aarch64-linux-gnu/libGL.so，导致后续的cartographer_rviz编译失败，链接生成。

```
sudo ln -s /usr/lib/aarch64-linux-gnu/libGL.so.1 /usr/lib/aarch64-linux-gnu/libGL.so
```



## 安装cartographer_ros与编译

版本：[master@be4332b3385b5eea2511d11de5cc6792ecb4af2e](https://github.com/cartographer-project/cartographer_ros)

```bash
# Install cartographer ros
mkdir -p ~/catkin_ws/src
cd ~/catkin_ws/src
git clone https://github.com/cartographer-project/cartographer_ros.git
git checkout be4332b3385b5eea2511d11de5cc6792ecb4af2e
cd ~/catkin_ws
catkin_make -j2
```

> 此处进行编译时请使用catkin_make -j2，如果直接使用catkin_make则会全线程启动编译，会导致内存不足，从而报错编译器内部错误。



## 安装脚本

```
./install.sh
```



## 数据集

[谷歌官方文档页面](https://google-cartographer-ros.readthedocs.io/en/latest/demos.html)给出的数据集已经下载到北京办公区的本地服务器上，10个bag文件，地址为：http://192.168.9.18/data/carto_bags/

或者直接使用本仓库的下载脚本get_carto_bags.sh将所有bag文件下载到本地~/data/carto_bags/中。

```bash
./get_carto_bags.sh
```



## 参考链接

1. [蓝鲸机器人论坛](http://community.bwbot.org/topic/620/cartographer-install-and-demo)
2. [cartograher官方文档](https://google-cartographer.readthedocs.io/en/latest/)
3. [cartographer_ros官方文档](https://google-cartographer-ros.readthedocs.io/en/latest/)
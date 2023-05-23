#!/bin/bash
#
# For Ubuntu 22.04 with CUDA 11.8 & cuDNN 8.8.0121
#
export PATH=$PATH:/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin

# disable sudo timeouts
sudo sed -i 's/env_reset/env_reset,timestamp_timeout=-1/1' /etc/sudoers

# Update package list & upgrade installed package
sudo apt update && sudo apt upgrade -y

# make sure you have all required for compilation
sudo apt install build-essential -y

# Check Nvidia Driver & CUDA Driver
#nvidia-smi

# Install CUDA Toolkit
#wget http://developer.download.nvidia.com/compute/cuda/11.0.2/local_installers/cuda_11.0.2_450.51.05_linux.run
#wget https://developer.download.nvidia.com/compute/cuda/11.0.3/local_installers/cuda_11.0.3_450.51.06_linux.run
wget https://developer.download.nvidia.com/compute/cuda/11.8.0/local_installers/cuda_11.8.0_520.61.05_linux.run

#sudo sh cuda_11.0.2_450.51.05_linux.run
#sudo sh cuda_11.0.3_450.51.06_linux.run --silent --toolkit --samples
sudo sh cuda_11.8.0_520.61.05_linux.run --silent --toolkit --samples 

## add path
#export PATH=$PATH:/usr/local/cuda-11.0/bin
export PATH=$PATH:/usr/local/cuda/bin

# Install Cudnn
## get package
#wget http://erickt2.thu.edu.tw/libcudnn8_8.0.5.39-1+cuda11.0_amd64.deb
#wget http://erickt2.thu.edu.tw/libcudnn8-dev_8.0.5.39-1+cuda11.0_amd64.deb
#wget http://erickt2.thu.edu.tw/libcudnn8-samples_8.0.5.39-1+cuda11.0_amd64.deb
#wget http://erickt2.thu.edu.tw/libcudnn8_8.1.1.33-1+cuda11.2_amd64.deb
#wget http://erickt2.thu.edu.tw/libcudnn8-dev_8.1.1.33-1+cuda11.2_amd64.deb
#wget http://erickt2.thu.edu.tw/libcudnn8-samples_8.1.1.33-1+cuda11.2_amd64.deb
wget http://erickt2.thu.edu.tw/u22/cudnn-local-repo-ubuntu2204-8.8.0.121_1.0-1_amd64.deb

#sudo dpkg -i libcudnn8*
sudo dpkg -i cudnn-local-repo-ubuntu2204-8.8.0.121_1.0-1_amd64.deb
sudo cp /var/cudnn-local-repo-*/cudnn-local-*-keyring.gpg /usr/share/keyrings/
sudo apt-get update
sudo apt-get install libcudnn8=8.8.0.121-1+cuda11.8
sudo apt-get install libcudnn8-dev=8.8.0.121-1+cuda11.8
sudo apt-get install libcudnn8-samples=8.8.0.121-1+cuda11.8

## Testing cudnn Installation
sudo apt-get install libfreeimage3 libfreeimage-dev -y
cp -r /usr/src/cudnn_samples_v8/ $HOME
cd  $HOME/cudnn_samples_v8/mnistCUDNN
make clean && make

## You should see "Test passed!"
./mnistCUDNN

# Install OPENCV
## Install the required packages for OpenCV
sudo apt install cmake python3-dev python3-numpy libavcodec-dev libavformat-dev libswscale-dev libgstreamer-plugins-base1.0-dev libgstreamer1.0-dev libgtk-3-dev libjpeg-dev libpng-dev libtiff-dev libtbb-dev libatlas-base-dev gfortran -y

## Optional Package
### Recommended Image(PNG, JPEG, Tiff, etc.) 
sudo apt install libpng-dev libjpeg-dev libopenexr-dev libtiff-dev libwebp-dev libprotobuf-dev protobuf-compiler libgoogle-glog-dev libgflags-dev libgphoto2-dev libeigen3-dev libhdf5-dev doxygen -y

### Optional Video(FFMPEG, GSTREAMER, x264, etc.)
#sudo apt install libavcodec-dev libavformat-dev libswscale-dev libavresample-dev libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev libxvidcore-dev x264 libx264-dev libfaac-dev libmp3lame-dev libtheora-dev libfaac-dev libmp3lame-dev libvorbis-dev -y
sudo apt install libavcodec-dev libavformat-dev libswscale-dev libswresample-dev libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev libxvidcore-dev x264 libx264-dev libfaac-dev libmp3lame-dev libtheora-dev libfaac-dev libmp3lame-dev libvorbis-dev -y

### Optional OpenCore
sudo apt install libopencore-amrnb-dev libopencore-amrwb-dev -y
### Optional Cameras programming interface
#sudo apt-get install libdc1394-22 libdc1394-22-dev libxine2-dev libv4l-dev v4l-utils -y
sudo apt-get install libdc1394-dev libxine2-dev libv4l-dev v4l-utils -y

cd /usr/include/linux
sudo ln -s -f ../libv4l1-videodev.h videodev.h


## Install Git
sudo apt install git -y

## Install opencv &  opencv_contrib
cd ~
git clone https://github.com/opencv/opencv.git
git clone https://github.com/opencv/opencv_contrib.git
cd opencv
mkdir build
cd build
cmake -D CMAKE_BUILD_TYPE=RELEASE -D CMAKE_INSTALL_PREFIX=/usr/local -D WITH_TBB=ON -D ENABLE_FAST_MATH=1 -D CUDA_FAST_MATH=1 -D WITH_CUBLAS=1 -D WITH_CUDA=ON -D BUILD_opencv_cudacodec=OFF -D WITH_CUDNN=ON -D OPENCV_DNN_CUDA=ON -D CUDA_ARCH_BIN=7.5 -D WITH_V4L=ON -D WITH_QT=OFF -D WITH_OPENGL=ON -D WITH_GSTREAMER=ON -D OPENCV_GENERATE_PKGCONFIG=YES -D OPENCV_PC_FILE_NAME=opencv.pc -D OPENCV_ENABLE_NONFREE=ON -D PYTHON_EXECUTABLE=~/.virtualenvs/cv/bin/python -D OPENCV_EXTRA_MODULES_PATH=~/opencv_contrib/modules -D INSTALL_PYTHON_EXAMPLES=OFF -D INSTALL_C_EXAMPLES=OFF -D BUILD_EXAMPLES=OFF .. 2>&1 | tee opencv_cmake.log
# make -j[n] (n=cpu cores*2)
make -j12 2>&1 | tee opencv_make.log
sudo make install

## LD Config
sudo /bin/bash -c 'echo "/usr/local/lib" > /etc/ld.so.conf.d/opencv.conf'
sudo ldconfig
#export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:/usr/local/lib/pkgconfig

#pkg-config --cflags /usr/local/lib/pkgconfig/opencv.pc
#pkg-config --libs /usr/local/lib/pkgconfig/opencv.pc

# Install YOLO (You Only Look Once) darknet
cd ~
mkdir yolov4

#git clone https://github.com/AlexeyAB/darknet
git -C yolov4 clone https://github.com/AlexeyAB/darknet

#cd darknet/
cd yolov4/darknet
sed -i 's/GPU=0/GPU=1/g' Makefile
sed -i 's/CUDNN=0/CUDNN=1/g' Makefile
## to build for Tensor Cores (on Titan V / Tesla V100 / DGX-2 and later) speedup Detection 3x, Training 2x
## RTX 8k have Tensor cores
sed -i 's/CUDNN_HALF=0/CUDNN_HALF=1/g' Makefile
sed -i 's/OPENCV=0/OPENCV=1/g' Makefile
# make -j[n] (n=cpu cores*2)
make -j12


# reset sudo timeout to 15 mins
sudo sed -i 's/timestamp_timeout=-1/timestamp_timeout=15/1' /etc/sudoers

## Test darknet
#wget https://github.com/AlexeyAB/darknet/releases/download/darknet_yolo_v3_optimal/yolov4.weights
wget https://github.com/AlexeyAB/darknet/releases/download/yolov4/yolov4.weights
./darknet detector test cfg/coco.data cfg/yolov4.cfg yolov4.weights data/dog.jpg

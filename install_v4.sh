echo rr9874563210 | sudo -S apt install build-essential
sudo apt upgrade -y
sudo apt install build-essential
sudo apt install nvdia-driver-515
nvidia-smi
wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/cuda-ubuntu2204.pin
sudo mv cuda-ubuntu2204.pin /etc/apt/preferences.d/cuda-repository-pin-600
wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/cuda-ubuntu2204.pin
sudo mv cuda-ubuntu2204.pin /etc/apt/preferences.d/cuda-repository-pin-600
wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/cuda-ubuntu2204.pin
sudo mv cuda-ubuntu2204.pin /etc/apt/preferences.d/cuda-repository-pin-600
sudo apt-get update
sudo apt install cuda
wget http://140.128.101.170/FTP/cudnn-linux-x86_64-8.4.1.50_cuda11.6-archive.tar.xz
tar -xvf cudnn-linux-x86_64-8.4.1.50_cuda11.6-archive.tar.xz
sudo cp cudnn/include/cudnn*.h /usr/local/cuda-11.7/include
sudo cp -P cudnn/lib/libcudnn* /usr/local/cuda-11.7/lib64
sudo chmod a+r /usr/local/cuda-11.7/include/cudnn*.h /usr/local/cuda-11.7/lib64/libcudnn*
sudo bash -c 'echo export PATH="/usr/local/cuda-11.7/bin:$PATH" >>/etc/profile
nvcc --version
sudo apt install cmake python3-dev python3-numpy libavcodec-dev libavformat-dev libswscale-dev libgstreamer-plugins-base1.0-dev libgstreamer1.0-dev libgtk-3-dev libjpeg-dev libpng-dev libtiff-dev libtbb-dev libatlas-base-dev gfortran
sudo apt install libpng-dev libjpeg-dev libopenexr-dev libtiff-dev libwebp-dev libprotobuf-dev protobuf-compiler libgoogle-glog-dev libgflags-dev libgphoto2-dev libeigen3-dev libhdf5-dev doxygen
sudo apt install libavcodec-dev libavformat-dev libswscale-dev libavresample-dev libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev libxvidcore-dev x264 libx264-dev libfaac-dev libmp3lame-dev libtheora-dev libfaac-dev libmp3lame-dev libvorbis-dev
sudo apt install libopencore-amrnb-dev libopencore-amrwb-dev
sudo apt-get install libdc1394-22 libdc1394-22-dev libxine2-dev libv4l-dev v4l-utils
cd /usr/include/linux
sudo ln -s -f ../libv4l1-videodev.h videodev.h
cd ~
git clone https://github.com/opencv/opencv.git
git clone https://github.com/opencv/opencv_contrib.git
cd opencv
mkdir build
cd build
make -j4
sudo make install
sudo /bin/bash -c 'echo "/usr/local/lib" > /etc/ld.so.conf.d/opencv.conf'
sudo ldconfig
cd ~
git clone https://github.com/AlexeyAB/darknet
cd darknet/
sed -i 's/GPU=0/GPU=1/g' Makefile
sed -i 's/CUDNN=0/CUDNN=1/g' Makefile
sed -i 's/OPENCV=0/OPENCV=1/g' Makefile
make
wget https://github.com/AlexeyAB/darknet/releases/download/darknet_yolo_v3_optimal/yolov4.weights
./darknet detector test cfg/coco.data cfg/yolov4.cfg yolov4.weights data/dog.jpg


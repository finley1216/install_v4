#!/bin/bash
# For Ubuntu 22.04 with CUDA 11.8 & cuDNN 8.8.0121
export PATH=$PATH:/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin

### Install YOLOv7 (auto version)
cd ~
git clone https://github.com/WongKinYiu/yolov7
cd yolov7

## Delete torch & torchvision (line11&12)
#sudo gedit requirements.txt
# Delete requirements.txt
rm requirements.txt
# Download new requirements.txt
wget http://ctyang.thu.edu.tw/requirements.txt

#install pip
sudo apt-get install python3-pip -y

# Install yolov7 requirements.txt
pip3 install -r requirements.txt
# Install torch & torchvision(must be match cuda)
pip3 install torch==1.13.1 torchvision==0.14.1

# Download model
wget https://github.com/WongKinYiu/yolov7/releases/download/v0.1/yolov7-e6e.pt
# Test horses.jpg
python3 detect.py --weights yolov7-e6e.pt --conf 0.25 --img-size 640 --source inference/images/horses.jpg
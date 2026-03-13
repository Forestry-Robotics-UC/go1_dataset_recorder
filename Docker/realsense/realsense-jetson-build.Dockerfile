ARG ARCH=linux/arm64/v8
FROM ros:jazzy-ros-base

LABEL maintainer="Duarte Cruz <duarte.cruz@isr.uc.pt>"

SHELL ["/bin/bash","-c"]

ENV DEBIAN_FRONTEND=noninteractive

#Install ROS Packages
RUN apt-get update && \
    apt-get install -y \
    build-essential \
    git \
    cmake \
    wget \
    libx11-dev \
    libxrandr-dev \
    libxinerama-dev \
    libxcursor-dev \
    libgl1-mesa-dev \
    libglu1-mesa-dev \
    libglfw3-dev \
    libusb-1.0-0-dev \
    ros-$ROS_DISTRO-cv-bridge \
    ros-$ROS_DISTRO-image-transport \
    ros-$ROS_DISTRO-diagnostic-updater \
    ros-$ROS_DISTRO-sensor-msgs \
    ros-$ROS_DISTRO-std-srvs \
    ros-$ROS_DISTRO-rmw-cyclonedds-cpp
    
#Configure catkin workspace
ENV CATKIN_WS=/root/ros2_ws
RUN mkdir -p $CATKIN_WS/src

# Clone and build librealsense with DKMS
WORKDIR /tmp/
RUN git clone https://github.com/IntelRealSense/librealsense.git --branch v2.56.4 --single-branch

WORKDIR /tmp/librealsense/build
RUN mkdir -p /tmp/librealsense/build
RUN cmake .. -DFORCE_RSUSB_BACKEND=true -DCMAKE_BUILD_TYPE=Release && \
    make -j$(nproc) && \
    make install && \
    ldconfig

#Clone realsense pkg
WORKDIR $CATKIN_WS/src
RUN git clone -b r/4.56.4 https://github.com/IntelRealSense/realsense-ros.git

RUN echo "source /opt/ros/jazzy/setup.bash" >> ~/.bashrc
RUN echo "source /root/ros2_ws/install/setup.bash" >> ~/.bashrc

# Clean-up
WORKDIR /root
RUN apt-get clean

CMD ["bash"]


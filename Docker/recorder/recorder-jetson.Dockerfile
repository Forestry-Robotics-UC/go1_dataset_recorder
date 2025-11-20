ARG ARCH=linux/arm64/v8
FROM ros:kilted-ros-base

LABEL maintainer="Duarte Cruz <duarte.cruz@isr.uc.pt>"

SHELL ["/bin/bash","-c"]

ENV DEBIAN_FRONTEND=noninteractive

# Install packages
RUN apt-get update \
    && apt-get install -y \
    build-essential \
    apt-utils \
    git \
    software-properties-common \
    cmake \
    libboost-all-dev \
    libncurses-dev

#Install ros2 pkg
RUN apt -y install ros-kilted-rmw-cyclonedds-cpp \
    ros-kilted-rosbag2-storage-mcap \
    ros-kilted-cv-bridge \
    ros-kilted-image-transport \
    ros-kilted-diagnostic-updater

#Configure catkin workspace
ENV CATKIN_WS=/root/ros2_ws
RUN mkdir -p $CATKIN_WS/src

WORKDIR $CATKIN_WS/src

RUN git clone https://github.com/RoboSense-LiDAR/rslidar_msg.git

RUN git clone --recursive https://github.com/snt-arg/unitree_ros.git

RUN git clone https://github.com/tu-darmstadt-ros-pkg/hector_recorder.git

RUN git clone --filter=blob:none --no-checkout https://github.com/IntelRealSense/realsense-ros.git
WORKDIR $CATKIN_WS/src/realsense-ros
RUN git sparse-checkout init --cone
RUN git sparse-checkout set realsense2_camera_msgs

RUN echo "source /opt/ros/humble/setup.bash" >> ~/.bashrc
RUN echo "source /root/ros2_ws/install/setup.bash" >> ~/.bashrc

# Clean-up
WORKDIR /root
RUN apt-get clean

CMD ["bash"]

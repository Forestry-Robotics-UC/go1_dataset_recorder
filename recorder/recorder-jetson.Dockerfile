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

# Clean-up
WORKDIR /root
RUN apt-get clean

CMD ["bash"]

ARG ARCH=linux/arm64/v8
FROM ros:humble-ros-base

LABEL maintainer="Duarte Cruz <duarte.cruz@isr.uc.pt>"

SHELL ["/bin/bash","-c"]

ENV DEBIAN_FRONTEND=noninteractive

# Install packages
RUN apt-get update \
    && apt-get install build-essential -y \
    apt-utils \
    git \
    software-properties-common \
    cmake \
    udev \
    zstd \
    libyaml-cpp-dev \
    libpcap-dev

# Install some python packages
RUN apt-get -y install python3-pip

#Install ros2 pkg
RUN apt -y install ros-humble-rmw-cyclonedds-cpp

#Configure catkin workspace
ENV CATKIN_WS=/root/ros2_ws
RUN mkdir -p $CATKIN_WS/src

# Clean-up
WORKDIR /root
RUN apt-get clean

CMD ["bash"]

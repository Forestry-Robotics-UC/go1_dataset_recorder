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
    zstd

# Install some python packages
RUN apt-get -y install python3-pip \
    python3-serial

#Install ROS Packages
RUN apt-get install -y ros-dev-tools \
    ros-humble-tf-transformations \
    ros-humble-imu-tools \
    ros-humble-rmw-cyclonedds-cpp

#Configure catkin workspace
ENV CATKIN_WS=/root/ros2_ws
RUN mkdir -p $CATKIN_WS/src

#Clone xsens pkg
WORKDIR $CATKIN_WS/src
RUN git clone https://github.com/norlab-ulaval/norlab_xsens_driver.git

RUN echo "source /opt/ros/humble/setup.bash" >> ~/.bashrc
RUN echo "source /root/ros2_ws/install/setup.bash" >> ~/.bashrc

# Clean-up
WORKDIR /root
RUN apt-get clean

CMD ["bash"]

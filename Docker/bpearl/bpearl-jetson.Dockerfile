ARG ARCH=linux/arm64/v8
FROM ros:jazzy-ros-base

LABEL maintainer="Duarte Cruz <duarte.cruz@isr.uc.pt>"

SHELL ["/bin/bash","-c"]

ENV DEBIAN_FRONTEND=noninteractive

# Install packages
RUN apt update \
    && apt install -y \
    libyaml-cpp-dev \
    libpcap-dev

#Install ros2 pkg
RUN apt install -y ros-$ROS_DISTRO-rmw-cyclonedds-cpp

#Configure catkin workspace
ENV CATKIN_WS=/root/ros2_ws
RUN mkdir -p $CATKIN_WS/src

#Clone Bpearl SDK pkg
WORKDIR $CATKIN_WS/src
RUN git clone https://github.com/RoboSense-LiDAR/rslidar_sdk.git
WORKDIR $CATKIN_WS/src/rslidar_sdk
RUN git submodule init
RUN git submodule update

WORKDIR $CATKIN_WS/src
RUN git clone https://github.com/RoboSense-LiDAR/rslidar_msg.git

RUN echo "source /opt/ros/jazzy/setup.bash" >> ~/.bashrc
RUN echo "source /root/ros2_ws/install/setup.bash" >> ~/.bashrc

# Clean-up
WORKDIR /root
RUN apt-get clean

CMD ["bash"]

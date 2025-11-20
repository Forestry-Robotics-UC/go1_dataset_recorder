ARG ARCH=linux/arm64/v8
FROM ros:humble-ros-base

LABEL maintainer="Duarte Cruz <duarte.cruz@isr.uc.pt>"

SHELL ["/bin/bash","-c"]

ENV DEBIAN_FRONTEND=noninteractive

# Install packages
RUN apt-get update \
    && apt-get install -y \
    build-essential \
    apt-utils \
    curl \
    git \
    wget \
    vim \
    nano \
    software-properties-common \
    unzip \
    cmake \
    lsb-release

# Install some python packages
RUN apt-get -y install \
    python3 \
    python3-pip \
    python3-serial \
    python3-rosinstall \
    python3-rosinstall-generator \
    python3-wstool \
    python3-rosdep \
    python3-colcon-common-extensions \
    python3-rosunit

#Install ROS Packages
RUN apt-get install -y ros-humble-rviz2 \
    ros-humble-tf-transformations

#Configure catkin workspace
ENV CATKIN_WS=/root/ros2_ws
RUN mkdir -p $CATKIN_WS/src

#Clone Git repo
WORKDIR $CATKIN_WS/src
RUN git clone -b ros2 https://github.com/rpng/reach_ros_node.git
RUN git clone -b ros2 https://github.com/ros-drivers/nmea_navsat_driver.git

#Compile workspace
WORKDIR $CATKIN_WS
RUN . /opt/ros/humble/setup.sh && colcon build --symlink-install

RUN echo "source /opt/ros/humble/setup.bash" >> ~/.bashrc
RUN echo "source /root/ros2_ws/install/setup.bash" >> ~/.bashrc
RUN echo "ros2 run nmea_navsat_driver nmea_serial_driver" >> ~/.bashrc

# Clean-up
WORKDIR /root
RUN apt-get clean

CMD ["bash"]

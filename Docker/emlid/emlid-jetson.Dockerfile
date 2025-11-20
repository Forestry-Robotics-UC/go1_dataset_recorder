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
    git \
    software-properties-common \
    cmake

# Install some python packages
RUN apt-get -y install python3-pip \
    python3-serial

#Install ROS Packages
RUN apt-get install -y ros-humble-tf-transformations \
    ros-humble-rmw-cyclonedds-cpp

#Configure catkin workspace
ENV CATKIN_WS=/root/ros2_ws
RUN mkdir -p $CATKIN_WS/src

#Clone Git repo
WORKDIR $CATKIN_WS/src
RUN git clone -b ros2 https://github.com/rpng/reach_ros_node.git
RUN git clone -b ros2 https://github.com/ros-drivers/nmea_navsat_driver.git

RUN echo "source /opt/ros/humble/setup.bash" >> ~/.bashrc
RUN echo "source /root/ros2_ws/install/setup.bash" >> ~/.bashrc

# Clean-up
WORKDIR /root
RUN apt-get clean

CMD ["bash"]

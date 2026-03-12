ARG ARCH=linux/arm64/v8
FROM ros:jazzy-ros-base

LABEL maintainer="Duarte Cruz <duarte.cruz@isr.uc.pt>"

SHELL ["/bin/bash","-c"]

ENV DEBIAN_FRONTEND=noninteractive

#Install ROS Packages
RUN apt update \
    && apt install -y \
    ros-$ROS_DISTRO-diagnostic-updater \
    ros-$ROS_DISTRO-librealsense* \
    ros-$ROS_DISTRO-cv-bridge \
    ros-$ROS_DISTRO-image-transport \
    ros-$ROS_DISTRO-rmw-cyclonedds-cpp
    
#Configure catkin workspace
ENV CATKIN_WS=/root/ros2_ws
RUN mkdir -p $CATKIN_WS/src

#Clone realsense pkg
WORKDIR $CATKIN_WS/src
RUN git clone -b r/4.56.4 https://github.com/IntelRealSense/realsense-ros.git

RUN echo "source /opt/ros/jazzy/setup.bash" >> ~/.bashrc
RUN echo "source /root/ros2_ws/install/setup.bash" >> ~/.bashrc

# Clean-up
WORKDIR /root
RUN apt-get clean

CMD ["bash"]


ARG ARCH=linux/arm64/v8
FROM ros:jazzy-ros-base

LABEL maintainer="Duarte Cruz <duarte.cruz@isr.uc.pt>"

SHELL ["/bin/bash","-c"]

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update \
    && apt install -y \
    libtool \
    iputils-ping \
    libboost-all-dev

#Install ros pkgs
RUN apt install -y \
    ros-$ROS_DISTRO-rmw-cyclonedds-cpp \
    ros-$ROS_DISTRO-xacro \
    ros-$ROS_DISTRO-joint-state-publisher

WORKDIR /root/ros2_ws/

#Configure catkin workspace
ENV CATKIN_WS=/root/ros2_ws
RUN mkdir -p $CATKIN_WS/src

WORKDIR $CATKIN_WS/src

#This unitree_ros pkg is in the ros2_ws directory -> Has some modifications, removed the actions considering the battery level (does not work) and the light warnings
#RUN git clone --recursive https://github.com/snt-arg/unitree_ros.git

RUN echo "source /opt/ros/jazzy/setup.bash" >> ~/.bashrc
RUN echo "source /root/ros2_ws/install/setup.bash" >> ~/.bashrc

# Clean-up
WORKDIR /root
RUN apt-get clean

CMD ["bash"]

ARG ARCH=linux/arm64/v8
FROM ros:humble-ros-base

LABEL maintainer="Duarte Cruz <duarte.cruz@isr.uc.pt>"

SHELL ["/bin/bash","-c"]

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends libtool \
    wget nano vim build-essential git python3 python3-pip python3-vcstool git \
    iputils-ping libboost-all-dev

#Install ros pkgs
RUN apt install -y ros-humble-rmw-cyclonedds-cpp \
    ros-humble-xacro \
    ros-humble-joint-state-publisher

WORKDIR /root/ros2_ws/

#Configure catkin workspace
ENV CATKIN_WS=/root/ros2_ws
RUN mkdir -p $CATKIN_WS/src

WORKDIR $CATKIN_WS/src
RUN git clone --recursive https://github.com/snt-arg/unitree_ros.git

RUN echo "source /opt/ros/humble/setup.bash" >> ~/.bashrc
RUN echo "source /root/ros2_ws/install/setup.bash" >> ~/.bashrc

# Clean-up
WORKDIR /root
RUN apt-get clean

CMD ["bash"]
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
    ros-humble-rmw-cyclonedds-cpp \
    ros-humble-xacro \
    ros-humble-joint-state-publisher

WORKDIR /root/ros2_ws/

#Configure catkin workspace
ENV CATKIN_WS=/root/ros2_ws
RUN mkdir -p $CATKIN_WS/src

WORKDIR $CATKIN_WS/src
RUN git clone --recursive https://github.com/snt-arg/unitree_ros.git

RUN echo "source /opt/ros/jazzy/setup.bash" >> ~/.bashrc
RUN echo "source /root/ros2_ws/install/setup.bash" >> ~/.bashrc

# Clean-up
WORKDIR /root
RUN apt-get clean

CMD ["bash"]

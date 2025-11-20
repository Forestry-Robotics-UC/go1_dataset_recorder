ARG ARCH=linux/arm64/v8
FROM ros:humble-ros-base

LABEL maintainer="Duarte Cruz <duarte.cruz@isr.uc.pt>"

SHELL ["/bin/bash","-c"]

ENV DEBIAN_FRONTEND=noninteractive

# Install packages
RUN apt-get update \
    && apt-get install build-essential -y \
    apt-utils \
    curl \
    dialog \
    git \
    wget \
    vim \
    nano \
    software-properties-common \
    unzip \
    cmake \
    lsb-release \
    less \
    udev \
    zstd

# Install some python packages
RUN apt-get -y install \
    python3 \
    python3-pip \
    python3-serial \
    python3-rosinstall \
    python3-rosinstall-generator \
    python3-rosdep \
    python3-colcon-common-extensions \
    python3-wstool \
    python3-rosunit \
    python3-flake8-docstrings \
    python3-pytest-cov \
    python3-dev \
    python3-wheel

#Install ROS Packages
RUN apt-get install -y ros-dev-tools \
    ros-humble-rviz2 \
    ros-humble-tf-transformations \
    ros-humble-imu-tools

#Configure catkin workspace
ENV CATKIN_WS=/root/ros2_ws
RUN mkdir -p $CATKIN_WS/src

#Clone xsens pkg
WORKDIR $CATKIN_WS/src
RUN git clone https://github.com/norlab-ulaval/norlab_xsens_driver.git

#Compile ROS Workspace
WORKDIR $CATKIN_WS
RUN rosdep update
RUN rosdep install --from-paths src --ignore-src -r -y
RUN . /opt/ros/humble/setup.sh &&   colcon build --symlink-install

RUN echo "source /opt/ros/humble/setup.bash" >> ~/.bashrc
RUN echo "source /root/ros2_ws/install/setup.bash" >> ~/.bashrc
RUN echo "ros2 launch xsens_driver xsens_driver.launch.xml" >> ~/.bashrc

# Clean-up
WORKDIR /root
RUN apt-get clean

CMD ["bash"]

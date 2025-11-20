#!/bin/bash
set -e

#ROS 2 Middleware Implementation 

#Fastrtps
#export RMW_IMPLEMENTATION=rmw_fastrtps_cpp
#export FASTDDS_BUILTIN_TRANSPORTS=UDPv4

#Cyclonedds
export RMW_IMPLEMENTATION=rmw_cyclonedds_cpp

# Source ROS2 Humble
source /opt/ros/humble/setup.bash

#Build workspace only with the packages descriminated on docker compose file
cd /root/ros2_ws/
colcon build --packages-select $BUILDLIST --symlink-install --cmake-args -DCMAKE_BUILD_TYPE=Release

# Source ROS2 Workspace
source /root/ros2_ws/install/setup.bash

#Run realsense driver
ros2 launch realsense2_camera rs_launch.py

This repository provides a pipeline to record datasets with Unitree Go1 robot. For a detailed instruction manual, please check the [Wiki](https://github.com/Forestry-Robotics-UC/go1_dataset_recorder/wiki)!

### 1. System Architecture
The entire data-acquisition system for the Unitree Go1 is organized under:
```~/go1_dataset_recorder/
├── Docker/
│   ├── bpearl/
│   ├── emlid/
│   ├── foxglove/
│   ├── go1/
│   ├── realsense/
│   ├── recorder/
│   ├── rm3100/
│   ├── xsens/
│   ├── startup.sh
│   └── docker-compose.yml
├── ros2_ws/
│   ├── bpearl-build/
│   ├── emlid-build/
│   ├── foxglove-build/
│   ├── go1_description/
│   ├── go1-build/
│   ├── realsense-build/
│   ├── recorder-build/
│   ├── rm3100-build/
│   ├── unitree_ros/
│   └── xsens-build/
├── shared_folder/
│   ├── bpearl-launch.sh
│   ├── emlid-launch.sh
│   ├── foxglove-launch.sh
│   ├── go1-launch.sh
│   ├── realsense-launch.sh
│   ├── recorder-launch.sh
│   ├── rm3100-launch.sh
│   └── xsens-launch.sh
├──sensor_configs/
│   ├── bpearl/
│   ├── emlid/
│   ├── go1/
│   ├── realsense/
│   ├── rm3100
│   ├── xsens/

```
#### 1.1 Docker Containers
In Docker dir, each sensor package has its own Dockerfile inside its corresponding directory:
- bpearl/ → Robosense RS-Bpearl LiDAR driver
- emlid/ → GNSS-RTK (Reach M2) driver
- foxglvoe/ → Foxglove and RViZ docker containers
- go1/ → Unitree Go1 SDK
- realsense/ → Intel Realsense camera driver
- recorder/ → hector_recorder
- rm3100/ → RM3100 Magnetometer driver
- xsens/ → Xsens IMU
A docker-compose.yml file creates all containers for the sensors and the recording.
#### 1.2 Shared ROS 2 Workspace
The directory ros2_ws/ is a workspace shared across all containers. Each container mounts:
- ros2_ws/<sensor>-build/ → Build folder of each container
This prevents each container from rebuilding the full workspace and allows faster startup.
This directory also contains two packages that are being shared to the containers:
- ```go1_description``` → Is the package that will launch the ```robot_state_publisher``` using a URDF file placed in this package `urdf/` directory.
- ```unitree_ros``` → This is the ROS2 wrapper of the ```unitree_legged_sdk``` which enables to control the robot with velocity commands as well as receive back the robot state. This package has a problem detecting the battery percentage, so changes needed to be done to remove the automatic actions when it detected low battery.
#### 1.3 Shared Entry-Point Scripts
The folder shared_folder/ contains launcher scripts used by each container:
- They source the ROS2 setup,
- Build only the required packages,
- And run the corresponding launch files or drivers.
The recorder entry point runs the hector_recorder ROS2 command.
#### 1.4 Sensor Configuration
This folder has every configuration needed to each sensor. Every sensor has its own directory and the files are linked to the respective containers.
### 2. System Startup Procedure
#### 2.1 Connecting to the Jetson
The Jetson AGX Orin automatically powers on when the Go1 robot is turned on.
It hosts a Wi-Fi hotspot:
- SSID: Jetson-Go1
- IP Address: 10.42.0.5
- Connect via SSH:
	```ssh fruc-go1-jetson@10.42.0.5```
#### 2.2 Launching the Recording System
Run the script **startup.sh** to start all the system components. The script will tranfer the RM3100 CAN device to the container and run:

1. **docker compose up -d**
   → Starts all sensor containers in the background
2. **docker compose run -i --rm recorder**
   → Opens an interactive shell and launches the hector_recorder TUI
   The recorder will then:

- Ask for a bag name (leave empty to auto-generate)
- Start recording once confirmed
  All ROS2 bags are saved outside the containers. In the directory that you mount to the recorder container, inside the docker-compose file. By default, ```/mnt/External Disk/rosbags/``` directory.
#### To close the system:
1. Press Ctrl+C to close hector_recorder
2. Run docker compose down
### 3. Recording Configuration
To modify what is recorded:
1. Edit the recorder entry-point script in shared_folder/recorder-launch.sh
2. Update:
	- TOPICS variable → to add/remove ROS2 topics
	- hector_recorder command → configure:
		- Bag size limit
		- Storage format (MCAP, SQLite)
		- Compression
		- Performance parameters
		- etc…
### 4. Sensor Configuration
All sensor configuration live inside sensor_configs/.
Configuration files are located here:
#### 4.1 Emlid
Config file:
```emlid/nmea_serial_driver.yaml```
Launch file:
```emlid/nmea_serial_driver.py```
#### 4.2 Robosense Bpearl LiDAR
Config file:
```bpearl/config.yaml```
Launch file:
```bpearl/start.py```
#### 4.3 Realsense Camera
Launch file:
```realsense/rs_launch.py```
#### 4.4 RM3100
Config file:
```rm3100/params.yaml```
#### 4.5 Xsens IMU
Launch file:
```xsens/xsens_driver.launch.xml```

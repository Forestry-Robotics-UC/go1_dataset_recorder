### 1. System Architecture
The entire data-acquisition system for the Unitree Go1 is organized under:
```~/go1_dataset_recorder/
├── Docker/
│   ├── bpearl/
│   ├── emlid/
│   ├── go1/
│   ├── realsense/
│   ├── recorder/
│   ├── ros2_ws/
│   ├── xsens/
│   └── docker-compose.yml
├── ros2_ws/
│   ├── bpearl-build/
│   ├── emlid-build/
│   ├── go1-build/
│   ├── realsense-build/
│   ├── recorder-build/
│   └── xsens-build/
├── shared_folder/
│   ├── bpearl-launch.sh
│   ├── emlid-launch.sh
│   ├── go1-launch.sh
│   ├── realsense-launch.sh
│   ├── recorder-launch.sh
│   └── xsens-launch.sh
├──sensor_configs/
│   ├── bpearl/
│   ├── emlid/
│   ├── go1/
│   ├── realsense/
│   ├── xsens/

```
#### 1.1 Docker Containers
In Docker dir, each sensor package has its own Dockerfile inside its corresponding directory:
- bpearl/ → Robosense RS-Bpearl LiDAR driver
- emlid/ → GNSS-RTK (Reach M2) driver
- go1/ → Unitree Go1 SDK
- realsense/ → Intel Realsense camera driver
- xsens/ → Xsens IMU
- recorder/ → hector_recorder
A docker-compose.yml file creates all containers for the sensors and the recording.
#### 1.2 Shared ROS 2 Workspace
The directory ros2_ws/ is a workspace shared across all containers. Each container mounts:
- ros2_ws/<sensor>-build/ → Build folder of each container
This prevents each container from rebuilding the full workspace and allows faster startup.
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
- SSID: jetson-go1
- IP Address: 192.168.15.1
- Connect via SSH:
	```ssh fruc-jetson-go1@192.168.15.1```
#### 2.2 Launching the Recording System
In the Docker directory, the system can be started. Perform the following commands in different shell sessions.
1. docker compose up -d
	→ Starts all sensor containers in the background
2. docker compose run -i recorder
	→ Opens an interactive shell and launches the hector_recorder TUI
The recorder will then:
- Ask for a bag name (leave empty to auto-generate)
- Start recording once confirmed
All ROS2 bags are saved outside the containers at:
```/mnt/External Disk/rosbags/```
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
#### 4.4 Xsens IMU
Launch file:
```xsens/xsens_driver.launch.xml```

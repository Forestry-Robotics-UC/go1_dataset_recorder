### 1. System Architecture
The entire data-acquisition system for the Unitree Go1 is organized under:
```~/Docker/
├── bpearl/
├── emlid/
├── go1/
├── realsense/
├── recorder/
├── ros2_ws/
│   ├── bpearl-build/
│   ├── emlid-build/
│   ├── go1-build/
│   ├── realsense-build/
│   ├── recorder-build/
│   ├── xsens-build/
│   └── src/
├── shared_folder/
│   ├── bpearl-launch.sh
│   ├── emlid-launch.sh
│   ├── go1-launch.sh
│   ├── realsense-launch.sh
│   ├── recorder-launch.sh
│   └── xsens-launch.sh
├── xsens/
└── docker-compose.yml

```
#### 1.1 Docker Containers
Each sensor package has its own Dockerfile inside its corresponding directory:
- bpearl/ → Robosense RS-Bpearl LiDAR driver
- emlid/ → GNSS-RTK (Reach M2) driver
- go1/ → Unitree Go1 SDK
- realsense/ → Intel Realsense camera driver
- xsens/ → Xsens IMU
- recorder/ → hector_recorder
A docker-compose.yml file creates all containers for the sensors and the recording.
#### 1.2 Shared ROS 2 Workspace
The directory ros2_ws/ is a workspace shared across all containers. Each container mounts:
- ros2_ws/src/ → Source of all packages
- ros2_ws/<sensor>-build/ → Build folder of each container
This prevents each container from rebuilding the full workspace and allows faster startup.
#### 1.3 Shared Entry-Point Scripts
The folder shared_folder/ contains launcher scripts used by each container:
- They source the ROS2 setup,
- Build only the required packages,
- And run the corresponding launch files or drivers.
The recorder entry point runs the hector_recorder ROS2 command.
### 2. System Startup Procedure
#### 2.1 Connecting to the Jetson
The Jetson AGX Orin automatically powers on when the Go1 robot is turned on.
It hosts a Wi-Fi hotspot:
- SSID: jetson-go1
- IP Address: 192.168.15.1
- Connect via SSH:
	```ssh fruc-jetson-go1@192.168.15.1```
#### 2.2 Launching the Recording System
In the HOME directory, two commands can be launched: start and stop.
#### start
Runs startup.sh, which performs:
1. docker compose up -d
	→ Starts all sensor containers in the background
2. docker compose run -i recorder
	→ Opens an interactive shell and launches the hector_recorder TUI
The recorder will then:
- Ask for a bag name (leave empty to auto-generate)
- Start recording once confirmed
#### stop
Runs stop.sh, which:
- Stops and removes all containers
- Ensures a clean shutdown
All ROS2 bags are saved outside the containers at:
```/mnt/External Disk/rosbags/```
#### To close the system:
1. Press Ctrl+C to close hector_recorder
2. Run stop
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
All sensor packages live inside ros2_ws/src/.
Configuration files are located here:
#### 4.1 Emlid
```nmea_navsat_driver/config/nmea_serial_driver.yaml```
#### 4.2 Robosense Bpearl LiDAR
```rslidar_sdk/config/config.yaml```
#### 4.3 Realsense Camera
Launch file with all the necessary parameters:
```realsense-ros/realsense2_camera/launch/rs_launch.py```
#### 4.4 Xsens IMU
Launch file:
```norlab_xsens_driver/launch/xsens_driver.launch.xml```

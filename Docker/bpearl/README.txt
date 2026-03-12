Ethernet profile config:

IPv4 -> Manual
Address: 192.168.1.102
Netmask: 255.255.255.0


config.yaml:

lidar_type: RSBP
use_lidar_clock: false

Launch:

ros2 launch rslidar_sdk start.py

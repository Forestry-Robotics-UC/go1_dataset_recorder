#!/usr/bin/env bash

# Exit if any command fails
set -e

xhost +

# # Bring up can2 on the host (adjust bitrate as needed)
# sudo ip link set can2 type can bitrate 1000000
# sudo ip link set up can2

# # Bring up can0 on the host (adjust bitrate as needed)
# sudo ip link set can0 type can bitrate 1000000
# sudo ip link set up can0

# # Bring up can1 on the host (adjust bitrate as needed)
# sudo ip link set can1 type can bitrate 1000000
# sudo ip link set up can1

# Function to cleanup: move can0 back to host and rename to can2
cleanup() {
    # echo "Cleaning up: moving can0 back to host and renaming to can2..."
    # # Move can0 back to host namespace
    # sudo ip netns delete $pid 2>/dev/null || true
    # sudo ip link set can0 netns 1 2>/dev/null || true
    # sudo ip link set can1 netns 1 2>/dev/null || true
    # sudo ip link set can2 netns 1 2>/dev/null || true

    docker compose down
}

# Trap EXIT signal to ensure cleanup runs
trap cleanup EXIT

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
cd $SCRIPT_DIR

# Start your container in detached mode
#Run foxglove to either start the foxglove server or the rviz -> Change what you want inside foxglove-launcher.sh
docker compose up -d --scale rm3100=0 --scale foxglove=0 &

sleep 1

# # Get the container PID
# pid=$(docker inspect -f '{{.State.Pid}}' rm3100)

# # Move can2 into the container's network namespace
# sudo ip link set can0 netns $pid
# sudo ip link set can1 netns $pid
# sudo ip link set can2 netns $pid

# sudo nsenter -t $pid -n ip link set can0 up
# sudo nsenter -t $pid -n ip link set can1 up
# sudo nsenter -t $pid -n ip link set can2 up

# Open firefox in the foxglove site
#firefox  "https://app.foxglove.dev/isr/view?layoutId=lay_0e1Y5NtJWd6uyJvr&ds=foxglove-websocket&ds.url=ws%3A%2F%2Flocalhost%3A9092" &

#sleep 1

docker compose run --rm -i recorder 

# Attach to logs (or run your main process)
#echo "CAN interface is now can0 inside the container. Press Ctrl+C to exit and cleanup."

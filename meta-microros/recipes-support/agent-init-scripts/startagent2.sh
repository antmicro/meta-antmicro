#!/bin/bash
### BEGIN INIT INFO
# Provides:          micro_ros_agent_2
# Required-Start:    $all
# Required-Stop: 
# Default-Start:     2 3 4 5
# Default-Stop:
# Short-Description: Start the second micro_ros_agent
# Description:       Start the second micro_ros_agent
### END INIT INFO


. /usr/bin/ros_setup.bash
ros2 run micro_ros_agent micro_ros_agent serial --dev /dev/ttyPS0&

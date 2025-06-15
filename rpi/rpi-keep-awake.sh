#!/bin/bash
# This script was created to prevent the system from stopping due to downtime.
# Define the router's IP address and the log file.
router_ip=192.168.0.1
log_file=/tmp/system_away.log

# Check if the log file is writable.
touch $log_file
if [ $? != 0 ]; then
    echo "Cannot use $log_file."
    exit 1
fi  

# Redirect standard output to /dev/null and error output to the log file.
exec 1> /dev/null
exec 2>> $log_file

# Function to log messages to the log file.
print2log () {
    echo $(date +"%D %R ")$@ >>$log_file
}

# Infinite loop.
while [ 1 ]; do
    # Wait for 900 seconds (15 minutes).
    sleep 900
    # Send a ping to the router.
    ping -c 1 $router_ip & wait $!
    if [ $? != 0 ]; then
        # If the ping fails, log a failure message.
        print2log "Ping $router_ip failed."
    else
        # If the ping is successful, log a success message.
        print2log "Ping OK."
    fi
    # Log the PIDs of the sshd processes.
    print2log "sshd PIDs: "$(ps -o pid= -C sshd)
done
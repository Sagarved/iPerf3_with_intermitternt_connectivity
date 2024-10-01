#!/bin/bash

while true; do
 sleep 10	
 for PORT in {5201..5205}; do
    IDLE_TIME=20
    # Check if port is in use
    if [ "$(lsof -i :$PORT)" ]; then
        # Get last access time for the port
        LAST_ACCESS=$(stat -c %X /proc/$(lsof -t -i :$PORT))

        # Calculate idle time
        IDLE=$(( $(date +%s) - $LAST_ACCESS ))

        # Kill process if idle time is greater than IDLE_TIME
        if [ $IDLE -gt $IDLE_TIME ]; then
            kill $(lsof -t -i :$PORT) #killed process because idle time for port exceeded
            echo "$(date +%Y-%m-%d\ %H:%M:%S) Killed process using port $PORT">>   /home/ec2-user/kill_process_idle.txt
	    #sleep 5 # sleep 1 second before starting server
	    #iperf3 -s -p $PORT -D &
            #echo "$(date +%Y-%m-%d\ %H:%M:%S) iperf3 server on port $PORT restarted from idle" >> /home/ec2-user/failed_instances.log   
	fi
     fi
   done
  done

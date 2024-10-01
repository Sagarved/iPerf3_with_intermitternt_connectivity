#!/bin/bash
while true; do
 sleep 60
 for i in {1..8}
  do
   #if ! pgrep -x "iperf3" > /dev/null; then
   if ! pgrep -f "iperf3 -s -p 520$i" > /dev/null; then
     # to confirm the bash_two is not working on that port
     sleep 20
     if ! pgrep -f "iperf3 -s -p 520$i" > /dev/null; then
	     echo "iperf3 server on port 520$i is not running, starting it..."
	     #iperf3 -s -p 520$i -D &
	     #sleep 2
	     #echo "$(date +%Y-%m-%d\ %H:%M:%S) iperf3 server on port 520$i restarted" >> /home/ec2-user/failed_instances.log
	     #killing all iperf3 and bash script
	     killall iperf3
	     pkill -f two_bash.sh
	     sleep 3
	     echo "Restarting two_bash.sh script in daemon mode..."
	     ./two_bash.sh > /dev/null 2>&1 &
	     sleep 10
     fi
   fi
 done  
done


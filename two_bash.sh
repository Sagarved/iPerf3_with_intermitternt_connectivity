#!/bin/bash



# Function to check if the last two lines of the log file contain "0.00 Bytes 0.00 bits/sec"
check_activity() {
    for PORT in {5201..5208};do
    # for PORT in {5201..5205}; do
        LOG_FILE="logs/"$PORT"_log.txt"
        # sleep 2
        #last_lines=$(tail -n 1 "$LOG_FILE")
        #Checking sum of last 3 sessions 24 lines and sum is zero reset
        sum=$(tail -n 24 "$LOG_FILE" | awk '{if ($7+0 == $7) sum += $7} END {print sum}')
        #if [[ $last_lines == *"0.00 Bytes  0.00 bits/sec"* ]]; then
        if (( $(awk 'BEGIN {print ('$sum' == 0)}') )); then
             echo "Restarting iPerf Server "$PORT""
             pkill -f "iperf3.*-s.*-p.*${PORT}"
             # store a log in the archive
             file_timestamp=$(date +"%Y-%m-%d_%H-%M-%S")
             mv  "$LOG_FILE" "logs/archive/$file_timestamp-$PORT"   
             #rm "$LOG_FILE"
             sleep 10
             iperf3 -s -p "$PORT" --verbose --logfile "$LOG_FILE" &
             sleep 2
	fi
     done
}

# Main script execution
#starting iperf
for PORT in {5201..5208};
do
        LOG_FILE="logs/"$PORT"_log.txt"
        iperf3 -s -p "$PORT" --verbose --logfile "$LOG_FILE" &
done

while :
do
    sleep 1
    check_activity
done


# iPerf3_with_intermitternt_connectivity
This is a iperf setup configuration to support intermittent network connectivity. As connectivity get lost, iperf session on server remain on and client couldnot establish connection again on the same port.

Here monitor_bash and two_bash are used. 
two_bash is used for starting iperf on port 5201 to 5208. If checks every second that all ports are active for iperf client. 
If last two entry of particular port has data transfer of zero bytes then it will kill that port iperf session and wait for 10 seconds then restart the session.

While two_bash is sufficient but monitor_bash provides extra layer of check if two_bash is not running.

Both files are configured to run at reboot in crontab -e.
Steps:
Download monitor_bash and two_bash in the same directory.
Update cronjob to start these two script on boot/reboot.

For cloud services make sure accepting UDP and TCP traffic from 5201 to 5208 ports.
Client uses public IP of server or from client iPerf server IP is accessible.

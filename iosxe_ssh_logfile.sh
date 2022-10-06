# #!/usr/bin/expect -f

USERNAME=developer
PASSWORD=C1sco12345
HOST="sandbox-iosxe-latest-1.cisco.com"

echo $(date)
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
echo connecting to ${HOST} ...
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
echo " "

log_file=./$(basename ${HOST} .sh).txt
if [ $log_file ]; then
    touch $log_file
fi

expect <<- END > ${log_file}
    spawn ssh -o StrictHostKeyChecking=no $USERNAME@$HOST  
    expect "*assword:"
    send "$PASSWORD\r"
    expect "#"
    send "terminal length 0\r"
    expect "#"
    send "show version\n"
    expect "#"
    send "exit\r"
    expect closed

END

echo -e "\nScript finished !"

# Reference: https://stackoverflow.com/questions/23768707/bash-script-for-cisco-devices

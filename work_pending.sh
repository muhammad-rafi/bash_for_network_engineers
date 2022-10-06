# #!/usr/bin/expect
# set timeout 60
# spawn ssh [lindex $argv 1]@[lindex $argv 0]
# expect "*?assword" {
#     send "[lindex $argv 2]\r"
#     }
# expect ":~$ " {
#     send "
#         mkdir -p /home/tools/baeldung/auto-test;
#         cd /home/tools/baeldung/auto-test;
#         tree
#         sshpass -p 'Baels@123' scp -r tools@10.45.67.11:/home/tools/cw/baeldung/get_host_info.sh ./;
#         tree
#         bash get_host_info.sh\r"
#     }
# expect ":~$ " {
#     send "exit\r"
#     }
# expect eof

#!/bin/bash
USERNAME=admin
PASSWORD=C1sco123
HOST="10.100.5.202"
# HOSTS="host1 host2 host3"
COMMAND="show ip int brief"

for HOSTNAME in ${HOSTS} ; do
    echo $(ssh -o StrictHostKeyChecking=no -l ${USERNAME} ${HOSTNAME} ${COMMAND})
done

# $ ssh -o StrictHostKeyChecking=no admin@10.100.5.202 "show version"
# echo $(ssh -o StrictHostKeyChecking=no -l $USERNAME $HOST)
printf "\n" >   /dev/null

# https://serverfault.com/questions/505537/connect-to-cisco-switch-using-shell-script
# ------------------------------------------------------------------------------------------------ #




#!/usr/bin/expect -f

set timeout 20

# set host "sandbox-iosxe-latest-1.cisco.com"
set host [lindex $argv 0]
set username "developer"
set password "C1sco12345"
set Directory .

log_file -a $Directory/${host}_logs.log
send_log "\r ~~~~~ Connecting to $host @ [exec date] ~~~~~ \r"

spawn ssh -o "StrictHostKeyChecking no" $username@$host
expect "*assword: "
send "$password\r"
expect "#"
send "conf t\r"
expect "(config)#"
send "int loopback1000\r"
expect "(config-if)#"
send "description created vi expect script\r"
expect "(config-if)#"
send "end\r"
expect "#"
send "exit\r"

sleep 1
send_log "\r session ended \r"
exit

# run the script ./loopback_expect.sh sandbox-iosxe-latest-1.cisco.com
# Reference: https://community.cisco.com/t5/switching/script-to-automate-tasks/td-p/1950293


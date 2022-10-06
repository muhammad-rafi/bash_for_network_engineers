#!/usr/bin/expect

set timeout 20

set username "developer"
set password "C1sco12345"
set host "sandbox-iosxe-latest-1.cisco.com"

spawn ssh -o StrictHostKeyChecking=no $username@$host
expect "*assword:"
send "$password\r"
expect "#"
send "terminal length 0\r"
expect "#"
send "show version\n"
expect "#"
send "exit\r"
expect closed

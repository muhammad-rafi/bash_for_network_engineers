#!/bin/bash

IPADDR="10.100.5.202"
RESTCONF_URL=https://$IPADDR/restconf
ENDPOINT=ietf-interfaces:interfaces/interface
# username="admin"
# password="C1sco123"

echo "Username: "
read username
sleep 1

echo "Password: "
read -s password
sleep 1

iosxe_interfaces(){
    response="$(curl --location --silent --insecure \
    --request GET --header 'Accept: application/yang-data+json' \
    $RESTCONF_URL/data/$ENDPOINT -u $username:$password)"

    response_code="$(curl -LI -k -H 'Accept: application/yang-data+json' \
    -X GET $RESTCONF_URL/data/$ENDPOINT -u $username:$password \
    -o /dev/null -w '%{http_code}\n' -s)"
    
    if [ $response_code = "200" ]; then
            echo $response
    else 
        echo "HTTP Code Error: $response_code"
    fi

}

iosxe_interfaces


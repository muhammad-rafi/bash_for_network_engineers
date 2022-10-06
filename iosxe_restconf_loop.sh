#!/bin/bash

DEVICES=("10.100.5.202" "10.100.5.203")
ENDPOINT="ietf-interfaces:interfaces/interface"
username="admin"
password="C1sco123"

# for DEVICE in "${DEVICES[@]}"
# do
#     echo "$DEVICE is a DEVICE"
# done

iosxe_interfaces(){
    for DEVICE in "${DEVICES[@]}"
    do
        response="$(curl --location --silent --insecure \
        --request GET --header 'Accept: application/yang-data+json' \
        https://$DEVICE/restconf/data/$ENDPOINT -u $username:$password)"

        response_code="$(curl -LI -k -H 'Accept: application/yang-data+json' \
        -X GET https://$DEVICE/restconf/data/$ENDPOINT -u $username:$password \
        -o /dev/null -w '%{http_code}\n' -s)"
        
        if [ $response_code = "200" ]; then
                echo $response
        else 
            echo "HTTP Code Error: $response_code"
        fi
    done
}

iosxe_interfaces


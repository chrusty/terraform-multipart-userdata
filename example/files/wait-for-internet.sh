#!/usr/bin/env bash

PING_ADDRESS="google.com"
SLEEP_TIME=5
INTERNET_CONNECTED=0

while [ ${INTERNET_CONNECTED} == 0 ]
do
    echo "Pinging ${PING_ADDRESS}to test for internet connection"
    ping ${PING_ADDRESS} -c 4 >/dev/null && INTERNET_CONNECTED=1 && break
    echo "Ping unsuccessful - sleep for ${SLEEP_TIME}s"
    sleep ${SLEEP_TIME}
done

echo "Connected to internet!"

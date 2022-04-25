#!/bin/bash

while true
do
        echo "INFO - $(date '+%Y-%m-%d|%H:%M:%S') - Producer daemon - Check new Twits.."
        ./producer.sh
        sleep 60
done

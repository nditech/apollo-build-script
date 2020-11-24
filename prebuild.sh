#!/bin/bash

cd /home/ubuntu/apollo
sudo docker-compose down
cp /home/ubuntu/apollo/settings.ini /home/ubuntu/ || true
rm /home/ubuntu/apollo/settings.ini || true

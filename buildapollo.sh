#!/bin/bash

cd /home/ubuntu/apollo/
rm /home/ubuntu/apollo/settings.ini
cp /home/ubuntu/settings.ini /home/ubuntu/apollo/settings.ini
sudo docker rmi -f $(sudo docker images -a -q)
sudo docker-compose up -d --force-recreate --renew-anon-volumes

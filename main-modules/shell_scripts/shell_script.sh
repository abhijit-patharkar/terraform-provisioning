#!/bin/bash
echo "customshell is being run"
image_name=082814126327.dkr.ecr.us-west-1.amazonaws.com/lf-ecr-repository
sudo docker build \
-t $image_name:latest \
--build-arg instance_id="$1" \
--build-arg metric_name="LFMetric" \
--build-arg alarm_actions="$2" \
--build-arg alarm_name="LFAlarm" \
--no-cache ./shell_scripts/.

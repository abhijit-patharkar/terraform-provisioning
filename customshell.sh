#!/bin/bash
echo "customshell is being run"
INST_ID=$1
container="Foundry"
$2
metric1()
{

docker ps | grep -i "$container"

if [ "$?" -ne 0 ];then
count=0
else
count=1
fi
/usr/local/bin/aws cloudwatch put-metric-data --metric-name "Docker Container $container is down on `hostname`" --unit Percent --value "$count" --dimensions InstanceId=$INST_ID --namespace System/Linux
}

alarm1()
{
/usr/local/bin/aws cloudwatch put-metric-alarm --alarm-name Docker-Prod-Container-Down --alarm-description "If the named container is down this alarm is triggered" --metric-name Docker Container is down on `hostname` --namespace System/Linux --statistic Average --period 60 --threshold $count --comparison-operator LessThanThreshold --dimensions Name=InstanceId,Value=$INST_ID --evaluation-periods 1 --alarm-actions arn:aws:sns:us-east-1:069016302557:ProdContainer --unit Count
}
$3

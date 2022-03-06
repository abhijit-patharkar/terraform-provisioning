#!/bin/bash

NUMBER=$[ ( $RANDOM % 100 )  + 1 ]
echo "random number between 1-100"
echo $NUMBER
echo "customshell for metrics is being run"

aws configure set aws_access_key_id AKIAJI3Q62XC3HFBLMJQ
aws configure set aws_secret_access_key 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
aws configure set default.region us-west-1

INST_ID=1
container="license-foundry"

metric1()
{
curl -s http://localhost:51678/v1/metadata | python -mjson.tool

if [ "$?" -ne 0 ];then
count=0
echo "count=0"
else
count=1
fi
aws cloudwatch put-metric-data --metric-name "Docker Container $container is down on `hostname`" --unit Percent --value "$count" --dimensions InstanceId=$INST_ID --namespace CUSTOM
aws cloudwatch put-metric-data --metric-name "LFCUSTOM" --unit Percent --value "$NUMBER" --dimensions InstanceId=$INST_ID --namespace System/Linux
}

alarm1()
{
aws cloudwatch put-metric-alarm --alarm-name Docker-Prod-Container-Down --alarm-description "If the named container is down this alarm is triggered" --metric-name Docker Container is down on `hostname` --namespace System/Linux --statistic Average --period 60 --threshold $count --comparison-operator LessThanThreshold --dimensions Name=InstanceId,Value=$INST_ID --evaluation-periods 1 --alarm-actions arn:aws:sns:us-west-1:082814126327:alarms-topic --unit Count
}
$1

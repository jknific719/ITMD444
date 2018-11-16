#!/bin/bash
#
imgid=$1
elb=$2
s3bucket=$3
instances=($(aws ec2 describe-instances --filters "Name=image-id,Values=$imgid" "Name=instance-state-name,Values=pending,running" --query 'Reservations[*].Instances[*].InstanceId' | awk '{ print $1 }' | tr -d '",[]'))
aws ec2 terminate-instances --instance-ids ${instances[0]} ${instances[1]} ${instances[2]}
aws elb delete-load-balancer --load-balancer-name $elb
volumes=($(aws ec2 describe-volumes --filters Name=size,Values=10 --query "Volumes[*].{ID:VolumeId}" | awk '{ print $2 }' | tr -d '",[]'))
aws ec2 wait volume-available --volume-ids ${volumes[0]} ${volumes[1]} ${volumes[2]}
aws ec2 delete-volume --volume-id ${volumes[0]}
aws ec2 delete-volume --volume-id ${volumes[1]}
aws ec2 delete-volume --volume-id ${volumes[2]}
aws s3 rb s3://$s3bucket --force

exit 0;

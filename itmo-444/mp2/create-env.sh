#!/bin/bash
#
imgid=$1
keyname=$2
secgrp=$3
count=$4
elb=$5
s3bucket=$6

# Create EC2 instances
echo "Creating EC2 Instances"
avilzone=($(aws ec2 run-instances --image-id $imgid --count $count --instance-type t2.micro --key-name $keyname --security-groups $secgrp  --user-data file://create-app.sh | grep  AvailabilityZone | awk '{ print $2 }' | tr -d '",[]'))
instances=($(aws ec2 describe-instances --filters "Name=image-id,Values=$imgid" "Name=instance-state-name,Values=pending,running" --query 'Reservations[*].Instances[*].InstanceId' | awk '{ print $1 }' | tr -d '",[]'))
echo "Waiting..."
aws ec2 wait instance-running --instance-ids ${instances[0]} ${instances[1]} ${instances[2]}
echo "Creeating load balancer"
aws elb create-load-balancer --load-balancer-name $elb --listeners "Protocol=HTTP,LoadBalancerPort=80,InstanceProtocol=HTTP,InstancePort=80" --availability-zones ${avilzone[0]}
aws elb create-lb-cookie-stickiness-policy --load-balancer-name $elb --policy-name sticky-cookie-policy
aws elb set-load-balancer-policies-of-listener --load-balancer-name $elb --load-balancer-port 80 --policy-names sticky-cookie-policy
aws elb register-instances-with-load-balancer --load-balancer-name $elb --instances ${instances[0]} ${instances[1]} ${instances[2]}
echo "Creating EBS volumes..."
ebsvol[0]=$(aws ec2 create-volume --size 10 --region us-east-2 --availability-zone ${avilzone[0]} --volume-type gp2 | grep  VolumeId | awk '{ print $2 }' | tr -d '",[]')
ebsvol[1]=$(aws ec2 create-volume --size 10 --region us-east-2 --availability-zone ${avilzone[1]} --volume-type gp2 | grep  VolumeId | awk '{ print $2 }' | tr -d '",[]')
ebsvol[2]=$(aws ec2 create-volume --size 10 --region us-east-2 --availability-zone ${avilzone[2]} --volume-type gp2 | grep  VolumeId | awk '{ print $2 }' | tr -d '",[]')
aws ec2 wait volume-available --volume-ids ${ebsvol[0]} ${ebsvol[1]} ${ebsvol[2]}
echo "Attaching EBS volumes..."
aws ec2 attach-volume --volume-id ${ebsvol[0]} --instance-id ${instances[0]} --device /dev/sdf
aws ec2 attach-volume --volume-id ${ebsvol[1]} --instance-id ${instances[1]} --device /dev/sdf
aws ec2 attach-volume --volume-id ${ebsvol[2]} --instance-id ${instances[2]} --device /dev/sdf
echo "Creating S3 bucket..."
aws s3api create-bucket --acl public-read --bucket $s3bucket --region us-east-2 --create-bucket-configuration LocationConstraint=us-east-2
echo "Adding iit-logo.png to S3 bucket..."
aws s3api put-object --acl public-read --bucket $s3bucket --key iit-logo.png --body iit-logo.png

echo "Finished!"

exit 0

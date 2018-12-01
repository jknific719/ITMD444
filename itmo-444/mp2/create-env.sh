#!/bin/bash
#
imgid=$1
keyname=$2
secgrp=$3
iamprofile=$4
count=$5
elb=$6

# Create EC2 instances
echo "Creating SQS queue..."
aws sqs create-queue --queue-name mp2queue --region us-east-1;
echo "Creating RDS instance..."
aws rds create-db-instance --db-name requestdata --db-instance-identifier mp2database --master-username mrvl --master-user-password excelsior --engine mysql --db-instance-class db.t2.micro --allocated-storage 20
echo "Waiting until db instance is available..."
aws rds wait db-instance-available --db-instance-identifier mp2database
echo "Creating EC2 Instances"
echo "Creating backend..."
avilzone=($(aws ec2 run-instances --image-id $imgid --count $count --instance-type t2.micro --key-name $keyname --security-groups $secgrp --iam-instance-profile Name=$iamprofile --user-data file://frontend.sh | grep  AvailabilityZone | awk '{ print $2 }' | tr -d '",[]'))
instances=($(aws ec2 describe-instances --filters "Name=image-id,Values=$imgid" "Name=instance-state-name,Values=pending,running" --query 'Reservations[*].Instances[*].InstanceId' | awk '{ print $1 }' | tr -d '",[]'))
echo "Waiting..."
aws ec2 wait instance-running --instance-ids ${instances[0]} ${instances[1]} ${instances[2]}
echo "Creating load balancer"
aws elb create-load-balancer --load-balancer-name $elb --listeners "Protocol=HTTP,LoadBalancerPort=80,InstanceProtocol=HTTP,InstancePort=80" --availability-zones ${avilzone[0]}
aws elb create-lb-cookie-stickiness-policy --load-balancer-name $elb --policy-name sticky-cookie-policy
aws elb set-load-balancer-policies-of-listener --load-balancer-name $elb --load-balancer-port 80 --policy-names sticky-cookie-policy
aws elb register-instances-with-load-balancer --load-balancer-name $elb --instances ${instances[0]} ${instances[1]} ${instances[2]}
echo "Creating backend..."
aws ec2 run-instances --image-id $imgid --count 1 --instance-type t2.micro --key-name $keyname --security-groups $secgrp --iam-instance-profile Name=$iamprofile --user-data file://backend.sh
echo "Creating S3 buckets..."
aws s3api create-bucket --acl public-read --bucket mp2raw --region us-east-2 --create-bucket-configuration LocationConstraint=us-east-2
aws s3api create-bucket --acl public-read --bucket mp2finished --region us-east-2 --create-bucket-configuration LocationConstraint=us-east-2
echo "Finished!"

exit 0

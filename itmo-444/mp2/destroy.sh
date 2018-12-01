#!/bin/bash
#
imgid=$1
elb=$2
db_id=$3
instances=($(aws ec2 describe-instances --filters "Name=image-id,Values=$imgid" "Name=instance-state-name,Values=pending,running" --query 'Reservations[*].Instances[*].InstanceId' | awk '{ print $1 }' | tr -d '",[]'))
aws ec2 terminate-instances --instance-ids ${instances[0]} ${instances[1]} ${instances[2]} ${instances[3]}
aws elb delete-load-balancer --load-balancer-name $elb
aws s3 rb s3://mp2raw --force
aws s3 rb s3://mp2finished --force
aws rds delete-db-instance --db-instance-identifier $db_id --skip-final-snapshot
sqsurl=$(aws sqs get-queue-url --queue-name mp2queue --output text)
aws sqs delete-queue --queue-url $sqsurl
subs=($(aws sns list-subscriptions --output text --region us-east-1 | cut -f5))
for i in "${subs[@]}"
do
  aws sns unsubscribe --subscription-arn $i --region us-east-1
done
topics=($(aws sns list-topics --output text --region us-east-1 | cut -f2))
for n in "${topics[@]}"
do
  aws sns delete-topic --topic-arn $n --region us-east-1
done
exit 0;

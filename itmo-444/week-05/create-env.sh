#!/bin/bash

aws ec2 authorize-security-group-ingress --group-name launch-wizard-1 --protocol tcp --port 4000 --cidr 0.0.0.0/0

aws ec2 run-instances --image-id ami-0f65671a86f061fcd --count 1 --instance-type t2.micro --key-name pairs --security-groups launch-wizard-1 --user-data file://installjekyll.sh
exit 0

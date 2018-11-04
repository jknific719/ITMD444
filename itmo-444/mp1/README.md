# MP1 Instructions
# PLEASE USE ami-0e250177a382fe01a WRONG AMI WAS SUBMITTED
## create-env.sh
Usage:
create-env.sh ami-id keyfile security-group count elb-name s3bucket-name

./create-env.sh ami-0e250177a382fe01a pairs launch-wizard-1 3 elbtest mp1bucket

The scripts expect the ami to be ami-0e250177a382fe01a and the bucket to be mp1bucket

It expects iit-logo.png and create-app.sh to be in the same directory as the script

## destroy.sh

Usage: destroy.sh ami-id elb-name s3bucket-name

./destroy.sh ami-0ecba9ca5e3e12406 elbtest mp1bucket

# create-app.sh
Ran as user data, so no usage. Please place in the same directory as create-env.sh

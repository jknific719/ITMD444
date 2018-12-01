# MP2 Instructions
# PLEASE USE ami-0e250177a382fe01a
## create-env.sh
Usage:
create-env.sh ami-id keyfile security-group iam-profile count elb-name

./create-env.sh ami-0e250177a382fe01a pairs default itmo444 3 elbtest

The scripts expect the ami to be ami-0e250177a382fe01a

It expects frontend.sh and backend.sh to be in the same directory as the script

It will create S3 buckets with the specific names: mp2raw mp2finished

Creates an SQS queue named m2queue specifically in us-east-1

## Website
Usage:
Provide your name, email, and phone number along with a direct url to an image (http://www.example.com/example.jpg)
and it will convert it into a grayscale image and send you a link to both email and phone number, however the email
requires a subscription confirmation.

It will check every ~30 seconds for a new image

## destroy.sh

Usage: destroy.sh ami-id elb-name db-identifier-name

./destroy.sh ami-0ecba9ca5e3e12406 elbtest mp2database

The script expects the database to be called mp2database

Will remove all created objects and will remove all confirmed subscriptions. Cannot delete pending subscriptions as they auto-delete after 3 days

# frontend.sh
Ran as user data, so no usage. Please place in the same directory as create-env.sh

# backend.sh
Ran as user data, so no usage. Please place in the same directory as create-env.sh

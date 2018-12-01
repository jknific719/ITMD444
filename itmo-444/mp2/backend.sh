#!/bin/bash
# User-data script for the backend image manipulation instance
apt-get update
apt-get install -y apache2
apt-get install -y git
sudo apt-get install -y curl php php-simplexml unzip zip libapache2-mod-php php-xml php-mysql awscli imagemagick
cd /home/ubuntu
sudo php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
sudo php composer-setup.php --quiet
sudo php -d memory_limit=-1 composer.phar require aws/aws-sdk-php 1>> /home/ubuntu/out.log 2>> /home/ubuntu/err.log
git clone git@github.com:illinoistech-itm/jknific.git
cp jknific/itmo-444/mp2/dbcreate.php /home/ubuntu/dbcreate.php
sudo php dbcreate.php --quiet
cp jknific/itmo-444/mp2/cronjob.txt /home/ubuntu/cronjob.txt
cp jknific/itmo-444/mp2/imgprocess.php /home/ubuntu/imgprocess.php
crontab -u ubuntu cronjob.txt
exit 0

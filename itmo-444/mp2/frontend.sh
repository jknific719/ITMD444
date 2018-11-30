#!/bin/bash
# User-data for the frontend webhosting servers
apt-get update
apt-get install -y apache2
apt-get install -y git
sudo apt-get install -y curl php php-simplexml unzip zip libapache2-mod-php php-xml php-mysql awscli
cd /home/ubuntu
sudo php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
sudo php composer-setup.php --quiet
sudo php -d memory_limit=-1 composer.phar require aws/aws-sdk-php 1>> /home/ubuntu/out.log 2>> /home/ubuntu/err.log
git clone git@github.com:illinoistech-itm/jknific.git
cp jknific/itmo-444/mp2/index.html /var/www/html/index.html
cp jknific/itmo-444/mp2/process_form.php /var/www/html/process_form.php
cp jknific/itmo-444/mp2/db_add.php /var/www/html/db_add.php
systemctl start apache2

exit 0

#!/bin/bash
#
apt-get update
apt-get install -y apache2
apt-get install -y git
git clone git@github.com:illinoistech-itm/jknific.git
cp jknific/itmo-444/mp1/index.html /var/www/html/index.html
systemctl start apache2
mkdir /mnt/datadisk
parted -s -a optimal /dev/xvdf mklabel gpt -- mkpart primary ext4 0% 100%
mkfs.ext4 -F -L datapartition /dev/xvdf
mount -o defaults /dev/xvdf /mnt/datadisk/

exit 0

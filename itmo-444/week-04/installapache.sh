#!/bin/bash
apt-get update
apt-get install -y apache2
systemctl start apache2

exit 0

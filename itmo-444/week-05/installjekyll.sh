#!/bin/bash

sudo apt-get -y update

sudo apt-get -y install ruby gem ruby-dev links build-essential
sudo gem install bundler jekyll
jekyll new mysite
cd mysite
bundle exec jekyll serve --host 0.0.0.0

exit 0

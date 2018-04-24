#!/bin/bash
curl -sSL https://get.rvm.io | bash
source /home/vagrant/.rvm/scripts/rvm
rvm install ruby-2.4
gem install rack
rackupPath=`whereis rackup`
rackupPath=`cut -d ":" -f 2 <<< ${rackupPath}`
sed -i "s;rackup;${rackupPath};" /home/vagrant/rubyserver.service
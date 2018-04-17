#!/bin/bash
echo $'\nPATH="$(ruby -rubygems -e \'puts Gem.user_dir\')/bin:$PATH"' >> /home/ubuntu/.bashrc
source /home/ubuntu/.bashrc
export PATH="$(ruby -rubygems -e 'puts Gem.user_dir')/bin:$PATH"
gem install --user-install --no-ri --no-rdoc sinatra bundler
cd /vagrant
bundle
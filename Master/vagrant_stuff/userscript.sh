#!/bin/bash
echo $'\nGEM_HOME="$(ruby -rubygems -e \'puts Gem.user_dir\')"' >> /home/ubuntu/.bashrc
echo $'\nPATH="$(ruby -rubygems -e \'puts Gem.user_dir\')/bin:$PATH"' >> /home/ubuntu/.bashrc
source ~/.bashrc
export GEM_HOME=$(ruby -rubygems -e 'puts Gem.user_dir')
export PATH="$(ruby -rubygems -e 'puts Gem.user_dir')/bin:$PATH"
gem install --user-install --no-ri --no-rdoc sinatra bundler
cd /vagrant
bundle
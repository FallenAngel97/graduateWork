#!/bin/bash
echo $'PATH="$(ruby -e \'puts Gem.user_dir\')/bin:$PATH"' >> /home/ubuntu/.bashrc
echo $'\nGEM_HOME="$(ruby -rubygems -e \'puts Gem.user_dir\')"' >> /home/ubuntu/.bashrc
export PATH="$(ruby -e 'puts Gem.user_dir')/bin:$PATH"
export GEM_HOME=$(ruby -rubygems -e 'puts Gem.user_dir')
gem install bundler --user
cd /vagrant
bundle
bundle exec rake db:create
PGPASSWORD=angel psql -U angel todo_base < /vagrant/dump.sql
# npm i --no-bin-links
# mkdir ~/.npm-global
# npm config set prefix '~/.npm-global'
# export PATH=~/.npm-global/bin:$PATH
# source ~/.profile
# npm i gulp --no-bin-links
# gulp production

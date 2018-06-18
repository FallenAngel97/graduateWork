#!/bin/bash
echo $'\nGEM_HOME="$(ruby -e \'puts Gem.user_dir\')"' >> /home/vagrant/.bashrc
echo $'\nPATH="$(ruby -e \'puts Gem.user_dir\')/bin:$PATH"' >> /home/vagrant/.bashrc
source ~/.bashrc
export PATH="$(ruby -e 'puts Gem.user_dir')/bin:$PATH"
export GEM_HOME=$(ruby -e 'puts Gem.user_dir')
gem install bundler
cd /vagrant
bundle
bundle exec rake db:create
psql -U angel todo_base < /vagrant/dump.sql
# npm config set prefix '~/.npm-global'
# npm i --no-bin-links
# npx gulp production
#!/bin/bash
whoami
echo $HOME
echo $'PATH="$(ruby -e \'puts Gem.user_dir\')/bin:$PATH"' >> /home/vagrant/.bashrc
export PATH="$(ruby -e 'puts Gem.user_dir')/bin:$PATH"
gem install bundler
cd /vagrant
bundle
bundle exec rake db:create
psql -U angel todo_base < /vagrant/dump.sql
npm i
/vagrant/node_modules/gulp production
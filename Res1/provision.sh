#!/bin/bash
pacman -Suy --noconfirm
pacman -S vim apache ruby --noconfirm
sudo systemctl enable httpd
sudo systemctl start httpd
su vagrant << EOF
GEMPATH=`su - vagrant -c "ruby -e 'print Gem.user_dir'"`
echo "PATH=\\\$PATH:$GEMPATH/bin" >> /home/vagrant/.bashrc
source /home/vagrant/.bashrc
gem install bundler passenger
EOF
GEMPATH=`su - vagrant -c "ruby -e 'print Gem.user_dir'"`
chmod o+x "/home/vagrant"
chmod o+x "/home/vagrant/.gem"
chmod o+x "/home/vagrant/.gem/ruby"
chmod o+x $GEMPATH
chmod o+x ${GEMPATH}/gems
chmod o+x ${GEMPATH}/gems/passenger*

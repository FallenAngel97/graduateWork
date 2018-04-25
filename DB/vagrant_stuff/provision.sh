#!/bin/bash
yum install ruby perl -y
perl -p00e "s/(?<bodytext>\[base\][\s\S]*?gpgkey.*)/$+{bodytext}\exclude=postgresql*/" /etc/yum.repos.d/CentOS-Base.repo
perl -p00e "s/(?<bodytext>\[updates\][\s\S]*?gpgkey.*)/$+{bodytext}\exclude=postgresql*/" /etc/yum.repos.d/CentOS-Base.repo
yum install https://download.postgresql.org/pub/repos/yum/10/redhat/rhel-7-x86_64/pgdg-centos10-10-2.noarch.rpm -y
yum install postgresql10-server -y
/usr/pgsql-*/bin/postgresql*-setup initdb
systemctl enable postgresql-10.service
gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
su vagrant -c '/bin/bash /home/vagrant/userscript.sh'
systemctl start firewalld
systemctl enable firewalld
firewall-cmd --zone=public --add-port=http/tcp
firewall-cmd --zone=public --add-port=http/tcp --permanent
cp /home/vagrant/rubyserver.service /etc/systemd/system/rubyserver.service
systemctl daemon-reload
mv /home/vagrant/.udev-mount-restart-services.sh /root/.udev-mount-restart-services.sh
mv /home/vagrant/50-vagrant-mount.rules /etc/udev/rules.d/50-vagrant-mount.rules
#hack for enabling service after vagrant mounting.
sleep 5
systemctl start rubyserver.service
systemctl enable rubyserver.service
systemctl restart rubyserver.service
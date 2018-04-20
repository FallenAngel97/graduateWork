#!/bin/bash
apt-get update 
apt-get upgrade -y
apt-get autoremove
apt-get install build-essential postgresql-server-dev-all ruby-dev vim postgresql-contrib apache2 postgresql passenger libapache2-mod-passenger -y
curl -sL https://deb.nodesource.com/setup_9.x | bash -
apt-get install nodejs -y
echo "ubuntu:ubuntu" | chpasswd
#
# Apache configuration
#
mv /home/ubuntu/siteObservable.conf /etc/apache2/sites-available/siteObservable.conf
a2enmod rewrite
a2ensite siteObservable
a2dissite 000-default
apache2ctl restart
systemctl enable apache2.service
#
# PostgreSQL configuration
#
su postgres -c 'printf "angel\nangel\n" | createuser -dRsP angel'
POSTGRES_DATA=`sed -e '/# "local" is for Unix domain socket connections only/!b;n;clocal   all             all                                     md5' -e '/# IPv6 local connections:/!b;n;chost    all             all             ::1/128                 md5' /etc/postgresql/*/main/pg_hba.conf`
echo "$POSTGRES_DATA">/etc/postgresql/*/main/pg_hba.conf
service postgresql restart
#
# Setup the site libraries
#
npm install -g npm@latest
su ubuntu -c '/bin/bash /home/ubuntu/userscript.sh'

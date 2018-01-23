#!/bin/bash
apt-get update
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 561F9B9CAC40B2F7
apt-get install -y apache2 ruby-full build-essential\
        libcurl4-openssl-dev libssl-dev apache2-dev\
        libapr1-dev libaprutil1-dev dirmngr gnupg\
        apt-transport-https ca-certificates virtualbox-guest-utils
sh -c 'echo deb https://oss-binaries.phusionpassenger.com/apt/passenger xenial main > /etc/apt/sources.list.d/passenger.list'
apt-get update
apt-get install -y libapache2-mod-passenger
apt-get upgrade
source ~/.bashrc
source ~/.profile
a2enmod rewrite
a2enmod passenger
service apache2 restart
SUCCESS=`/usr/bin/passenger-config validate-install | tail -1`
if [[ "$SUCCESS" != *'Everything looks good. :-)'* ]]; then
    echo "Something went wrong."
    /usr/bin/passenger-config validate-install
    exit 0
fi
mv /home/ubuntu/siteMaster.conf /etc/apache2/sites-available/siteMaster.conf
a2dissite 000-default
a2ensite siteMaster
service apache2 restart
su ubuntu -c '/bin/bash /home/ubuntu/userscript.sh'
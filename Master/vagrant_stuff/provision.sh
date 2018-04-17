#!/bin/bash
apt-get update
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 561F9B9CAC40B2F7
apt-get install -y nginx ruby-full build-essential\
        libcurl4-openssl-dev libssl-dev\
        libapr1-dev libaprutil1-dev dirmngr gnupg nmap\
        apt-transport-https ca-certificates virtualbox-guest-utils
sh -c 'echo deb https://oss-binaries.phusionpassenger.com/apt/passenger xenial main > /etc/apt/sources.list.d/passenger.list'
apt-get update
apt-get install -y passenger nginx-extras
source ~/.bashrc
source ~/.profile
sed -i '/passenger_ruby/s/^.*$/passenger_ruby \/usr\/bin\/ruby;/g' /etc/nginx/passenger.conf
sed -i '/include.*passenger/s/^.*#//g' /etc/nginx/nginx.conf
SUCCESS=`/usr/bin/passenger-config validate-install | tail -1`
if [[ "$SUCCESS" != *'Everything looks good. :-)'* ]]; then
    echo "Something went wrong."
    /usr/bin/passenger-config validate-install
    exit 0
fi
mv /home/ubuntu/default /etc/nginx/sites-available/default
service nginx restart
su ubuntu -c '/bin/bash /home/ubuntu/userscript.sh'
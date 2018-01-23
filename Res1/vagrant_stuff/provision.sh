#!/bin/bash
pacman -Suy --noconfirm
pacman -S vim apache postgresql ruby passenger mod_passenger postgresql-libs  --noconfirm
#
# Apache configuration
#
sudo systemctl enable httpd
sudo systemctl start httpd
payload="
LoadModule passenger_module /usr/lib/httpd/modules/mod_passenger.so
PassengerRoot /usr/lib/passenger
PassengerRuby /usr/bin/ruby
"
NEWDATA=`awk -v var="$payload" '/LoadModule rewrite_module/ { print; print var; next }1' /etc/httpd/conf/httpd.conf`
echo "$NEWDATA">/etc/httpd/conf/httpd.conf
sed -i '/httpd-vhosts\.conf/s/^#//' /etc/httpd/conf/httpd.conf
mv /home/vagrant/siteObserved.conf /etc/httpd/conf/extra/httpd-vhosts.conf
systemctl restart httpd
#
# PostgreSQL configuration
#
su - postgres -c "initdb --locale en_US.UTF-8 -E UTF8 -D '/var/lib/postgres/data'"
systemctl start postgresql
systemctl enable postgresql
su postgres -c 'printf "angel\nangel\n" | createuser -dRsP angel'
#
# Setup the site libraries
#
su vagrant -c '/bin/bash /home/vagrant/userscript.sh'

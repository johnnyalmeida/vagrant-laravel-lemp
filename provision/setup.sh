#!/bin/bash


# Variables
DBNAME=laravel
DBUSER=root
DBPASSWD=root
DBDUMP=database.sql

echo "Provisioning virtual machine..."

echo "Updating apt-get..."
sudo apt-get update > /dev/null

# Git
echo "Installing Git..."
sudo apt-get install -y git > /dev/null

# Vim
echo "Installing Vim..."
sudo apt-get install -y vim > /dev/null

# Nginx
echo "Installing Nginx..."
sudo apt-get install -y nginx > /dev/null

# PHP
echo "Updating PHP repository..."
sudo apt-get install -y python-software-properties build-essential > /dev/null
sudo add-apt-repository -y ppa:ondrej/php > /dev/null

echo "Updating apt-get once more..."
sudo apt-get update > /dev/null

echo "Installing PHP..."
sudo apt-get install -y php7.0 php7.0-fpm > /dev/null

echo "Installing PHP extensions..."
sudo apt-get install -y curl php7.0-mysql php7.0-zip  php7.0-mbstring php7.0-curl php7.0-mcrypt php7.0-xml > /dev/null

echo "Installing PHP image extensions..."
sudo apt-get install -y pkg-config libmagickwand-dev imagemagick build-essential

# MySQL
echo "Preparing MySQL..."
sudo apt-get install -y debconf-utils > /dev/null
debconf-set-selections <<< "mysql-server mysql-server/root_password password $DBPASSWD"
debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $DBPASSWD"

echo "Installing MySQL..."
sudo apt-get install -y mysql-server > /dev/null

# phpMyAdmin
echo "Preparing phpMyAdmin"
debconf-set-selections <<< "phpmyadmin phpmyadmin/dbconfig-install boolean true"
debconf-set-selections <<< "phpmyadmin phpmyadmin/app-password-confirm password $DBPASSWD"
debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/admin-pass password $DBPASSWD"
debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/app-pass password $DBPASSWD"
debconf-set-selections <<< "phpmyadmin phpmyadmin/reconfigure-webserver multiselect none"
apt-get -y install phpmyadmin > /dev/null


# Create MySQL database
echo "Creating database..."
mysql -uroot -proot -e "DROP SCHEMA IF EXISTS $DBNAME;" > /dev/null
mysql -uroot -proot -e "CREATE DATABASE IF NOT EXISTS $DBNAME;" > /dev/null

# Import Mysql Dump
if [ -f /var/www/database/$DBDUMP ]; then
  echo "Importing database..."
  mysql -uroot -proot $DBNAME < /var/www/database/$DBDUMP > /dev/nulls
else
  echo "No database dump to import."
fi

# Nginx Config
echo "Configuring Nginx..."
rm -rf /etc/nginx/sites-available/default
cp /var/www/provision/nginx/default /etc/nginx/sites-available/default > /dev/null


# Restarting Nginx for config to take effect
echo "Restarting Nginx..."
service nginx restart > /dev/null

# Composer
echo "Installing Composer"
curl --silent https://getcomposer.org/installer | php > /dev/nulls
mv composer.phar /usr/local/bin/composer

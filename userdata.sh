#!/bin/bash
# variable will be populated by terraform template
db_username="wpadm"
db_user_password="Globe123"
db_name="godb"
db_RDS="localhost"
# install LAMP Server
yum update -y
#install apache server and mysql client

TOKEN=`curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600"` \
&& curl -H "X-aws-ec2-metadata-token: $TOKEN" -v http://169.254.169.254/latest/meta-data/

EC2IP=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" -v http://169.254.169.254/latest/meta-data/public-ipv4)
echo $EC2IP

amazon-linux-extras install -y lamp-mariadb10.2-php7.2 php7.2
sudo yum install -y httpd mariadb-server
sudo yum install -y git

sudo systemctl start mariadb
sudo mysql -e  "CREATE DATABASE $db_name DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci;"

aws s3 cp s3://uploadssluat/godbmain.sql .
sudo mysql godb < godbmain.sql
sudo mysql -e "use $db_name;create user '$db_username'@'localhost' identified by '$db_user_password';GRANT ALL PRIVILEGES ON $db_name.* TO '$db_username'@'localhost';FLUSH PRIVILEGES;"
sudo mysql -e "use $db_name;UPDATE wp_options SET option_value= 'http://$EC2IP' WHERE option_name= 'siteurl';"
sudo mysql -e "use $db_name;UPDATE wp_options SET option_value= 'http://$EC2IP' WHERE option_name= 'home';"


#first enable php7.xx from  amazon-linux-extra and install it

yum clean metadata
#install imagick extension
yum -y install gcc ImageMagick ImageMagick-devel ImageMagick-perl
pecl install imagick
chmod 755 /usr/lib64/php/modules/imagick.so
cat <<EOF >>/etc/php.d/20-imagick.ini

extension=imagick

EOF

systemctl restart php-fpm.service

systemctl start  httpd



# Change OWNER and permission of directory /var/www
usermod -a -G apache ec2-user
chown -R ec2-user:apache /var/www
find /var/www -type d -exec chmod 2775 {} \;
find /var/www -type f -exec chmod 0664 {} \;


# #**********************Installing Wordpress manually********************************* 
# # Download wordpress package and extract
wget https://wordpress.org/latest.tar.gz
tar -xzf latest.tar.gz
cp -r wordpress/* /var/www/html/
# # Create wordpress configuration file and update database value

mkdir git
cd git
git clone https://github.com/micolord/gpoc.git
cd gpoc
git config --global user.email "53897214+micolord@users.noreply.github.com"
git config --global user.name "micolord"
git checkout -b dev
git reset --hard origin/dev


cd /var/www/html
cp wp-config-sample.php wp-config.php
sed -i "s/database_name_here/$db_name/g" wp-config.php
sed -i "s/username_here/$db_username/g" wp-config.php
sed -i "s/password_here/$db_user_password/g" wp-config.php
sed -i "s/localhost/$db_RDS/g" wp-config.php
cat <<EOF >>/var/www/html/wp-config.php
define( 'FS_METHOD', 'direct' );
define('WP_MEMORY_LIMIT', '128M');
EOF


#**********************Installing Wordpress using WP CLI********************************* 
#curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
#chmod +x wp-cli.phar
#mv wp-cli.phar /usr/local/bin/wp
#wp core download --path=/var/www/html --allow-root
#wp config create --dbname=$db_name --dbuser=$db_username --dbpass=$db_user_password --dbhost=$db_RDS --path=/var/www/html --allow-root --extra-php <<PHP
#define( 'FS_METHOD', 'direct' );
#define('WP_MEMORY_LIMIT', '128M');
#PHP



# Change permission of /var/www/html/
chown -R ec2-user:apache /var/www/html
chmod -R 774 /var/www/html

#  enable .htaccess files in Apache config using sed command
sed -i '/<Directory "\/var\/www\/html">/,/<\/Directory>/ s/AllowOverride None/AllowOverride all/' /etc/httpd/conf/httpd.conf

#Make apache  autostart and restart apache
systemctl enable  httpd.service
systemctl restart httpd.service
systemctl enable  mariadb


echo WordPress Installed
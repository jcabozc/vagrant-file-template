#cat /etc/os/release


yum -y update
sed -i 's/SELINUX=enforcing/SELINUX=disabled/' /etc/sysconfig/selinux && setenforce 0

wget http://dl.fedoraproject.org/pub/epel/epel-release-latest-6.noarch.rpm && rpm -ivh epel-release-latest-6.noarch.rpm
yum -y install docker-io mysql
yum -y install httpd php php-mysql httpd-manual mod_perl mod_auth_mysql  php-gd php-xml php-mbstring php-ldap php-pear php-xmlrpc php-mcrypt


docker run -d -p 3306:3306 --name docker.mysql.yzy --restart=always -e MYSQL_ROOT_PASSWORD=root1234 -v /etc/localtime:/etc/localtime:ro -v /home/data:/var/lib/mysql  daocloud.io/library/mysql:5.6.36


service docker start && chkconfig docker on 
service httpd start && chkconfig docker on 

cat << EOF >> /etc/httpd/conf/httpd.conf 
Listen 8081
<VirtualHost *:8081>
DocumentRoot "/var/www/html"
ErrorLog "logs/jys-error.log"
CustomLog "logs/jys-access.log" common
<Directory "/var/www/html">
Options Indexes FollowSymLinks
DirectoryIndex index.html index.htm index.php
AllowOverride None
Order allow,deny
Allow from all
</Directory>
</VirtualHost>
EOF

service httpd restart && chkconfig docker on


#解决Zend Guard Run-time support missing!的问题
wget http://down.ikode.org/ZendGuardLoader-php-5.3-linux-glibc23-x86_64.tar.gz && tar xf ZendGuardLoader-php-5.3-linux-glibc23-x86_64.tar.gz 
cp ZendGuardLoader-php-5.3-linux-glibc23-x86_64/php-5.3.x/ZendGuardLoader.so /usr/local/lib/
echo "zend_extension = /usr/local/lib/ZendGuardLoader.so" >> /etc/php.ini




 






#!/bin/bash

if ! sudo yum list installed | grep httpd > /dev/null 2>&1; then
    sudo yum install -y httpd

    # Allow http prot
    sudo /sbin/iptables -I INPUT -p tcp --dport http -j ACCEPT
    sudo /sbin/service iptables save

    # start the httpd.
    sudo /sbin/service httpd start

    # setting to start the httpd at startup to machine.
    sudo /sbin/chkconfig httpd on
fi

# mysql
if ! sudo yum list installed | grep mysql-server > /dev/null 2>&1; then
    # install mysql server
    sudo yum install -y mysql-server
    echo "SET PASSWORD FOR root@localhost=password('aiCh0noa');" | mysql -uroot

    # Start to services.
    sudo /sbin/service mysqld start

    # Registering to automatic startup.
    sudo /sbin/chkconfig mysqld on
fi

# php
if ! sudo yum list installed | grep php > /dev/null 2>&1; then
    # install php.
    sudo yum install -y php php-mysql php-mbstring php-mcript
fi

# phpMyAdmin
if [ ! -e "/usr/share/phpMyAdmin/" ]; then
    cd /tmp/
    wget http://jaist.dl.sourceforge.net/project/phpmyadmin/phpMyAdmin/4.1.1/phpMyAdmin-4.1.1-all-languages.tar.gz -O phpMyAdmin.tar.gz
    tar zxf phpMyAdmin.tar.gz
    rm -f phpMyAdmin.tar.gz
    sudo mv  phpMyAdmin-4.1.1-all-languages/ /usr/share/phpMyAdmin
    sudo chown -R vagrant:apache /usr/share/phpMyAdmin/

    if [ ! -e "/etc/httpd/conf.d/phpMyAdmin.conf" ]; then
        sudo touch /etc/httpd/conf.d/phpMyAdmin.conf
        echo "Alias /phpMyAdmin /usr/share/phpMyAdmin/" | sudo tee -a /etc/httpd/conf.d/phpMyAdmin.conf
        echo "" | sudo tee -a /etc/httpd/conf.d/phpMyAdmin.conf
        echo "<Directory /usr/share/phpMyAdmin>" | sudo tee -a /etc/httpd/conf.d/phpMyAdmin.conf
        echo "    Order Allow,Deny" | sudo tee -a /etc/httpd/conf.d/phpMyAdmin.conf
        echo "    Allow from all" | sudo tee -a /etc/httpd/conf.d/phpMyAdmin.conf
        echo "    AllowOverride all" | sudo tee -a /etc/httpd/conf.d/phpMyAdmin.conf
        echo "</Directory>" | sudo tee -a /etc/httpd/conf.d/phpMyAdmin.conf
    fi

    # copy config file.
    sudo cp /usr/share/phpMyAdmin/config.sample.inc.php /usr/share/phpMyAdmin/config.inc.php

    # SELunux
    chcon system_u:object_r:httpd_sys_content_t:s0 /usr/share/phpMyAdmin/ -R

    # restart the httpd.
    sudo /sbin/service httpd restart
fi


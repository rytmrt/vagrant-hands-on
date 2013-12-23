#!/bin/bash

sudo /usr/sbin/setenforce 0

if ! sudo yum list installed | grep httpd > /dev/null 2>&1; then
    echo "httpd installing."
    sudo yum install -y httpd > /dev/null 2>&1
    echo "Completed httpd installing."

    # Allow http prot
    sudo /sbin/iptables -I INPUT -p tcp --dport http -j ACCEPT > /dev/null 2>&1
    sudo /sbin/service iptables save > /dev/null 2>&1

    if [ ! -e "/vagrant/webroot/" ]; then
        echo "Make directory webroot."
        mkdir /vagrant/webroot
        echo "<?php phpinfo(); ?>" > /vagrant/webroot/index.php
    fi

    # Changeing webroot.
    sudo mv /etc/httpd/conf/httpd.conf /etc/httpd/conf/httpd.conf.bk
    sudo sed -e 's/"\/var\/www\/html"/"\/vagrant\/webroot\/"/g' /etc/httpd/conf/httpd.conf.bk > /etc/httpd/conf/httpd.conf

    # start the httpd.
    sudo /sbin/service httpd start > /dev/null 2>&1
    echo "Started httpd."

    # setting to start the httpd at startup to machine.
    sudo /sbin/chkconfig httpd on
    echo "Registered to automatic startup of httpd."
fi

# mysql
if ! sudo yum list installed | grep mysql-server > /dev/null 2>&1; then
    # install mysql server
    echo "mysql-server installing."
    sudo yum install -y mysql-server > /dev/null 2>&1
    echo "Completed mysql-server installing."

    # Start to services.
    sudo /sbin/service mysqld start > /dev/null 2>&1
    echo "Started mysqld."
    
    # Changing root's password.
    echo "SET PASSWORD FOR root@localhost=password('aiCh0noa');" | mysql -uroot
    echo "Changed mysql root's password."

    # Registering to automatic startup.
    sudo /sbin/chkconfig mysqld on
    echo "Registered to automatic startup of mysqld."
fi

# php
if ! sudo yum list installed | grep php > /dev/null 2>&1; then
    # install php.
    echo "php and php modules installing."
    sudo yum install -y php php-mysql php-mbstring php-mcript > /dev/null 2>&1
    echo "Completed php and php modules installing."
fi

# phpMyAdmin
if [ ! -e "/usr/share/phpMyAdmin/" ]; then
    echo "phpMyAdmin installing."
    cd /tmp/
    wget http://jaist.dl.sourceforge.net/project/phpmyadmin/phpMyAdmin/4.1.1/phpMyAdmin-4.1.1-all-languages.tar.gz -O phpMyAdmin.tar.gz > /dev/null 2>&1
    tar zxf phpMyAdmin.tar.gz
    rm -f phpMyAdmin.tar.gz
    sudo mv  phpMyAdmin-4.1.1-all-languages/ /usr/share/phpMyAdmin
    sudo chown -R vagrant:apache /usr/share/phpMyAdmin/

    if [ ! -e "/etc/httpd/conf.d/phpMyAdmin.conf" ]; then
        sudo touch /etc/httpd/conf.d/phpMyAdmin.conf
        echo "Alias /phpMyAdmin /usr/share/phpMyAdmin/" | sudo tee -a /etc/httpd/conf.d/phpMyAdmin.conf > /dev/null 2>&1
        echo "" | sudo tee -a /etc/httpd/conf.d/phpMyAdmin.conf > /dev/null 2>&1
        echo "<Directory /usr/share/phpMyAdmin>" | sudo tee -a /etc/httpd/conf.d/phpMyAdmin.conf > /dev/null 2>&1
        echo "    Order Allow,Deny" | sudo tee -a /etc/httpd/conf.d/phpMyAdmin.conf > /dev/null 2>&1
        echo "    Allow from all" | sudo tee -a /etc/httpd/conf.d/phpMyAdmin.conf > /dev/null 2>&1
        echo "    AllowOverride all" | sudo tee -a /etc/httpd/conf.d/phpMyAdmin.conf > /dev/null 2>&1
        echo "</Directory>" | sudo tee -a /etc/httpd/conf.d/phpMyAdmin.conf > /dev/null 2>&1
    fi

    # copy config file.
    sudo cp /usr/share/phpMyAdmin/config.sample.inc.php /usr/share/phpMyAdmin/config.inc.php

    # SELunux
    #chcon system_u:object_r:httpd_sys_content_t:s0 /usr/share/phpMyAdmin/ -R

    echo "Completed phpMyAdmin installing."

    # restart the httpd.
    sudo /sbin/service httpd restart > /dev/null
    echo "Restart httpd."
fi

sudo /sbin/service iptables stop > /dev/null 2>&1
sudo chkconfig iptables off

sudo mv /etc/sysconfig/selinux /etc/sysconfig/selinux.bk
sudo sed -e "s/SELINUX=enforcing/SELINUX=disabled/g" /etc/sysconfig/selinux.bk > /etc/sysconfig/selinux


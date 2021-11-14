mySQL
---
- **Install**
```sh
pacman -Sy mysql phpmyadmin

mysql_install_db --user=mysql --basedir=/usr --datadir=/var/lib/mysql
systemctl start mysqld
mysql_secure_installation
# Change the root password?     >> Y
# Disallow root login remotely? >> n (for phpMyAdmin)

sed -i '/^;extension=iconv\|^;extension=mysqli\|^;extension=pdo_mysql/ s/^;//' /etc/php/php.ini
systemctl restart php-fpm
ln -s /usr/share/webapps/phpMyAdmin /srv/http/phpMyAdmin
```

- **phpMyAdmin**
    - URL: `IP_ADDRESS/phpMyAdmin`
    - Restore database:
        - Create database
        - Import

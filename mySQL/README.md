mySQL
---
- Install
```sh
pacman -Sy mysql phpmyadmin

sed -i '/^;extension=iconv\|^;extension=mysqli\|^;extension=pdo_mysql/ s/^;//' /etc/php/php.ini
systemctl restart php-fpm
ln -s /usr/share/webapps/phpMyAdmin /srv/http/phpMyAdmin
```
- Access: `IP_ADDRESS/phpMyAdmin`

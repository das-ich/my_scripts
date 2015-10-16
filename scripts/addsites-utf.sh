#!/bin/bash
#
#
#
#Переменные для создания пароля
MATRIX="0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
LENGTH="6"
#Памятка об использовании
usage()
{
echo "Использование: $0 имя_сайта_без_домена"
exit 1
}
if [ $# -eq 0 ]; then
    usage
fi
echo "Сей час мы будем все создавать для сайта $1!"
echo
echo
echo "Сейчас создастся каталог сайта $1:"
mkdir /work/apache-server/htdocs/www.$1.ru && echo "Каталог успешно создан!" || echo "Неудалось создать каталог"
echo
echo
echo "Сейчас добавится запись в конфиг апача:"
cp /etc/httpd/conf.d/eksmo.conf /etc/httpd/conf.d/eksmo.conf.bk
cat <<EOF >> /etc/httpd/conf.d/eksmo.conf
<VirtualHost *:80>
    ServerAdmin postmaster@eksmo.ru
    DocumentRoot /work/apache-server/htdocs/www.$1.ru
    ServerName $1.ru
    ServerAlias www.$1.ru www1.$1.ru
    AddDefaultCharset      windows-1251
    ErrorLog logs/www.$1.ru-error_log
    CustomLog logs/www.$1.ru-access_log combinied
</VirtualHost>
EOF
/etc/init.d/httpd restart && echo "Запись успешно создана!" || echo "Неудалось создать запись"
echo
echo
echo "Сейчас создастся база данных сайта $1:"
/work/mysql-server/bin/mysqladmin -pROOTpassword create www\_$1\_ru && echo "База успешно создана!" || echo "Неудалось создать базу"
echo
echo
#Создане пароля
while [ "${n:=1}" -le "$LENGTH" ]
do
	PASSWORD="$PASSWORD${MATRIX:$(($RANDOM%${#MATRIX})):1}"
	let n+=1
done
echo "Сейчас создаться пользователь базы данных:"
cat <<EOF > /tmp/$1.sql.tmp
GRANT all ON www_$1_ru.* to $1_ru_db@127.0.0.1 identified by "$PASSWORD";
GRANT all ON www_$1_ru.* to eksmohosting@127.0.0.1 identified by "$PASSWORD";
EOF
sed 's/-/_/g' /tmp/$1.sql.tmp > /tmp/$1.sql
/work/mysql-server/bin/mysql -pROOTpassword < /tmp/$1.sql && echo "Пользователь базы данных успешно создан!"
echo
echo
echo "Сейчас создастся ftp-пользователь сайта $1:"
cat <<EOF > /tmp/$1.sql
use proftpd_server;
select uid,gid from users;
EOF
/work/mysql-server/bin/mysql -pROOTpassword < /tmp/$1.sql
echo "Ввидите uid пользователя ftp-сервера, исходя из последнего существующего:"
read UIDFTP
echo "Ввидите gid пользователя ftp-сервера, исходя из последнего существующего:"
read GIDFTP
echo
cat <<EOF > /tmp/$1.sql
use proftpd_server;
insert into users set userid = 'www.$1.ru.ftp', passwd = '$PASSWORD', uid = '$UIDFTP', gid = '$GIDFTP', homedir = '/work/apache-server/htdocs/www.$1.ru', shell = '/sbin/nologin';
insert into groups set groupname = 'www.$1.ru.ftp', gid = '$GIDFTP';
EOF
/work/mysql-server/bin/mysql -pROOTpassword < /tmp/$1.sql && echo "Ftp-пользователь успешно создан!"
echo
echo
chown $UIDFTP:$GIDFTP /work/apache-server/htdocs/www.$1.ru
echo "База данных: www_$1_ru"
echo "Пользовтель базы данных: $1_ru_db"
echo "Пользовтель FTP: www.$1.ru.ftp"
echo "Пароль для данного сайта: $PASSWORD"
/bin/rm /tmp/$1.sql
echo
echo
echo "Не забудьте добавить запись в ДНС на серверах otherweb и mirror с помощью скрипта addsite-bind.sh!"
echo "Ну вот и все, малыш!"
exit 0

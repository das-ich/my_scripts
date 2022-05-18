# my_scripts and ansilble playbooks
### Скрипты написанные для работы

`LAMP-install.sh` - Установка LAMP на сервер из самосборочных пакетов

`addrecicl.sh` - автократическое добавление кассеты в список свободных на стриммере по событиям в логах

`addsite-to-bind.sh` - Добавление конфига домена в днс-сервер bind

`addsites-utf.sh` - Добавление сайта на web-сервере с созданием базы данных и создание пользователя ftp сервера

`big-webprob-utf.sh` Этот скрипт предназначен для проверки работоспособности основного сервера apache при работе в связке 2-х серверов.

`ff.sh` - автоматическое скачивание файлов со старой версии filefactory до jdownloaderа

`squid-serv-utm.sh` - установка squid - pptp из собственного репозитария и исходных текстов

`backup_mysql.sh` - бекап mysql средствами innobackupex, с отправкой письма в случаее сбоя

`set_snap.sh` и `check_snap.sh` проверка и в случаее отсутсвия, включение snapshot isolation в MS SQL и отправка сообщения боту в Telegram

### dialog

В папки лежит cli-интерфейс добавления номеров и телефонов на сервере с asterisk


### python

`zabbix_getsla_cycle.py` - получение SLA на службы из zabbix 4.4 - servises(услуги) и добавление этих данных в базу MS SQL

### ansible playbooks

Назначение playbooks понятно из названия

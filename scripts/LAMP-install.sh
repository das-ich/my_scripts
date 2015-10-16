#!/bin/bash
echo
echo "Этот скрипт установит на систему WEB-сервер с поддержкой PHP, PERL  и SSL, сервер баз данных и ДНС-сервер"
echo "Все сервера будут установлены в деректорию /work, а скрипты запуска будут находится в /etc/init.d/"
#echo "для запуска серверов во время загрузки системы необходимо будет запустить программу /usr/sbin/ntsysv"
#echo "и отредактировать парамтры загружаемых сервверов."
echo "После полной установки все сервисы будут загружатся автоматически."
echo -n "Для продолжения введите yes или no:"
while :
do
read ASK
case $ASK in
y|Y|yes|Yes)
    echo -n "Начинаем установку!!!"
    break
    ;;
n|N|no|No)
    echo "Ну как хотите. Выходим"
    exit 0
    ;;
*)
    echo -n "Введите yes или no:"
esac
done
echo
echo

echo -n "Прверка пользовательского ID... "
ID=`id -u`
if [ $ID != "0" ]; then
        echo "$ID -> Вы должны запустить $0 как  root!"
        exit 1
fi

echo $ID

echo -n "Прверка наличия \"g++\"... "
if g++ -v > /dev/null 2>&1; then
        echo "OK"
	else
        echo "Ошибка. Установите \"GNU C++ compiler\"!"
        exit 1
fi
			
echo -n "Проверка наличия \"make\"... "
if make -v > /dev/null 2>&1; then
        echo "OK"
	else
        echo "Ошибка. Установите \"GNU Make\"!"
        exit 1
fi

echo -n "Проверка наличия \"rpmbuild\"... "
if rpmbuild --help > /dev/null 2>&1; then
        echo "OK"
	else
        echo "Ошибка. Установите \"rpm-build\"!"
        exit 1
fi

echo -n "Проверка наличия \"perl\"... "
if perl -v > /dev/null 2>&1; then
        echo "OK"
	else
        echo "Ошибка. Установите \"perl\"!"
        exit 1
fi

echo -n "Проверка наличия \"perl-DBD-MySQL\"... "
if rpm -qa perl-DBD-MySQL > /dev/null 2>&1; then
        echo "OK"
	else
        echo "Ошибка. Установите \"perl-DBD-MySQL\" из дистрибутива!"
        exit 1
fi

mysql-install () {
echo
echo "Установка MySQL:"
echo

if [ -e /usr/lib/rpm/redhat/macros.orig ]; then
    rm /usr/lib/rpm/redhat/macros
    cp macros.mysql /usr/lib/rpm/redhat/macros
    else
    mv /usr/lib/rpm/redhat/macros /usr/lib/rpm/redhat/macros.orig
    cp macros.mysql /usr/lib/rpm/redhat/macros
fi

if rpmbuild --rebuild --target=i686 mysql-3.23.58-15.das.src.rpm >> /var/log/install_servers.log 2>&1; then
	if rpm -Uhv /usr/src/redhat/RPMS/i686/mysql-3.23.58-15.das.i686.rpm; then
	    echo
	    echo "MySQL установлен"
	else
	    echo "MySQL не установлен"
	    exit 1
	fi
	if rpm -Uhv /usr/src/redhat/RPMS/i686/mysql-devel-3.23.58-15.das.i686.rpm; then
	    echo
	    echo "MySQL-devel установлен"
	else
	    echo "MySQL-devel не установлен"
	    exit 1
	fi
	if rpm -Uhv /usr/src/redhat/RPMS/i686/mysql-server-3.23.58-15.das.i686.rpm && /sbin/chkconfig --add mysqld; then
	    echo
	    echo "MySQL-server установлен"
	else
	    echo "MySQL-server не установлен"
	    exit 1
	fi
    if [ -e /usr/lib/rpm/redhat/macros.orig ]; then
        rm /usr/lib/rpm/redhat/macros
	mv /usr/lib/rpm/redhat/macros.orig /usr/lib/rpm/redhat/macros
    fi
else
	echo "Не удалсь собрать пакет \"mysql-3.23.58-15.das.src.rpm\". Смотрите /var/log/install_servers.log "
	exit 1
fi
}

zavis-install () {
echo
echo "Установка необходимых зависимостей"
echo

if [ -e /usr/lib/rpm/redhat/macros.orig ]; then
    rm /usr/lib/rpm/redhat/macros
    mv /usr/lib/rpm/redhat/macros.orig /usr/lib/rpm/redhat/macros
fi

echo "Установка perl-BSD-Resource:"
echo
if rpmbuild --rebuild --target=i686 perl-BSD-Resource-1.24-3.das.src.rpm > /var/log/install_servers.log 2>&1; then
	if rpm -Uhv --nodeps /usr/src/redhat/RPMS/i686/perl-BSD-Resource-1.24-3.das.i686.rpm; then
	    echo
	    echo "perl-BSD-Resource установлен"
	else
	    echo "perl-BSD-Resource не установлен"
	    exit 1
	fi
else
	echo "Не удалсь собрать пакет \"perl-BSD-Resource-1.24-3.das.src.rpm\". Смотрите /var/log/install_servers.log "
	exit 1
fi

echo
echo "Установка perl-Devel-Symdump:"
echo
if rpmbuild --rebuild --target=i686 perl-Devel-Symdump-2.03-23.das.src.rpm >> /var/log/install_servers.log 2>&1; then
	if rpm -Uhv --nodeps /usr/src/redhat/RPMS/noarch/perl-Devel-Symdump-2.03-23.das.noarch.rpm; then
	    echo
	    echo "perl-Devel-Symdump установлен"
	else
	    echo "perl-Devel-Symdump не установлен"
	    exit 1
	fi
else
	echo "Не удалсь собрать пакет \"perl-BSD-Resource-1.24-3.das.src.rpm\". Смотрите /var/log/install_servers.log "
	exit 1
fi

echo
echo "Установка новой версии OpenSSL:"
echo
if rpmbuild --rebuild --target=i686 openssl-0.9.7d-1.das.src.rpm >> /var/log/install_servers.log 2>&1; then
	if rpm -Uhv --force --nodeps /usr/src/redhat/RPMS/i686/openssl-0.9.7d-1.das.i686.rpm; then
	    echo
	    echo "OpenSSL установлен"
	else
	    echo "OpenSSL не установлен"
	    exit 1
	fi
	if rpm -Uhv --force --nodeps /usr/src/redhat/RPMS/i686/openssl-devel-0.9.7d-1.das.i686.rpm; then
	    echo
	    echo "OpenSSL-devel установлен"
	else
	    echo "OpenSSL-devel не установлен"
	    exit 1
	fi
else
	echo "Не удалсь собрать пакет \"openssl-0.9.7d-1.das.src.rpm\". Смотрите /var/log/install_servers.log "
	exit 1
fi
echo
echo "Установка библиотеки MM:"
echo
if rpmbuild --rebuild --target=i686 mm-1.3.1-3.das.src.rpm >> /var/log/install_servers.log 2>&1; then
	if rpm -Uhv /usr/src/redhat/RPMS/i686/mm-1.3.1-3.das.i686.rpm; then
	    echo
	    echo "MM установлен"
	else
	    echo "MM не установлен"
	    exit 1
	fi
	if rpm -Uhv /usr/src/redhat/RPMS/i686/mm-devel-1.3.1-3.das.i686.rpm; then
	    echo
	    echo "MM-devel установлен"
	else
	    echo "MM-devel не установлен"
	    exit 1
	fi
else
	echo "Не удалсь собрать пакет \"mm-1.3.1-3.das.src.rpm\". Смотрите /var/log/install_servers.log "
	exit 1
fi
}

apache-install () {
echo
echo "Установка WEB-сервера:"
echo

if [ -e /usr/lib/rpm/redhat/macros.orig ]; then
        rm /usr/lib/rpm/redhat/macros
	cp macros.apache /usr/lib/rpm/redhat/macros
    else
	mv /usr/lib/rpm/redhat/macros /usr/lib/rpm/redhat/macros.orig
	cp macros.apache /usr/lib/rpm/redhat/macros
fi

if rpmbuild --rebuild --target=i686 apache-1.3.33-2.3.dasPHP.src.rpm >> /var/log/install_servers.log 2>&1; then
    	if rpm -Uhv /usr/src/redhat/RPMS/i686/apache-1.3.33-2.3.dasPHP.i686.rpm && /sbin/chkconfig --add httpd; then
	    echo
	    echo "Apache установлен"
	else
	    echo "Apache не установлен"
	    exit 1
	fi
	if rpm -Uhv /usr/src/redhat/RPMS/i686/apache-devel-1.3.33-2.3.dasPHP.i686.rpm; then
	    echo
	    echo "Apache-devel установлен"
	else
	    echo "Apache-devel не установлен"
	    exit 1
	fi
else
	echo "Не удалсь собрать пакет \"apache-1.3.33-2.3.dasPHP.src.rpm\". Смотрите /var/log/install_servers.log "
	exit 1
fi
}

echo "Что вы желаете установить? (для установки MySQL введите \"mysql\", для установки apache введите \"apache\"),"
echo -n "для установки всех пакетов введите \"all\" или \"q\" для прерывания установки и выхода в оболочку": 
while :
do
read INST
case $INST in

mysql)
mysql-install
break
;;

apache)
zavis-install
apache-install
break
;;

all)
echo "Установка всех пакетов"
mysql-install
zavis-install
apache-install
break
;;

q|Q)
    echo "Ну что ж, выходим."
    exit 0
    ;;
*)
    echo -n "Введите правильные параметры:"
    ;;
esac
done

echo
echo -n "Вы желаете установить ДНС-сервер? \(yes или no\):"
read BIND
case $BIND in
y|Y|yes|Yes)
    echo -n "Начинаем установку!!!"
    echo "ПОКА УСТАНОВКА BIND НЕ РЕАЛИЗОВАНА"
    ;;
n|N|no|No)
    echo "Ну как хотите. Выходим"
    exit 0
    ;;
*)
    echo "В следующий раз введите yes или no"
    exit 1
esac
echo
rm /usr/lib/rpm/redhat/macros 
mv /usr/lib/rpm/redhat/macros.orig /usr/lib/rpm/redhat/macros
echo -n "Все установлено"
exit 0

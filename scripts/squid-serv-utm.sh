#/bin/bash
echo "Этот скрипт установит squid, sarg на ваш сервер"
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

echo -n "Проверка наличия \"make\"... "
if make -v > /dev/null 2>&1; then
        echo "OK"
        else
        echo "Ошибка. Установите \"GNU Make\"!"
        exit 1
fi

echo -n "Проверка наличия \"rpm\"... "
if rpm --help > /dev/null 2>&1; then
        echo "OK"
        else
        echo "Ошибка. Ваш дистрибутив не является Red-hat совместимым!"
        exit 1
fi


echo
echo "Установка yum, pptp и sarg:"
echo

echo "Выполняется провека зависимотей перед установкой пакетов."
echo "В случае обноружения недостоющих зависимостей, кроме squid,"
echo "рекомендуется прервать скрипт нажав Control+C и установить требуемые зависимомти:"
rpm -ihv --test *.rpm
echo
echo
echo "Теперь начинается установка пакетов"
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
if rpm -Uhv libradiusclient-0.3.1-0.20030925asp.i386.rpm ppp-2.4.3-4.rhel3.i386.rpm libxml2-python-2.5.10-5.i386.rpm yum-2.1.0cvs-5.1asp.noarch.rpm && rpm -Uhv --force pptpd-1.2.3-1.das.i686.rpm && rpm -Uhv --nodeps sarg-2.0.9-2.fc2.mack.i686.rpm && rpm -ihv --nodeps kernel-smp-2.4.20-8.i686.rpm; then
	echo "Пакеты установлены, теперь начнем установку squid:"
	else
	"Ошибка. Что-то не встало проверьте уписок установленных пакетов и установите не установленные в ручную."
#	exit 1
fi

echo
echo
echo "Для продолжения установки squid нажмите ENTER "
echo 
read cont < /dev/tty

if cd src/squid-2.5.STABLE11; then
		if make install; then
		echo "squid установлен"
		else 
		echo "Что-то пошло не так попробуйте установить squid руками."
		fi
	else
	echo "Нет каталога с исходниками. Попробуйте найти его и установить squid руками"
	
fi
echo
echo "Установка ndsad для сбора статистики пользователя:"
echo "Для продолжения установки ndsad нажмите ENTER "
echo 
read cont < /dev/tty

if cd ../../ndsad; then
    cp ndsad /usr/local/sbin && echo "ndsad установлен"
    else
    echo "не смог перейти в каталог с ndsad, проверьте пути."
fi
echo
echo
echo "Для продолжения установки конфигов нажмите ENTER "
echo 
read cont < /dev/tty
echo -n "Установка готовых конфигов:"

if cd ../; then
    cp -Rb etc / && echo "		OK" || echo "Упс"
    else
    echo "Несмог перейти в каталог" 
    exit 1
fi
echo 
echo -n "Создание пользователя для работы squid:"
/usr/sbin/useradd -d /var/squid/ -M -s /sbin/nologin -c "Squid proxy server" squid && chown -R squid:squid /var/squid/ && echo "		OK" || echo "Упс"
echo
echo -n "Загрузка модуля wccp:"
/sbin/modprobe ip_wccp && echo "		OK" || echo "Упс"
echo
echo -n "Настройка iptables:"
/sbin/iptables -t nat -A PREROUTING -p tcp --dport 80 -j REDIRECT --to-ports 3128 && echo "Не забудте добавить это правило firewall: iptables -t nat -A POSTROUTING -s 172.19.1.0/255.255.255.0 -o eth0 -j SNAT --to-source 172.19.0.244 только измените ip-адреса и выполните service iptables save."
echo
echo
echo -n  "Добавим к загрузке по-умолчанию установленные сервисы squid, apache, pptpd, ndsad:"
chkconfig --add ndsad && chkconfig --add squid && chkconfig --add httpd && chkconfig --add pptpd && echo "		OK"


echo "Теперь можете поправить конфиг grub для загрузки по-умолчанию с установленного ядра, конфиги squid, apache, pptpd и перезагрузить машину."
exit 0

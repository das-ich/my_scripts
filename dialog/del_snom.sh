#!/bin/sh
DIALOG=${DIALOG=dialog}
tempfile=`tempfile 2>/dev/null` || tempfile=/tmp/test$$
trap "rm -f $tempfile" 0 1 2 5 15
 
$DIALOG --title "Удаление номера SNOM" --clear \
	--inputbox "Введите MAC телефона который надо удалить:" 10 51 2> $tempfile
 
retval=$?
 
case $retval in
  0)
#    echo "Вы ввели `cat $tempfile`"
		mcedit /etc/asterisk/SipUsers/snoms.conf
               find /var/lib/tftpboot -name *`cat $tempfile`* -exec rm {} \;
	       ./aster_menu.sh
    ;;
  1)
#    echo "Отказ от ввода."
    ./aster_menu.sh
    ;;
  255)
    if test -s $tempfile ; then
      cat $tempfile
    else
#      echo "Нажата клавиша ESC."
	./aster_menu.sh
    fi
    ;;
esac


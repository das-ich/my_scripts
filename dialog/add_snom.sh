#!/bin/sh
DIALOG=${DIALOG=dialog}
tempfile=`tempfile 2>/dev/null` || tempfile=/tmp/test$$
trap "rm -f $tempfile" 0 1 2 5 15
 
$DIALOG --title "Добавление нового номера SNOM" --clear \
	--inputbox "Введите через пробел 'MAC телефона номер контекст (local#)':" 10 51 2> $tempfile
 
retval=$?
 
case $retval in
  0)
#    echo "Вы ввели `cat $tempfile`"
	 /usr/local/sbin/new_snom.sh `cat $tempfile` && ./aster_menu.sh || echo "телефон не добавлен"
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


#!/bin/bash
cmd=(dialog --keep-tite --menu "Что нужно сделать:" 12 50 16)

options=(1 "Добавление нового номера SNOM"
         2 "Добавление или удаление softphone"
         3 "Удаление номера SNOM"
         4 "Перезагрузка sip"
	 5 "Выход")

choices=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)

for choice in $choices
do
    case $choice in
        1)
		./add_snom.sh
            ;;
        2)
		mcedit /etc/asterisk/SipUsers/soft_pfones_1.conf
		./aster_menu.sh
            ;;
        3)
            dialog --msgbox  "Удаление пока не реализовано" 5 40
#	    ./del_snom.sh
	    ./aster_menu.sh
            ;;
        4)
		sudo asterisk -rx "sip reload"
		./aster_menu.sh
            ;;
	5)
		clear
		exit 0
	    ;;
    esac
done


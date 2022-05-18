#!/bin/bash
cmd=(dialog --keep-tite --menu "Что нужно сделать:" 16 77 16)

options=(1 "Добавление нового номера SNOM"
         2 "Добавление или удаление, а так же проверка группы доступа softphone"
	 3 "Проверка переадресации"
         4 "Удаление номера SNOM"
	 5 "Удаление переадресации"
	 6 "Проверка группы доступа на SNOM"
	 7 "Изменение группы доступа на SNOM"
         8 "Перезагрузка sip"
	 9 "Выход")

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
		./show_redirect.sh
		./aster_menu.sh
	    ;;
        4)
#            dialog --msgbox  "Удаление пока не реализовано" 5 40
	 	./del_snom.sh
	    	./aster_menu.sh
            ;;
	5)
		./del_redirect.sh
		./aster_menu.sh
	    ;;
	6)	./show_context.sh
		./aster_menu.sh
	    ;;
	7)
		./change_context.sh
		./aster_menu.sh
	    ;;	
        8)
		sudo asterisk -rx "sip reload"
		./aster_menu.sh
            ;;
	9)
#		clear
#		exit 0
		logout
	    ;;
    esac
done


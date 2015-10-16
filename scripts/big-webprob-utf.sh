#!/bin/bash
#
#
#Этот скрипт преднозначен для проверки работоспособности основного сервера apache 
#при работе в связке 2-х серверов.
#Лицензия GNU GPL
#CopyLeft das-ich<das-ich@yandex.ru>
#
#Переходим в рабочий каталог
cd /work/apache-server/conf
#Определяем доступен ли хост
if httping -h ip.add.re.ss -p 80 -c 3 -t 2 -s > /dev/null 2>&1
    then
#Если доступен то проверяем был ли ранее хост недоступен и сохранялся ли  оригинальный конфиг apache
	if [ -e httpd.conf.orig ]
#Если конфиг был сохранен ранее то возвращаем оригинальный конфиг и пререзагружаем apache для работы в обычном режиме
	    then
    	      /bin/mv httpd.conf.orig httpd.conf
      	      /work/apache-server/bin/apachectl restart
    	      echo "Сервер apache работает в нормальном режиме"; exit 0
	    else 
#Если хост доступен и конфиг не сохранался то просто завершаем работу
#		echo "all ping allow and server not needed modified"	    
		exit 0
	fi
    else
#Если же хост недоступен то проверяем наличие сохраненного оригинального конфига
	if [ -e httpd.conf.orig ]
	    then
#Если оригинальный конфиг был сохранен ранне то просто выходим
#	      echo "file httpd.conf.orig in use"
    	      exit 0
#Если же оригиналный конфиг не сохранался то сохраняем его
	    else 
    	      /bin/cp httpd.conf httpd.conf.orig
#    	      echo "create httpd.conf.orig"
	fi
#После сохранения оригиналного конфига используем его для создания измененного
#конфига и перезагружаем apache для работы без использования основного сервера

	    if [ -e httpd.conf.orig ]
	        then 
	          /bin/sed -e s/www1/www2/ >httpd.conf <httpd.conf.orig
#	          echo "new file httpd.conf created and apache restarted"
	          /work/apache-server/bin/apachectl restart      
	        else 
	          echo "o-ops... nofing to do"
	    fi
fi
echo "Сервер apache работает в single режиме"
exit 0

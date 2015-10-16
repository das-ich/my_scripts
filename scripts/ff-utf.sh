#!/bin/bash

for params
do
#Скачаем первую страницу.
/usr/bin/wget -O /tmp/index.html $params
#Достанем из текста имя файла
FILE_NAME=`sed -n -e 's/<br \/>//g' -e /'File Name:'/p /tmp/index.html | sed -e 's/File Name: //g'`
#Достаем из текста ссылку для продолжения
LINK=`sed -n /'Download for free with'/p /tmp/index.html | awk '{print $2}' | sed -e 's/href="//g' -e 's/"><strong>Download//g'`
#Качаем следующую страницу для получения ссылки
/usr/bin/wget -O /tmp/index.html http://www.filefactory.com$LINK
#Достаем из текста ссылку для продолжения
LINK=`sed -n /'Click here to begin your download<\/strong>'/p /tmp/index.html | awk '{print $2}' | sed -e 's/href="//g' -e 's/"><strong>Click//g'`
#качаем архив
echo "Качаем архив $FILE_NAME"
/usr/bin/wget -O "$FILE_NAME" $LINK
done
rm /tmp/index.html
echo "THE END"
exit 0

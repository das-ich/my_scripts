OA#!/bin/bash
#


#connection to sql02
checkbase_sql02 () {
#check sql server connection
sqlcmd -S 1csql02 -U sqluser -P \$passoword -Q "select getdate()" > /tmp/testsqlconn02
testconn=`stat -c %s /tmp/testsqlconn02`
if [ $testconn -eq 0 ]
then
	echo "connection to sql02 problem" >> /tmp/bot_talk
	rm /tmp/testsqlconn02
else


sqlcmd -S 1csql02 -U sqluser -P \$passoword -W -Q "Select snapshot_isolation_state, is_read_committed_snapshot_on, name from sys.databases where name like 'base1' or name like 'base2' or name like 'base3' or name like 'base4' or name like 'base5' or name like 'base6' or name like 'base7'" > /tmp/sqlout02
egrep 0 /tmp/sqlout02 > /tmp/grepsqlout02
size=`stat -c %s /tmp/grepsqlout02`
if [ $size -eq 0 ]
then
	echo "base on sql02 in the normal state" >> /tmp/bot_talk
	rm /tmp/grepsqlout02
	rm /tmp/sqlout02
	rm /tmp/testsqlconn02

else

for base in $(awk '{ print $3 }' /tmp/grepsqlout02)
do
sqlcmd -S 1csql02 -U sqluser -P \$passoword -Q "ALTER DATABASE $base SET SINGLE_USER WITH ROLLBACK IMMEDIATE; ALTER DATABASE $base SET READ_COMMITTED_SNAPSHOT ON; ALTER DATABASE $base SET MULTI_USER WITH ROLLBACK IMMEDIATE"
	echo "$base <code>была возможно исправлена</code>" >> /tmp/bot_talk
done
rm /tmp/grepsqlout02
rm /tmp/sqlout02
rm /tmp/testsqlconn02

fi

fi
}

#connection to sql01
checkbase_sql01 () {
#check sql server connection
sqlcmd -S 1csql01 -U sqluser -P \$passoword -Q "select getdate()" > /tmp/testsqlconn01
testconn=`stat -c %s /tmp/testsqlconn01`
if [ $testconn -eq 0 ]
then
	echo "connection to sql01 problem" >> /tmp/bot_talk
	rm /tmp/testsqlconn01
else


sqlcmd -S 1csql01 -U sqluser -P \$passoword -W -Q "Select snapshot_isolation_state, is_read_committed_snapshot_on, name from sys.databases where name like 'base8' or name like 'base9' or name like 'base10' or name like 'base11'" > /tmp/sqlout01
egrep 0 /tmp/sqlout01 > /tmp/grepsqlout01
size=`stat -c %s /tmp/grepsqlout01`
if [ $size -eq 0 ]
then
	echo "base on sql01 in the normal state" >> /tmp/bot_talk
	rm /tmp/grepsqlout01
	rm /tmp/sqlout01
	rm /tmp/testsqlconn01

else

for base in $(awk '{ print $3 }' /tmp/grepsqlout01)
do
sqlcmd -S 1csql01 -U sqluser -P \$passoword -Q "ALTER DATABASE $base SET SINGLE_USER WITH ROLLBACK IMMEDIATE; ALTER DATABASE $base SET READ_COMMITTED_SNAPSHOT ON; ALTER DATABASE $base SET MULTI_USER WITH ROLLBACK IMMEDIATE"
	echo "$base <code>была возможно исправлена</code>" >> /tmp/bot_talk
done
rm /tmp/grepsqlout01
rm /tmp/sqlout01
rm /tmp/testsqlconn01
fi


fi
}


#connection to co-1cregl01
checkbase_co-1cregl01 () {
#check sql server connection
sqlcmd -S co-1cregl01 -U sqluser -P \$passoword -Q "select getdate()" > /tmp/testsqlconn03
testconn=`stat -c %s /tmp/testsqlconn03`
if [ $testconn -eq 0 ]
then
	echo "connection to co-1cregl01 problem" >> /tmp/bot_talk
	rm /tmp/testsqlconn03
else


sqlcmd -S co-1cregl01 -U sqluser -P \$passoword -W -Q "Select snapshot_isolation_state, is_read_committed_snapshot_on, name from sys.databases where name like 'base12'" > /tmp/sqlout03
egrep 0 /tmp/sqlout03 > /tmp/grepsqlout03
size=`stat -c %s /tmp/grepsqlout03`
if [ $size -eq 0 ]
then
	echo "base on co-1cregl01 in the normal state" >> /tmp/bot_talk
	rm /tmp/grepsqlout03
	rm /tmp/sqlout03
	rm /tmp/testsqlconn03

else

for base in $(awk '{ print $3 }' /tmp/grepsqlout03)
do
sqlcmd -S co-1cregl01 -U sqluser -P \$passoword -Q "ALTER DATABASE $base SET SINGLE_USER WITH ROLLBACK IMMEDIATE; ALTER DATABASE $base SET READ_COMMITTED_SNAPSHOT ON; ALTER DATABASE $base SET MULTI_USER WITH ROLLBACK IMMEDIATE"
	echo "$base <code>была возможно исправлена</code>" >> /tmp/bot_talk
done
rm /tmp/grepsqlout03
rm /tmp/sqlout03
rm /tmp/testsqlconn03

fi

fi
}


#connection to sql021
checkbase_w-srvsql021 () {
#check sql server connection
sqlcmd -S sql021 -U sqluser -P \$passoword -Q "select getdate()" > /tmp/testsqlconn04
testconn=`stat -c %s /tmp/testsqlconn04`
if [ $testconn -eq 0 ]
then
	echo "connection to sql021 problem" >> /tmp/bot_talk
	rm /tmp/testsqlconn04
else


sqlcmd -S sql021 -U sqluser -P \$passoword -W -Q "Select snapshot_isolation_state, is_read_committed_snapshot_on, name from sys.databases where name like 'base13'" > /tmp/sqlout04
egrep 0 /tmp/sqlout04 > /tmp/grepsqlout04
size=`stat -c %s /tmp/grepsqlout04`
if [ $size -eq 0 ]
then
	echo "base on sql021 in the normal state" >> /tmp/bot_talk
	rm /tmp/grepsqlout04
	rm /tmp/sqlout04
	rm /tmp/testsqlconn04

else

for base in $(awk '{ print $3 }' /tmp/grepsqlout04)
do
	echo "$base <code>была возможно исправлена</code>" >> /tmp/bot_talk
done
rm /tmp/grepsqlout04
rm /tmp/sqlout04
rm /tmp/testsqlconn04

fi

fi
}


curl -s --proxy 10.0.0.1:8118 -X GET "https://api.telegram.org/bot1234567:AAGRAwHY4DeQS-Pgu6n6eQSXKtRudqGN14s/getUpdates" >> /tmp/updtesbot
grep -iq SUPERTEST /tmp/updtesbot
mess=`echo "$?"`
if [ "$mess" -eq 0 ]; 
 then 
#	 echo "есть сообщение"
        checkbase_sql02
	checkbase_sql01
	checkbase_co-1cregl01
	checkbase_sql021
 else
#	 echo "нет задачи"
	 rm /tmp/updtesbot
	 exit 0
fi

sed -i '
ПОПЫТКА ИСПРАВИТЬ is_read_committed_snapshot_on В БАЗАХ:' /tmp/bot_talk
echo "Проверка баз будет запущена автоматически и отчет придет следующим сообщением" >> /tmp/bot_talk
statistic=`cat /tmp/bot_talk`
curl -s --proxy 10.0.0.82:8118 -F chat_id="1234567" -F text="$statistic" -F parse_mode="HTML" "https://api.telegram.org/bot12345678:AAGRAwHY4DeQS-Pgu6n6eQSXKtRudqGN14s/sendMessage"

rm /tmp/bot_talk

rm /tmp/updtesbot
./check_snap.sh
exit 0


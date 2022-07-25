#!/bin/bash
#
#
rm /tmp/bot_talk

#connection to sql02
checkbase_sql02 () {
#check sql server connection
/usr/local/bin/sqlcmd -S sql01v -U DBuser -P \$password -Q "select getdate()" > /tmp/testsqlconn02
testconn=`stat -c %s /tmp/testsqlconn02`
if [ $testconn -eq 0 ]
then
	echo "connection to sql01v problem" >> /tmp/bot_talk
	rm /tmp/testsqlconn02
else


/usr/local/bin/sqlcmd -S sql01v -U DBuser -P \$password -W -Q "Select snapshot_isolation_state, is_read_committed_snapshot_on, name from sys.databases where name like 'base1' or name like 'base2' or name like 'base3' or name like 'base4' or name like 'base5' or name like 'base6' or name like 'base7'" > /tmp/sqlout02
egrep 0 /tmp/sqlout02 > /tmp/grepsqlout02
size=`stat -c %s /tmp/grepsqlout02`
if [ $size -eq 0 ]
then
	#echo "base on sql01v in the normal state" >> /tmp/bot_talk
	rm /tmp/grepsqlout02
	rm /tmp/sqlout02
	rm /tmp/testsqlconn02

else

for base in $(awk '{ print $3 }' /tmp/grepsqlout02)
do
	echo "$base <code>!!!in the bad state!!!</code>" >> /tmp/bot_talk
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
/usr/local/bin/sqlcmd -S sql03v -U DBuser -P \$password -Q "select getdate()" > /tmp/testsqlconn01
testconn=`stat -c %s /tmp/testsqlconn01`
if [ $testconn -eq 0 ]
then
	echo "connection to sql03v problem" >> /tmp/bot_talk
	rm /tmp/testsqlconn01
else


/usr/local/bin/sqlcmd -S sql03v -U DBuser -P \$password -W -Q "Select snapshot_isolation_state, is_read_committed_snapshot_on, name from sys.databases where name like 'base1' or name like 'base2' or name like 'base3' or name like 'base4' or name like 'base5'" > /tmp/sqlout01
egrep 0 /tmp/sqlout01 > /tmp/grepsqlout01
size=`stat -c %s /tmp/grepsqlout01`
if [ $size -eq 0 ]
then
	rm /tmp/grepsqlout01
	rm /tmp/sqlout01
	rm /tmp/testsqlconn01

else

for base in $(awk '{ print $3 }' /tmp/grepsqlout01)
do
	echo "$base <code>!!!in the bad state!!!</code>" >> /tmp/bot_talk
done
rm /tmp/grepsqlout01
rm /tmp/sqlout01
rm /tmp/testsqlconn01
fi


fi
}


#connection to co-1cregl01
checkbase_regl01 () {
#check sql server connection
/usr/local/bin/sqlcmd -S sql02v -U DBuser -P \$password -Q "select getdate()" > /tmp/testsqlconn03
testconn=`stat -c %s /tmp/testsqlconn03`
if [ $testconn -eq 0 ]
then
	echo "connection to sql02v problem" >> /tmp/bot_talk
	rm /tmp/testsqlconn03
else


/usr/local/bin/sqlcmd -S sql01v -U DBuser -P \$password -W -Q "Select snapshot_isolation_state, is_read_committed_snapshot_on, name from sys.databases where name like 'base1'" > /tmp/sqlout03
egrep 0 /tmp/sqlout03 > /tmp/grepsqlout03
size=`stat -c %s /tmp/grepsqlout03`
if [ $size -eq 0 ]
then
#	echo "base on sql01v in the normal state" >> /tmp/bot_talk
	rm /tmp/grepsqlout03
	rm /tmp/sqlout03
	rm /tmp/testsqlconn03

else

for base in $(awk '{ print $3 }' /tmp/grepsqlout03)
do
	echo "$base <code>!!!in the bad state!!!</code>" >> /tmp/bot_talk
done
rm /tmp/grepsqlout03
rm /tmp/sqlout03
rm /tmp/testsqlconn03

fi

fi
}


#connection to sql021
checkbase_sql021 () {
#check sql server connection
/usr/local/bin/sqlcmd -S sql021 -U DBuser -P \$password -Q "select getdate()" > /tmp/testsqlconn04
testconn=`stat -c %s /tmp/testsqlconn04`
if [ $testconn -eq 0 ]
then
	echo "connection to sql021 problem" >> /tmp/bot_talk
	rm /tmp/testsqlconn04
else


/usr/local/bin/sqlcmd -S sql021 -U DBuser -P \$password -W -Q "Select snapshot_isolation_state, is_read_committed_snapshot_on, name from sys.databases where name like 'base1'" > /tmp/sqlout04
egrep 0 /tmp/sqlout04 > /tmp/grepsqlout04
size=`stat -c %s /tmp/grepsqlout04`
if [ $size -eq 0 ]
then
	rm /tmp/grepsqlout04
	rm /tmp/sqlout04
	rm /tmp/testsqlconn04

else

for base in $(awk '{ print $3 }' /tmp/grepsqlout04)
do
	echo "$base <code>!!!in the bad state!!!</code>" >> /tmp/bot_talk
done
rm /tmp/grepsqlout04
rm /tmp/sqlout04
rm /tmp/testsqlconn04

fi

fi
}

checkbase_sql02
checkbase_sql01
checkbase_regl01
checkbase_sql021

sed -i '1i Проверка состояния is_read_committed_snapshot_on в базах:' /tmp/bot_talk

statistic=`cat /tmp/bot_talk`
egrep "bad state" /tmp/bot_talk 1>&2 > /dev/null && curl -s -F chat_id="-12345678" -F sticker="CAADAgADMAMAAs-71A7ho5cmkEnrxgI" -F parse_mode="HTML" "https://api.telegram.org/bot12345678:AAGRAwHY4DeQS-Pgu6n6eQ/sendSticker"
curl -s -F chat_id="-12345678" -F text="$statistic" -F parse_mode="HTML" "https://api.telegram.org/bot12345678:AAGRAwHY4DeQS-Pgu6n6eQ/sendMessage"

rm /tmp/bot_talk
exit 0


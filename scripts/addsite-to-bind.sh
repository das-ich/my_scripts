#!/bin/bash
#
#
#Памятка об использовании
usage()
{
echo "Использование: $0 имя_сайта_без_домена"
exit 1
}
if [ $# -eq 0 ]; then
    usage
fi

#Добовление сведений о домене
mv /var/named/chroot/etc/named.conf /var/named/chroot/etc/named.conf.old
sed '$i \
zone "'$1'.ru" { \
        type master; \
        file "data/'$1'.ru"; \
        allow-update { none; }; \
};' /var/named/chroot/etc/named.conf.old > /var/named/chroot/etc/named.conf

#Добовление файла домена
cat <<EOF > /var/named/chroot/var/named/data/$1.ru
\$ORIGIN .
\$TTL 3600       ; 1 hour
$1.ru       IN SOA  ns1.$1.ru. postmaster.$1.ru. (
                                `date +%Y%m%d`01 ; serial
                                21600      ; refresh (6 hours)
                                900        ; retry (15 minutes)
                                1209600    ; expire (2 weeks)
                                86400      ; minimum (1 day)
                                )
\$TTL 172800     ; 2 days
                        NS      ns1.$1.ru.
                        NS      ns2.$1.ru.
\$TTL 86400      ; 1 day
                        A       195.8.102.46
\$TTL 172800     ; 2 days
                        MX      10 mail.$1.ru.
\$ORIGIN $1.ru.
ns1                     A       195.8.102.47
ns2                     A       81.176.67.150
\$TTL 86400      ; 1 day
www                     A       195.8.102.46
EOF
#Перезагрузка DNS
/etc/init.d/named restart

echo "Домен успешно добавлен"
exit 0

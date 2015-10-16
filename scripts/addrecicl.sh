#!/bin/bash
#
#function
export PATH=/usr/sbin:/usr/bin:/usr/ccs/bin:/usr/openwin/bin:/usr/dt/bin:/usr/platform/SUNW,Sun-Fire-V240/sbin:/opt/sun/bin:/opt/SUNWvts/bin:/usr/bin/nsr:/usr/sbin/nsr:/opt/SUNWexplo/bin:/opt/CTEact/bin:/opt/SUNWcest/bin:/opt/rsc/bin
export LANG=C
add_p00 () {
#samaya rannya data
ERDATE=`mminfo -vm -q pool=P00|awk '{ print $5 }'|sort -t //  -k 3,3n -k 1,1n|sed '/full/d'|sed '/read/d'|head -1`
#kolichestvo diskov s etoy datoy
NUMDISK=`mminfo -vm -q pool=P00|grep $ERDATE |wc -l`
if [ $NUMDISK != 1 ]; then
#esli kaset bolshe odnoy 
	VOLID1=`mminfo -vm -q pool=P00|grep $ERDATE|awk '{ print $11 }'|head -1`
#	VOLID2=`mminfo -vm -q pool=P00|grep $ERDATE|awk '{ print $11 }'|tail -1`
	nsrmm -V $VOLID1 -o recyclable -y
#	nsrmm -V $VOLID2 -o recyclable -y
	echo "dobavlenie 1 diskov P00 iz dvuh vozmozhnyh"
	else
#esli kaseta odna
	VOLID=`mminfo -vm -q pool=P00|grep $ERDATE|awk '{ print $11 }'`
	nsrmm -V $VOLID -o recyclable -y
	echo "dobavlenie 1 diskov P00"
	echo $VOLID
fi
}

add_prd () {
#samaya rannya data
ERDATE=`mminfo -vm -q pool="PRD disk"|awk '{ print $5 }'|sort -t //  -k 3,3n -k 1,1n|sed '/full/d'|sed '/read/d'|head -1`
#kolichestvo diskov s etoy datoy
NUMDISK=`mminfo -vm -q pool="PRD disk"|grep $ERDATE |wc -l`
if [ $NUMDISK != 1 ]; then
#esli kaset bolshe odnoy
        VOLID1=`mminfo -vm -q pool="PRD disk"|grep $ERDATE|awk '{ print $11 }'|head -1`
#        VOLID2=`mminfo -vm -q pool="PRD disk"|grep $ERDATE|awk '{ print $11 }'|tail -1`
	echo "dobavlenie 2 diskov PRD"
#	echo $VOLID1
	echo $VOLID2
       nsrmm -V $VOLID1 -o recyclable -y
#       nsrmm -V $VOLID2 -o recyclable -y
        else
#esli kaseta odna
        VOLID=`mminfo -vm -q pool="PRD disk"|grep $ERDATE|awk '{ print $11 }'`
       nsrmm -V $VOLID -o recyclable -y
	echo "dobavlenie 1 diskov PRD"
	echo $VOLID
fi
}

#proverka predyduschego vypolneniya
if tail -2 /nsr/logs/summary |grep DISK_ADDED > /dev/null 2>&1
then
#	echo "DISK ADDED v proshly raz"  
	exit 0
else

#parsing loga
if tail  -2 /nsr/logs/summary|grep critical|grep P00 > /dev/null 2>&1
then
	add_p00
	echo DISK_ADDED >> /nsr/logs/summary
fi

if tail  -2 /nsr/logs/summary|grep critical|grep PRD > /dev/null 2>&1
then
	add_prd
	echo DISK_ADDED >> /nsr/logs/summary
fi
#dobavlenie stroki o tom chto disk dobavlen
#echo DISK_ADDED >> /nsr/logs/summary
fi

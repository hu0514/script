#!/bin/bash
logdir=/mnt
yesterday=`date +"%Y-%m-%d" -d "-1 days"`
log=`find $logdir -name "*.${yesterday}.log"`
#echo $log
if [[ -n $log ]];then
	cat $log |grep -B3 'Out Of Memory Quota\!'|sed ':a;N;$!ba;s/\n/\[huanhangfu\]/g'|sed -e 's/Out Of Memory Quota!/\n/g'>>${logdir}/head-${yesterday}.log
	cat $log |awk '/^Out Of Memory Quota\!$/,/^}$/'|sed ':a;N;$!ba;s/\n/\[huanhangfu\]/g'|sed -e 's/Out Of Memory Quota!/\n/g'|grep -v "^$"|sed 's/^/Out Of Memory Quota!&/g'>>${logdir}/body-${yesterday}.log
	paste -d "\t" ${logdir}/head-${yesterday}.log ${logdir}/body-${yesterday}.log |sed 's/\[huanhangfu\]/\n/g'>>${logdir}/OUT_OF_MEMORY-${yesterday}.log
	rm -f ${logdir}/head-${yesterday}.log ${logdir}/body-${yesterday}.log
	cat $log|sed -n '/EXPENSIVE_QUERY/,/2019.*\.go:[0-9]/p'|grep -vE '\[info\]|SLOW_QUERY|\[error\]'>>${logdir}/EXPENSIVE_QUERY-${yesterday}.log
	cat $log|grep 'SLOW_QUERY'>>${logdir}/SLOW_QUERY-${yesterday}.log
else
	echo "Not Found Logfile,Exit"
fi

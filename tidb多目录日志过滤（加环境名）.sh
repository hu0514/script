#!/bin/bash
logdir=/mnt/tidb
yesterday=`date +"%Y-%m-%d" -d "-1 days"`
pathlist=`find ${logdir} -name "*-tidb-*.${yesterday}.log"|awk -v OFS="/" -v FS="/" '{$NF="";print $0}'|sort -u`
if [[ -n ${pathlist} ]];then
	for path in ${pathlist}
	do
		log=`find $path -name "*.${yesterday}.log"`
		name=`echo $path|awk -F"/" '{print $(NF-2)}'`
        	cat ${log} |grep -B3 'Out Of Memory Quota\!'|sed ':a;N;$!ba;s/\n/\[huanhangfu\]/g'|sed -e 's/Out Of Memory Quota!/\n/g'>>${path}head-${yesterday}.log
        	cat ${log} |awk '/^Out Of Memory Quota\!$/,/^}$/'|sed ':a;N;$!ba;s/\n/\[huanhangfu\]/g'|sed -e 's/Out Of Memory Quota!/\n/g'|grep -v "^$"|sed 's/^/Out Of Memory Quota!&/g'>>${path}body-${yesterday}.log
        	paste -d "\t" ${path}head-${yesterday}.log ${path}body-${yesterday}.log |sed 's/\[huanhangfu\]/\n/g'>>${path}${name}.out_of_memory.${yesterday}.txt
        	rm -f ${path}head-${yesterday}.log ${path}body-${yesterday}.log
        	cat ${log}|sed -n '/EXPENSIVE_QUERY/,/2019.*\.go:[0-9]/p'|grep -vE '\[info\]|SLOW_QUERY|\[error\]'>>${path}${name}.expensive_query.${yesterday}.txt
        	cat ${log}|grep 'SLOW_QUERY'>>${path}${name}.slow_query.${yesterday}.txt
	done
fi


#!/bin/bash
logdir=/mnt/tidb
year=`date +"%Y" -d "-1 days"`
mouth=`date +"%m" -d "-1 days"`
day=`date +"%d" -d "-1 days"`
yesterday=`date +"%Y-%m-%d" -d "-1 days"`
pathlist=`find ${logdir} -name "*-tidb-*.${yesterday}.log"|awk -v OFS="/" -v FS="/" '{$NF="";print $0}'|sort -u`
if [[ -n ${pathlist} ]];then
	for path in ${pathlist}
	do
		log=`find $path -name "*.${yesterday}.log"`
		name=`echo $path|awk -F"/" '{print $(NF-1)}'|awk -F"-" '{print $1"-"$3}'`
        	cat ${log} |grep -B3 'Out Of Memory Quota\!'|sed ':a;N;$!ba;s/\n/\[huanhangfu\]/g'|sed -e 's/Out Of Memory Quota!/\n/g'>>${path}head-${yesterday}.log
        	cat ${log} |awk '/^Out Of Memory Quota\!$/,/^}$/'|sed ':a;N;$!ba;s/\n/\[huanhangfu\]/g'|sed -e 's/Out Of Memory Quota!/\n/g'|grep -v "^$"|sed 's/^/Out Of Memory Quota!&/g'>>${path}body-${yesterday}.log
        	paste -d "\t" ${path}head-${yesterday}.log ${path}body-${yesterday}.log |sed 's/\[huanhangfu\]/\n/g'>>${path}${name}-out_of_memory.${yesterday}.log
        	rm -f ${path}head-${yesterday}.log ${path}body-${yesterday}.log
        	cat ${log}|sed ':a;N;$!ba;s/\n/\[huanhangfu\]/g'|sed 's/'"$year"'\/'"$mouth"'\/'"$day"'/\n/g'|grep -E '\[EXPENSIVE_QUERY\]|^$'|sed ':a;N;$!ba;s/\n/'"$year"'\/'"$mouth"'\/'"$day"'/g'|sed 's/\[huanhangfu\]/\n/g'>> ${path}${name}-expensive_query.${yesterday}.log
		cat ${log}|grep 'SLOW_QUERY'|grep -vE 'mysql.stats_meta|mysql.stats_histograms'>>${path}${name}-slow_query.${yesterday}.log
	done
fi


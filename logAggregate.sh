#!/bin/bash
file="/home/vihit/Downloads/vihit.log"
current=`date +%s`
last_modified=`stat -c "%Y" $file`
#echo $file"="$last_modified > audit.log
init_flag=0
audit_entry=`cat audit.log | grep $file`
if [ "$audit_entry" == "" ]
then
	audit_entry=$file=0,0	
	init_flag=1
fi
last_read=`echo $audit_entry | cut -d'=' -f2 | cut -d',' -f1`
last_offset=`echo $audit_entry | cut -d',' -f2`

if [ $(($last_read+1)) -lt $(($last_modified+1)) ]
then
	awk "NR>${last_offset}" $file
	lines=`cat /home/vihit/Downloads/vihit.log | wc -l`
	if [ $init_flag -eq 1 ]
	then
		echo $file=$current,$lines >>audit.log	
	else	
		sed -i "s|$audit_entry|${file}=${current},${lines}|" audit.log
	fi
fi

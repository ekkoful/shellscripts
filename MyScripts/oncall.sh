#!/bin/sh
#
# 分析线上日志，用于开发进行oncall

ansible adserver_online --list > /data/oncall/hostlist

IP=`shuf -n1 /data/oncall/hostlist`

ansible $IP -m shell -a "hostname" > /data/oncall/log/`date +%Y-%m-%d`.log

echo "" >> /data/oncall/log/`date +%Y-%m-%d`.log
echo "" >> /data/oncall/log/`date +%Y-%m-%d`.log
echo "" >> /data/oncall/log/`date +%Y-%m-%d`.log

ansible $IP -m shell -a "grep -E 'WARN|ERROR|FATAL' /data/recommend/advanced_search/log/update.log | cut -d ' ' -f 5,6,7,8,9,10,11 | \
sort | uniq -c | sort -nr" >> /data/oncall/log/`date +%Y-%m-%d`.log

echo "" >> /data/oncall/log/`date +%Y-%m-%d`.log
echo "" >> /data/oncall/log/`date +%Y-%m-%d`.log
echo "" >> /data/oncall/log/`date +%Y-%m-%d`.log

ansible $IP -m shell -a "grep -E 'WARN|ERROR|FATAL' /data/recommend/advanced_search/log/advanced_search.warn | cut -d '' -f 1,5- | \
sed -e 's/[a-f0-9]\{24\}/$REQID/g' | sed -e 's/QueryParam.*/QueryParam/g' | sed -e 's/not find adSourceList.*/not find adSourceList/g' | \
sed -e 's/\([0-9]\{1,3\}\.\)\{3\}[0-9]\{1,3\}/$IP/g' | sed -e 's/\([0-9]\+\)/$NUM/g' | sort | uniq -c | sort -nr" >> /data/oncall/log/`date +%Y-%m-%d`.log

ansible x.x.x.x -m copy -a "src=/data/oncall/log/`date +%Y-%m-%d`.log dest=/root/DingDingRobot/onlinelog/" -s > /dev/null

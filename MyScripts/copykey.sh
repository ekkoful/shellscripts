#!/bin/bash
###
# FileName: copykey.sh
# Author: ihuangch -huangch96@qq.com
# Description: 批量分发密钥
# Create:2019-04-11 15:49:06

###


User=root
password=*****
logfile=/tmp/copykey.log

yum -y install sshpass &>$logfile

rm -rf ./.ssh/id_rsa ~/.ssh/id_rsa.pub &>$logfile 

ssh-keygen -f ~/.ssh/id_rsa -P "" &>$logfile

for ip in $*
do		
	ping $ip -c1 &>$logfile
	if [  $? -gt 0 ];then
		echo "$ip无法ping通"
		continue
	fi
	sshpass -p "$password" ssh-copy-id -i ./.ssh/id_rsa.pub -o StrictHostKeyChecking=no ${User}@$ip &>$logfile
	echo "$IP 密钥分发成功"
done



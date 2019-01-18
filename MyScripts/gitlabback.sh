#!/bin/sh

/opt/gitlab/bin/gitlab-rake gitlab:backup:create
package=`cd /data/gitlab-backup/backups/ && ls -rthl | tail -1 | awk '{print $NF}'`
cd /data/gitlab-backup/backups/ && aws s3 --region ap-northeast-2 cp $package s3://ops-s3-bucket/gitlab-backup/

if [ $? -eq 0  ]; then
	    echo "gitlab backup successful" | mutt -s "gitlab backup" EMAIL
	else
	    echo "gitlab backup failed" | mutt -s "gitlab backup" EMAIL
fi

find /data/gitlab-backup/backups/*.tar | xargs rm -f


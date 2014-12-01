#!/bin/sh

# Backupscript that checks if there are failed cpanel backups and backs them up
# This script backs up one account at a time so the /home* directories should not fill up during the backups
# Then put this in crontab to much later than the official cpanel backup runs
# 2014-11-06 Hjorleifur Sveinbjornsson

########### SET SOME PARAMETERS ###########

#make sure the path is correct (running on centos 6.5)
export PATH=/usr/local/jdk/bin:/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/bin:/usr/X11R6/bin:/root/bin

#find the last backup directory because we can not use any other backup directory
newest_dir=`ls -dtr /backup/2* | tail -1`

#and only think about the accounts because that's where the problem is
backup_dir=${newest_dir}/accounts

# Make a list of failed backups, i.e size is 0
failed_backups=`ls -l ${backup_dir} | awk '$5 == 0 {print $9}' | awk -F"." '{print $1}'`

# Change this to your email address
toemails="toaddress@example.com"

# Change this to what ever you want to receive email from
fromemail="fromaddress@examble.com"

########### AND NOW BEGIN THE ACTUAL BACKUP #############

# Loop through the failed backups and back them up
for user in ${failed_backups}
	do
		#run the backup script
		/scripts/pkgacct ${user}

		#make sure it is finished before start on the next one
		wait

		#move the backup to the backup directory
		mv -f /home*/cpmove-${user}.tar.gz ${backup_dir}/${user}.tar.gz
	done

# And just so I know about failed backups then send me an email
# but only if there are failed backups, I don't care about success
# It also tells me if the backup partition is getting full
if [[ -n ${failed_backups} ]]
	then
		echo ${failed_backups} | mail -r ${fromemail} -s "cPanel re-backup users" ${toemails}
fi

cpanel-backup
=============

When cpanel backup fails this one comes back and saves the day.


Short bash script to back up cpanel accounts that cpanel did not back up because of space shortage on the /backup partition.  

This script should run in crontab much later than the official cpanel backup. 

If there are any accounts needed to back up then an email will be sent to you with info about what accounts this script needed to back up.

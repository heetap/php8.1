#!/bin/sh

# Exit the script if any statement returns a non-true return value
set -e

# Setup per minute cron folder
touch /var/spool/cron/crontabs/root
CRON_FOLDER=/etc/periodic/minute
mkdir -p ${CRON_FOLDER} && chmod 0755 ${CRON_FOLDER}
echo "*	*	*	*	*	run-parts ${CRON_FOLDER}" >> /var/spool/cron/crontabs/root
sed -i '/^$/d' /var/spool/cron/crontabs/root # remove empty lines from crontab file

cron -l 8

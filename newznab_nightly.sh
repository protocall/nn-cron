# this script is designed to be run once a day e.g. cron
# for those of us on residential connections or with bandwidth caps.
# most other scripts out there including the stock nn+ screen script
# are designed to loop indefinitely in a screen session.

# set path to newznab
NN_PATH="/usr/share/nnplus"

# database creds
DB_HOST="localhost"
DB_NAME="newznab"
DB_USER="username"
DB_PASS="password"

# backfill x days each run in addition to update
# note that 1 day is not enough if you run this once a day
# by the time it runs again, last updates will already be +1 day old
days=2

cd ${NN_PATH}/misc/update_scripts/
time php backfill_threaded.php
date
time php update_binaries_threaded.php
date

# counts releases still needing post proc
still=2
while [ $still -gt 1 ]; do
php update_releases.php
still=`mysql -u ${DB_USER} -p${DB_PASS} -h ${DB_HOST} ${DB_NAME} -s -N -e "select COUNT(*) from releases r left join category c on c.ID = r.categoryID where (r.passwordstatus between -6 and -1) or (r.haspreview = -1 and c.disablepreview = 0)"`
echo "still $still more to go"
done
date

cd ${NN_PATH}/misc/testing/
php update_parsing.php
php update_cleanup.php
php removespecial.php
cd ${NN_PATH}/misc/update_scripts/
php update_theaters.php
php update_tvschedule.php
php update_releases.php
php optimise_db.php
mysql -u ${DB_USER} -p${DB_PASS} -h ${DB_HOST} ${DB_NAME} -e "update groups set backfill_target=backfill_target+$days where active=1;"
echo "update complete. backfilled $days day(s)."
date


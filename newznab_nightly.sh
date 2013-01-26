cd /usr/share/nnplus/misc/update_scripts/
time php backfill_threaded.php
date
time php update_binaries_threaded.php
date

still=99
days=3
while [ $still -gt 10 ]; do
php update_releases.php
still=`mysql -u newznab -p5iron5010 newznab -s -N -e "select COUNT(*) from releases r left join category c on c.ID = r.categoryID where (r.passwordstatus between -6 and -1) or (r.haspreview = -1 and c.disablepreview = 0)"`
echo "still $still more to go"
done
date

cd /usr/share/nnplus/misc/testing/
php update_parsing.php
php update_cleanup.php
php removespecial.php
cd /usr/share/nnplus/misc/update_scripts/
php update_theaters.php
php update_tvschedule.php
php update_releases.php
php optimise_db.php
mysql -u newznab -p5iron5010 newznab -e "update groups set backfill_target=backfill_target+$days where active=1;"
echo "update complete. backfilled $days day(s)."
date


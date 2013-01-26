nn-cron
=======
this script is designed to be run once a day e.g. cron
for those of us on residential connections or with bandwidth caps.
most other scripts out there including the stock nn+ screen script
are designed to loop indefinitely in a screen session.

this will run updates, backfill, and increment the backfill table for groups marked active by a number of days you specify.
so each day brings you current and backwards.

sql query is made to determine the number of releases still needing processing.
update releases then loops until this value equals zero.

then we clean up hashed, nonsense, and invalid names. 

sql query credit goes to Thracky.

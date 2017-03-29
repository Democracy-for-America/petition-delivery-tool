#!/bin/sh

# Build a CSV of representatives from WAWD's DB

. credentials.sh

mysql -u ${USER} -p${PASSWORD} -h ${HOST} ${DATABASE} -e "
  SELECT us_district AS filename, state, title, long_title, first, last, official_full, nickname, party FROM core_target WHERE type = 'house' ORDER BY us_district
" | csvcut -t > targets.csv

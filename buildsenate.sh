#!/bin/sh

# Build a CSV of senators from WAWD's DB

. credentials.sh

mysql -u ${USER} -p${PASSWORD} -h ${HOST} ${DATABASE} -e "
  SELECT seat AS filename, state, title, long_title, first, last, official_full, nickname FROM core_target WHERE type = 'senate' ORDER BY seat
" | csvcut -t > targets.csv

#!/bin/sh

# Generate 50 CSVs of petition signatures, one for each state.
# By editing the SQL, this script can be revised to cut signatures by US House district, or to pull actions from a different page.

. credentials.sh

mkdir -p csv

for state in AK AL AR AZ CA CO CT DE FL GA HI IA ID IL IN KS KY LA MA MD ME MI MN MO MS MT NC ND NE NH NJ NM NV NY OH OK OR PA RI SC SD TN TX UT VA VT WA WI WV WY
do
  mysql -u ${USER} -p${PASSWORD} -h ${HOST} ${DATABASE} -e "
    SELECT
      TRIM(u.first_name) AS first_name,
      TRIM(u.last_name) AS last_name,
      LEFT(TRIM(u.last_name), 1) AS last_initial,
      TRIM(u.city) AS city,
      u.state,
      u.zip,
      TRIM(COALESCE(af.value, '')) AS comment
    FROM core_user u
    JOIN core_action a ON u.id = a.user_id
    LEFT JOIN core_actionfield af ON a.id = af.parent_id AND af.name = 'comment'
    WHERE
      a.page_id IN (8064) AND -- Page IDs here
      u.state = '${state}'
    GROUP BY first_name, last_initial, city, state, comment
    ORDER BY comment = '', a.created_at
  " | csvcut -t > csv/${state}.csv

  wc csv/${state}.csv
done

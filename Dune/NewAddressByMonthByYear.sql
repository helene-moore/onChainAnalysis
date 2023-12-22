WITH MonthlyUserCounts AS (
  SELECT
    EXTRACT(YEAR FROM block_time) AS year,
    EXTRACT(MONTH FROM block_time) AS month,
    EXTRACT(DAY FROM block_time) AS day,
    "from",
    "to",
    COUNT(DISTINCT "from") AS from_count
  FROM (
    SELECT
      "from",
      "to",
      block_time
    FROM ethereum.transactions
    WHERE
      block_time >= TRY_CAST('2023-01-01' AS DATE)
  ) AS TransactionData
  GROUP BY
    EXTRACT(YEAR FROM block_time),
    EXTRACT(MONTH FROM block_time),
    EXTRACT(DAY FROM block_time),
    "from",
    "to"
)
SELECT
  year,
  month,
  COUNT(DISTINCT CASE WHEN prev_from IS NULL OR prev_from <> "from" THEN "from" END) AS new_from_count
FROM (
  SELECT
    year,
    month,
    "from",
    LAG("from") OVER (PARTITION BY "from" ORDER BY year, month, day) AS prev_from
  FROM MonthlyUserCounts
) AS NewUserCounts
GROUP BY
  year,
  month
ORDER BY
  year,
  month;

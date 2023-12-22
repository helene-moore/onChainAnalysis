 WITH MonthlyUserCounts AS (
  SELECT
    EXTRACT(YEAR FROM block_timestamp) AS year,
    EXTRACT(MONTH FROM block_timestamp) AS month,
    from_address,
    LAG(from_address) OVER (ORDER BY EXTRACT(YEAR FROM block_timestamp), EXTRACT(MONTH FROM block_timestamp)) AS prev_from_address
  FROM ethereum.core.fact_transactions
  WHERE block_timestamp > '2023-01-01'
)
SELECT
  year,
  month,
  COUNT(DISTINCT CASE WHEN prev_from_address IS NULL OR prev_from_address <> from_address THEN from_address END) AS new_from_addresses
FROM MonthlyUserCounts
GROUP BY year, month
ORDER BY year, month;
 


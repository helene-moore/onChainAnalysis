SELECT
  EXTRACT(YEAR FROM block_timestamp) AS year,
  EXTRACT(MONTH FROM block_timestamp) AS month,
  count(DISTINCT from_address) AS unique_from_addresses
FROM
  ethereum.core.fact_transactions
WHERE
  block_timestamp > '2023-01-01'
GROUP BY
  year, month
ORDER BY
  year, month; 
CREATE OR REPLACE TABLE `my-project-nhs-496501.RTT_DATA_FEB202.dim_provider` AS
SELECT
  ROW_NUMBER() OVER (ORDER BY `Provider Org Code`, `Provider Org Name`) AS Provider_Key,
  `Provider Org Code`,
  `Provider Org Name`
FROM (
  SELECT DISTINCT
    `Provider Org Code`,
    `Provider Org Name`
  FROM `my-project-nhs-496501.RTT_DATA_FEB202.RTT `
);
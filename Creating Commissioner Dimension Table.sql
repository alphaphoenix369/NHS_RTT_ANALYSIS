CREATE OR REPLACE TABLE `my-project-nhs-496501.RTT_DATA_FEB202.dim_commissioner` AS
SELECT
  ROW_NUMBER() OVER (ORDER BY `Commissioner Org Code`, `Commissioner Org Name`) AS Commissioner_Key,
  `Commissioner Org Code`,
  `Commissioner Org Name`
FROM (
  SELECT DISTINCT
    `Commissioner Org Code`,
    `Commissioner Org Name`
  FROM `my-project-nhs-496501.RTT_DATA_FEB202.RTT `
);
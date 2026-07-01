CREATE OR REPLACE TABLE `my-project-nhs-496501.RTT_DATA_FEB202.dim_rtt_part_type` AS
SELECT
  ROW_NUMBER() OVER (ORDER BY `RTT Part Type`) AS RTT_Part_Type_Key,
  `RTT Part Type`
FROM (
  SELECT DISTINCT
    `RTT Part Type`
  FROM `my-project-nhs-496501.RTT_DATA_FEB202.RTT `
);
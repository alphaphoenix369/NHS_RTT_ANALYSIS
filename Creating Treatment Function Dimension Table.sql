CREATE OR REPLACE TABLE `my-project-nhs-496501.RTT_DATA_FEB202.dim_treatment_function` AS
SELECT
  ROW_NUMBER() OVER (ORDER BY `Treatment Function Code`, `Treatment Function Name`) AS Treatment_Function_Key,
  `Treatment Function Code`,
  `Treatment Function Name`
FROM (
  SELECT DISTINCT
    `Treatment Function Code`,
    `Treatment Function Name`
  FROM `my-project-nhs-496501.RTT_DATA_FEB202.RTT `
);
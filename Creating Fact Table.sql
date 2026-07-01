CREATE OR REPLACE TABLE `my-project-nhs-496501.RTT_DATA_FEB202.fact_rtt_waiting` AS

WITH unpivoted AS (
  SELECT
    `Period`,
    `Provider Org Code`,
    `Provider Org Name`,
    `Commissioner Org Code`,
    `Commissioner Org Name`,
    `Treatment Function Code`,
    `Treatment Function Name`,
    `RTT Part Type`,
    Waiting_Week,
    Patient_Count,
    CASE
      WHEN Waiting_Week = 'Gt 104 Weeks SUM 1' THEN 104
      ELSE CAST(REGEXP_EXTRACT(Waiting_Week, r'Gt (\d+) To') AS INT64)
    END AS Week_Number
  FROM `my-project-nhs-496501.RTT_DATA_FEB202.RTT `
  UNPIVOT (
    Patient_Count FOR Waiting_Week IN (
      `Gt 00 To 01 Weeks SUM 1`,
      `Gt 01 To 02 Weeks SUM 1`,
      `Gt 02 To 03 Weeks SUM 1`,
      `Gt 03 To 04 Weeks SUM 1`,
      `Gt 04 To 05 Weeks SUM 1`,
      `Gt 05 To 06 Weeks SUM 1`,
      `Gt 06 To 07 Weeks SUM 1`,
      `Gt 07 To 08 Weeks SUM 1`,
      `Gt 08 To 09 Weeks SUM 1`,
      `Gt 09 To 10 Weeks SUM 1`,
      `Gt 10 To 11 Weeks SUM 1`,
      `Gt 11 To 12 Weeks SUM 1`
      -- continue all week columns up to:
      -- `Gt 103 To 104 Weeks SUM 1`,
      -- `Gt 104 Weeks SUM 1`
    )
  )
)

SELECT
  p.Provider_Key,
  c.Commissioner_Key,
  tf.Treatment_Function_Key,
  rtt.RTT_Part_Type_Key,
  ww.Week_Key,
  u.`Period`,
  u.Patient_Count
FROM unpivoted u
LEFT JOIN `my-project-nhs-496501.RTT_DATA_FEB202.dim_provider` p
  ON u.`Provider Org Code` = p.`Provider Org Code`
 AND u.`Provider Org Name` = p.`Provider Org Name`
LEFT JOIN `my-project-nhs-496501.RTT_DATA_FEB202.dim_commissioner` c
  ON u.`Commissioner Org Code` = c.`Commissioner Org Code`
 AND u.`Commissioner Org Name` = c.`Commissioner Org Name`
LEFT JOIN `my-project-nhs-496501.RTT_DATA_FEB202.dim_treatment_function` tf
  ON u.`Treatment Function Code` = tf.`Treatment Function Code`
 AND u.`Treatment Function Name` = tf.`Treatment Function Name`
LEFT JOIN `my-project-nhs-496501.RTT_DATA_FEB202.dim_rtt_part_type` rtt
  ON u.`RTT Part Type` = rtt.`RTT Part Type`
LEFT JOIN `my-project-nhs-496501.RTT_DATA_FEB202.dim_waiting_week` ww
  ON u.Week_Number = ww.Week_Number
WHERE u.Patient_Count > 0;
WITH unpivoted AS (
  SELECT
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
      `Gt 10 To 11 Weeks SUM 1`
      -- continue adding all week columns up to:
      -- `Gt 103 To 104 Weeks SUM 1`,
      -- `Gt 104 Weeks SUM 1`
    )
  )
  WHERE `Provider Org Name` = 'GLOUCESTERSHIRE HOSPITALS NHS FOUNDATION TRUST'
    AND Patient_Count > 0
),

weekly_totals AS (
  SELECT
    `RTT Part Type`,
    Week_Number,
    SUM(Patient_Count) AS Patients
  FROM unpivoted
  GROUP BY `RTT Part Type`, Week_Number
),

running_total AS (
  SELECT
    `RTT Part Type`,
    Week_Number,
    Patients,
    SUM(Patients) OVER (
      PARTITION BY `RTT Part Type`
      ORDER BY Week_Number
    ) AS Cumulative_Patients,
    SUM(Patients) OVER (
      PARTITION BY `RTT Part Type`
    ) AS Total_Patients
  FROM weekly_totals
)

SELECT
  `RTT Part Type`,
  CASE
    WHEN Week_Number = 104 THEN '104+'
    ELSE CONCAT(CAST(Week_Number AS STRING), '-', CAST(Week_Number + 1 AS STRING))
  END AS Median_Waiting_Week,
  Week_Number AS Median_Week_Number,
  Total_Patients
FROM running_total
WHERE Cumulative_Patients >= Total_Patients / 2
QUALIFY ROW_NUMBER() OVER (
  PARTITION BY `RTT Part Type`
  ORDER BY Week_Number
) = 1
ORDER BY Median_Week_Number DESC;
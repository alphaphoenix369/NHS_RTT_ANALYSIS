CREATE OR REPLACE TABLE `my-project-nhs-496501.RTT_DATA_FEB202.dim_date` AS

WITH DateSeries AS (
  SELECT
    day AS Full_Date
  FROM UNNEST(
    GENERATE_DATE_ARRAY(
      DATE '2020-01-01',
      DATE '2030-12-31',
      INTERVAL 1 DAY
    )
  ) AS day
)

SELECT

  CAST(FORMAT_DATE('%Y%m%d', Full_Date) AS INT64) AS Date_Key,

  Full_Date,

  EXTRACT(YEAR FROM Full_Date) AS Year,

  EXTRACT(MONTH FROM Full_Date) AS Month,

  CONCAT(
    'Q',
    CAST(EXTRACT(QUARTER FROM Full_Date) AS STRING)
  ) AS Quarter,

  FORMAT_DATE('%B', Full_Date) AS Month_Name,

  FORMAT_DATE('%b %Y', Full_Date) AS Month_Year,

  CASE
    WHEN EXTRACT(MONTH FROM Full_Date) >= 4
      THEN CONCAT(
        CAST(EXTRACT(YEAR FROM Full_Date) AS STRING),
        '/',
        CAST(EXTRACT(YEAR FROM Full_Date) + 1 AS STRING)
      )
    ELSE CONCAT(
        CAST(EXTRACT(YEAR FROM Full_Date) - 1 AS STRING),
        '/',
        CAST(EXTRACT(YEAR FROM Full_Date) AS STRING)
      )
  END AS Financial_Year

FROM DateSeries;
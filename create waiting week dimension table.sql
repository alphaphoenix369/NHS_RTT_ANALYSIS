CREATE OR REPLACE TABLE `my-project-nhs-496501.RTT_DATA_FEB202.dim_waiting_week` AS
SELECT
  Week_Number AS Week_Key,
  Week_Number,
  CASE
    WHEN Week_Number = 104 THEN '104+'
    ELSE CONCAT(CAST(Week_Number AS STRING), '-', CAST(Week_Number + 1 AS STRING))
  END AS Week_Label,
  CASE
    WHEN Week_Number < 18 THEN 'Under 18 Weeks'
    WHEN Week_Number < 52 THEN '18-52 Weeks'
    WHEN Week_Number < 65 THEN '52-65 Weeks'
    WHEN Week_Number < 78 THEN '65-78 Weeks'
    WHEN Week_Number < 104 THEN '78-104 Weeks'
    ELSE '104+ Weeks'
  END AS Week_Band,
  CASE WHEN Week_Number < 18 THEN 1 ELSE 0 END AS Is_Under_18,
  CASE WHEN Week_Number >= 18 THEN 1 ELSE 0 END AS Is_18_Plus,
  CASE WHEN Week_Number >= 52 THEN 1 ELSE 0 END AS Is_52_Plus,
  CASE WHEN Week_Number >= 65 THEN 1 ELSE 0 END AS Is_65_Plus,
  CASE WHEN Week_Number >= 78 THEN 1 ELSE 0 END AS Is_78_Plus,
  CASE WHEN Week_Number >= 104 THEN 1 ELSE 0 END AS Is_104_Plus,
  CASE
    WHEN Week_Number >= 104 THEN 'Critical'
    WHEN Week_Number >= 78 THEN 'High'
    WHEN Week_Number >= 52 THEN 'Medium'
    ELSE 'Low'
  END AS Risk_Level
FROM UNNEST(GENERATE_ARRAY(0,104)) AS Week_Number;
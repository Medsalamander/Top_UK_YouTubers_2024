/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) [Column_1]
      ,[NOMBRE]
      ,[SEGUIDORES]
      ,[TP]
      ,[PAÍS]
      ,[TEMA_DE_INFLUENCIA]
      ,[ALCANCE_POTENCIAL]
      ,[GUARDAR]
      ,[INVITAR_A_LA_CAMPAÑA]
      ,[channel_name]
      ,[total_subscribers]
      ,[total_views]
      ,[total_videos]
      ,[column14]
  FROM [youtube_db].[dbo].[top_uk_youtubers_2024]

  /*
  # Data Cleaning steps
  1.Remove the unnecessary columns by only selecting the ones we need
  2.Extract the youtube channel names from the numbre column
  3. Rename the column name 
  */

SELECT 
	NOMBRE,
	total_subscribers,
	total_views,
	total_videos
FROM 
	top_uk_youtubers_2024

--extract the channel name from the Nombre column using the CHARINDEX function
--example
SELECT CHARINDEX('nice', 'I went to a nice park') as position_of_n_in_nice

-- identify the @ position in the nombre column
SELECT CHARINDEX('@', NOMBRE), NOMBRE FROM top_uk_youtubers_2024

--extracting the data to the left of the @ symbol using the substring function
SELECT SUBSTRING(NOMBRE, 1, CHARINDEX('@', NOMBRE)- 1) FROM top_uk_youtubers_2024

-- Making sure the contents are strings
SELECT	
	CAST(SUBSTRING(NOMBRE, 1, CHARINDEX('@', NOMBRE)- 1) AS VARCHAR(100)) AS channel_name 
FROM 
	top_uk_youtubers_2024


--Adding the rest of the columns
SELECT	
	CAST(SUBSTRING(NOMBRE, 1, CHARINDEX('@', NOMBRE)- 1) AS VARCHAR(100)) AS channel_name,
	total_subscribers,
	total_views,
	total_videos
FROM 
	top_uk_youtubers_2024

--create a view to zero down on just the data we need

CREATE VIEW view_uk_youtubers_2024 AS

SELECT	
	CAST(SUBSTRING(NOMBRE, 1, CHARINDEX('@', NOMBRE)- 1) AS VARCHAR(100)) AS channel_name,
	total_subscribers,
	total_views,
	total_videos
FROM 
	top_uk_youtubers_2024

/*
# data quality tests
1. The data neeeds to be 100 records of youtube channels(row count test)
2. The data needs 4 fields(column count test)
3. The channel name column must be string format, and other columns must be numerical data types(data type check)
4. Each record must be unique in the dataset(duplicate count check)

Goal is to ensure that actual data is equivalent to the expected data

Row count - 100
coulmn count -04

Data types

channel_name = VARCHAR
total_subscribers = INTEGER
total_views = INTEGER
total_videos = INTEGER

Duplicate count = 0



*/

-- 1. Row Count check
SELECT COUNT(*) as no_of_rows
FROM view_uk_youtubers_2024

-- 2. Column count check
SELECT COUNT(*) as column_count 
FROM 
	INFORMATION_SCHEMA.COLUMNS
WHERE 
	TABLE_NAME = 'view_uk_youtubers_2024'

--3. Data type check

SELECT 
	COLUMN_NAME,
	DATA_TYPE
FROM 
	INFORMATION_SCHEMA.COLUMNS
WHERE 
	TABLE_NAME = 'view_uk_youtubers_2024'

-- 4.Duplicate records check
SELECT 
	channel_name, 
	COUNT(*) as duplicate_count
FROM view_uk_youtubers_2024
GROUP BY 
	channel_name
HAVING 
	COUNT(*) > 1


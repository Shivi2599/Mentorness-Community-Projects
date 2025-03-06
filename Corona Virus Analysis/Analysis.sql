-- Create new Database --
CREATE DATABASE IF NOT EXISTS CORONA_VIRUS_ANALYSIS;

-- Telling MySQL which database to use --
USE CORONA_VIRUS_ANALYSIS;

-- Creating Table --
CREATE TABLE IF NOT EXISTS corona_virus_data
(
Province  VARCHAR(250),
Country VARCHAR(250),
Latitude FLOAT,
Longitude FLOAT,
Date DATE,
Confirmed INT,
Deaths INT,
Recovered int
);

-- My Table --
SELECT *FROM corona_virus_data;

-- Loading my data into MySQL --
SHOW VARIABLES LIKE 'secure_file_priv';
LOAD DATA INFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Corona virus dataset.csv"
INTO TABLE corona_virus_data
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

                                               -- WRITE A CODE TO CHECK NULL VALUES.-

SELECT * FROM corona_virus_data
WHERE Province IS NULL or
Country IS NULL OR
Latitude IS NULL or
Longitude IS NULL OR
Date IS NULL OR
Confirmed IS NULL OR
Deaths IS NULL OR
Recovered IS NULL ;

SELECT 
SUM(CASE WHEN Province IS NULL THEN 1 ELSE 0 END) AS Null_Province,
SUM(CASE WHEN Country IS NULL THEN 1 ELSE 0 END) AS Null_Country,
SUM(CASE WHEN Latitude IS NULL THEN 1 ELSE 0 END) AS Null_Latitude,
SUM(CASE WHEN Longitude IS NULL THEN 1 ELSE 0 END) AS Null_Longitude,
SUM(CASE WHEN Date IS NULL THEN 1 ELSE 0 END) AS Null_Date,
SUM(CASE WHEN Confirmed IS NULL THEN 1 ELSE 0 END) AS Null_Confirmed,
SUM(CASE WHEN Deaths IS NULL THEN 1 ELSE 0 END) AS Null_Deaths,
SUM(CASE WHEN Recovered IS NULL THEN 1 ELSE 0 END) AS Null_Recovered
FROM corona_virus_data;

                                         -- IF NULL VALUES ARE PRESENT, UPDATE THEM WITH ZEROS FOR ALL COLUMNS--

UPDATE corona_virus_data
SET
Province = COALESCE(Province, 0),
Country = COALESCE(Country, 0),
Latitude = COALESCE(Latitude, 0),
Longitude = COALESCE(Longitude, 0),
Date = COALESCE(Date, 0),
Confirmed = COALESCE(Confirmed, 0),
Deaths = COALESCE(Deaths, 0),
Recovered = COALESCE(Recovered, 0);

-- Diasbling the safe update mode --
set sql_safe_updates= 0;

                                            -- CHECK TOTAL NUMBER OF ROWS--
                                            
SELECT  
COUNT(*) as total_number_of_rows_in_dataset
FROM corona_virus_data;

										-- CHECK WHAT IS START_DATE AND END_DATE --
							
SELECT
MIN(date) AS start_date,
MAX(Date) AS end_date
FROM corona_virus_data;

                                        -- NUMBER OF MONTHS PRESENT IN THE DATASET --

SELECT 
COUNT(DISTINCT date_format(Date, '%Y-%m')) AS total_number_of_months
FROM corona_virus_data;

								-- FIND MONTHLY AVERAGE FOR CONFIRMED, DEATHS, RECOVERED --
                                         
SELECT 
DATE_FORMAT(Date, '%y-%m') as Months,
AVG(Confirmed) AS avg_confirmed_cases,
AVG(Deaths) AS avg_deaths,
AVG(Recovered) AS avg_recovered_cases
FROM corona_virus_data
GROUP BY Months;
                                
--  Adding new column 'months' --
ALTER TABLE corona_virus_data
ADD COLUMN Months VARCHAR(20) AFTER Date;

# Updating new column "Months"
UPDATE corona_virus_data
SET Months = DATE_FORMAT(Date, "%y-%m");

SELECT * FROM corona_virus_data;

                             -- MOST FREQUENT VALUE FOR CONFIRMED, DEATHS, AND RECOVERED EACH MONTH --
                             
SELECT Months, Confirmed, Deaths, Recovered
FROM (
SELECT 
Months, Confirmed, Deaths, Recovered,
ROW_NUMBER() OVER (PARTITION BY Months ORDER BY COUNT(*) DESC) AS row_num
FROM corona_virus_data
GROUP BY Months, Confirmed, Deaths, Recovered
) AS subquery
WHERE row_num = 1;

	-- Adding new column "Year" --
ALTER TABLE corona_virus_data
ADD COLUMN Year YEAR AFTER Months;

-- Updating new column 'Year' --
UPDATE corona_virus_data
SET Year = YEAR(Date);

SELECT * FROM Corona_virus_data;

                            -- MINIMUM VALUES FOR CONFIRMED, DEATHS, RECOVERED PER YEAR --
                            
SELECT Year,
MIN(Confirmed) AS Min_Confirmed_Cases,
MIN(Deaths) AS Min_Deaths,
MIN(Recovered) AS Min_Recovered_Cases
FROM corona_virus_data
GROUP BY Year;

                            -- MAXiMUM VALUES FOR CONFIRMED, DEATHS, RECOVERED PER YEAR --
                            
SELECT Year,
MAX(Confirmed) AS Max_Confirmed_Cases,
MAX(Deaths) AS Max_Deaths,
MAX(Recovered) AS Max_Recovered_Cases
FROM corona_virus_data
GROUP BY Year;

						 -- TOTAL NUMBER OF CASES OF CONFIRMED, DEATHS, RECOVERED EACH MONTH --
                         
SELECT Months,
SUM(Confirmed) AS Total_Confirmed_Cases,
SUM(Deaths) AS Total_Deaths,
SUM(Recovered) AS Total_Recovered_Cases
FROM corona_virus_data
GROUP BY Months;

                         -- CHECK HOW CORONA VIRUS SPREAD OUT WITH RESPECT TO CONFIRMED CASE --
     -- By months --                    
SELECT Months,
SUM(Confirmed) AS Total_Confirmed_Cases,
AVG(Confirmed) AS Avg_Confirmed_Cases,
VARIANCE(Confirmed) AS Variance_of_confirmed_cases,
STDDEV(Confirmed) AS Stdev_of_confirmed_cases
FROM corona_virus_data
GROUP BY Months;

    -- By Year --
SELECT Year,
SUM(Confirmed) AS Total_Confirmed_Cases,
AVG(Confirmed) AS Avg_Confirmed_Cases,
VARIANCE(Confirmed) AS Variance_of_confirmed_cases,
STDDEV(Confirmed) AS Stdev_of_confirmed_cases
FROM corona_virus_data
GROUP BY Year;

                                  -- CHECK HOW CORONA VIRUS SPREAD OUT WITH RESPECT TO DEATH CASE PER MONTH --
                                  
SELECT Months,
SUM(Deaths) AS Total_Deaths,
AVG(Deaths) AS Avg_of_Deaths,
VARIANCE(Deaths) AS Variance_of_Deaths,
STDDEV(Deaths) AS Stdev_of_Deaths
FROM corona_virus_data
GROUP BY Months;
    
                                 -- CHECK HOW CORONA VIRUS SPREAD OUT WITH RESPECT TO RECOVERED CASE --
                                 
     -- By months --                    
SELECT Months,
SUM(Recovered) AS Total_Recovered_Cases,
AVG(Recovered) AS Avg_Recovered_Cases,
VARIANCE(Recovered) AS Variance_of_Recovered_cases,
STDDEV(Recovered) AS Stdev_of_Recovered_cases
FROM corona_virus_data
GROUP BY Months;

    -- By Year --
SELECT Year,
SUM(Recovered) AS Total_Recovered_Cases,
AVG(Recovered) AS Avg_Recovered_Cases,
VARIANCE(Recovered) AS Variance_of_Recovered_cases,
STDDEV(Recovered) AS Stdev_of_Recovered_cases
FROM corona_virus_data
GROUP BY Year;

                               -- FIND COUNTRY HAVING HIGHEST NUMBER OF THE CONFIRMED CASES --

SELECT Country,
SUM(Confirmed) AS Total_Confirmed_Cases
FROM corona_virus_data
GROUP BY Country
ORDER BY Total_Confirmed_Cases DESC
LIMIT 1;

                              -- FIND COUNTRY HAVING LOWEST NUMBER OF THE DEATH CASES --
                              
SELECT Country,
SUM(Deaths) AS Total_Deaths
FROM corona_virus_data
GROUP BY Country
ORDER BY Total_Deaths ASC
LIMIT 1;

                               -- FIND TOP 5 COUNTRIES HAVING HIGHEST RECOVERED CASE --
                               
SELECT Country,
SUM(Recovered) AS Total_Recovered_Cases
FROM corona_virus_data
GROUP BY Country
ORDER BY Total_Recovered_Cases DESC
LIMIT 5;

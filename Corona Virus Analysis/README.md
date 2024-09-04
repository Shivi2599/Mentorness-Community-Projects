# Corona-Virus-Analysis-MySQL

## Project Overview

The CORONA VIRUS pandemic has had a significant impact on public health and has created an urgent need for data-driven insights to understand the spread of the virus. As a data analyst, I have been tasked with analyzing a corona virus dataset to derive meaningful insights and present my findings.

### Data Sources 

- **Raw Data:** The primary dataset used for this analysis is "Corona Virus Dataset.csv" file.

### Dataset 

#### Description of each column in dataset:

- **Province:** Geographic subdivision within a country/region.
- **Country/Region:** Geographic entity where data is recorded.
- **Latitude:** North-south position on Earth's surface.
- **Longitude:** East-west position on Earth's surface.
- **Date:** Recorded date of CORONA VIRUS data.
- **Confirmed:** Number of diagnosed CORONA VIRUS cases.
- **Deaths:** Number of CORONA VIRUS related deaths.
- **Recovered:** Number of recovered CORONA VIRUS cases.


### Tools 

- MySQL 
  - Data Cleaning
  - Dala Analysis
- Ms Powerpoint
  - Creating Reports
 
### Exploratory Data Analysis 

#### Questions Explored

**Q1**. Write a code to check NULL values.

**Q2**. If NULL values are present, update them with zeros for all columns. 

**Q3**. Check total number of rows.

**Q4**. Check what is start_date and end_date.

**Q5**. Number of months present in dataset.

**Q6**. Find monthly average for confirmed, deaths, recovered.

**Q7**. Find most frequent value for confirmed, deaths, recovered each month.

**Q8**. Find minimum values for confirmed, deaths, recovered per year.

**Q9**. Find maximum values of confirmed, deaths, recovered per year.

**Q10**. The total number of case of confirmed, deaths, recovered each month.

**Q11**. Check how corona virus spread out with respect to confirmed case (Eg.: total confirmed cases, their average, variance & STDEV ).

**Q12**. Check how corona virus spread out with respect to death case per month (Eg.: total confirmed cases, their average, variance & STDEV ).

**Q13**. Check how corona virus spread out with respect to recovered case (Eg.: total confirmed cases, their average, variance & STDEV ).

**Q14**. Find Country having highest number of the Confirmed case.

**Q15**. Find Country having lowest number of the death case.

**Q16**. Find top 5 countries having highest recovered case.

### Some Interesting Queries

**Q1**. Write a code to check NULL values.
```sql
SELECT 
  COUNT(*) AS total_rows,
  SUM(CASE WHEN Province IS NULL THEN 1 ELSE 0 END) AS null_province,
  SUM(CASE WHEN `Country/Region` IS NULL THEN 1 ELSE 0 END) AS null_country,
  SUM(CASE WHEN Latitude IS NULL THEN 1 ELSE 0 END) AS null_latitude,
  SUM(CASE WHEN Longitude IS NULL THEN 1 ELSE 0 END) AS null_longitude,
  SUM(CASE WHEN Date IS NULL THEN 1 ELSE 0 END) AS null_date,
  SUM(CASE WHEN Confirmed IS NULL THEN 1 ELSE 0 END) AS null_confirmed,
  SUM(CASE WHEN Deaths IS NULL THEN 1 ELSE 0 END) AS null_deaths,
  SUM(CASE WHEN Recovered IS NULL THEN 1 ELSE 0 END) AS null_recovered
FROM corona_virus_data;
```
**Q5**. Number of months present in dataset.
```sql
SELECT 
  COUNT(DISTINCT DATE_FORMAT(Date, '%Y-%m')) AS total_months
FROM corona_virus_data;
```
**Q11**. Check how corona virus spread out with respect to confirmed case (Eg.: total confirmed cases, their average, variance & STDEV ).
```sql
SELECT 
  DATE_FORMAT(Date, '%Y-%m') AS month,
  SUM(Confirmed) AS total_confirmed,
  AVG(Confirmed) AS avg_confirmed,
  VARIANCE(Confirmed) AS variance_confirmed,
  STDDEV(Confirmed) AS stdev_confirmed
FROM corona_virus_data
GROUP BY month;
```
**Q16**. Find top 5 countries having highest recovered case.
```sql
SELECT 
  `Country/Region`,
  SUM(Recovered) AS total_recovered
FROM corona_virus_data
GROUP BY `Country/Region`
ORDER BY total_recovered DESC
LIMIT 5;
```

### Insights

**Data Quality**
- There were no NULL values present.
- Number of rows in dataset is 78,386.

**Monthly Trends**
- Analysis covered data from January 2020 to June 2021 (18 months).
- Identified significant peaks in confirmed cases, particularly in March and November 2020.

**Geographical Impact**
-  The United States recorded the highest confirmed cases, while Dominica had the lowest death cases.

**Recovery Analysis**
-  India, Brazil, and the United States led in recovery rates, reflecting effective healthcare responses.




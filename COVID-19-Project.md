# Covid-19 Project 

In this project, I have used two tables, one containing information on deaths associated with covid and one with data on covid vaccinations.
Two new SQL concepts I have used for this project are JOIN and common table expression (CTE). 
- This project, was inspired by Alex Freberg's project that I studied while learning new SQL concepts. However, I added some new queries and concepts. 
- https://www.youtube.com/watch?v=qfyynHBFOsM 

## Datasets 

- https://ourworldindata.org/covid-deaths
- Contains data between 2020-02-24 and 2022-10-12

## Data exploration


````sql
SELECT COUNT(*)
FROM CovidDeaths

SELECT COUNT(*)
FROM INFORMATION_SCHEMA.COLUMNS
WHERE table_name='CovidDeaths'

SELECT COUNT(*)
FROM CovidVaccinations

SELECT COUNT(*)
FROM INFORMATION_SCHEMA.COLUMNS
WHERE table_name='CovidVaccinations'

````
The table **CovidDeaths** consists of 223 297 rows and 26 columns and the table **CovidVaccinations** consists of 223 297 rows and 45 columns. 

Selecting the data we will use for the first queries and ordering it by the first and second columns..

````sql
SELECT Location,date,total_cases,new_cases,total_deaths,population 
FROM CovidDeaths
ORDER BY 1,2
````

![image](https://user-images.githubusercontent.com/114582898/199191422-277b9015-c780-4288-b675-42e59675a5a1.png)

Changing the data types from nvarchar to decimal so we can use it for calculations and cleaning up the **Date** column to only include year, month and day.

````sql
ALTER TABLE CovidDeaths ALTER COLUMN total_cases DECIMAL(18,2);
ALTER TABLE CovidDeaths ALTER COLUMN total_deaths DECIMAL(18,2);
ALTER TABLE CovidDeaths ALTER COLUMN new_cases DECIMAL(18,2);
ALTER TABLE CovidDeaths ALTER COLUMN new_deaths DECIMAL(18,2);

ALTER TABLE CovidDeaths 
ADD DateConverted DATE; 

UPDATE CovidDeaths
SET DateConverted =CONVERT(DATE,date)

````

Calculating the likelihood of dying if infected by the virus in Sweden. 

````sql 
SELECT Location,DateConverted,total_cases,total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
FROM CovidDeaths
WHERE location like '%Sweden%'
ORDER BY 2 DESC

```` 

![image](https://user-images.githubusercontent.com/114582898/199199716-6aa263df-7923-440c-9520-4d4fd747cd49.png)

Calculating the percentage of the population in Sweden that has been infected by the virus. 
````sql
SELECT Location,DateConverted,Population,total_cases,(total_cases/Population)*100 AS InfectedPercentage 
FROM CovidDeaths
WHERE location like '%Sweden%'
ORDER BY 2 DESC ;

````
![image](https://user-images.githubusercontent.com/114582898/199202215-db2b30fc-0599-494f-aaa8-e525dc4d392e.png)







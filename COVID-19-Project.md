# Covid-19 Project 

In this project, I have used two tables, one containing information on deaths associated with covid and one with data on covid vaccinations.
Two new SQL concepts I have used for this project are JOIN and common table expression (CTE). 
- This project, was inspired by Alex Freberg's project that I studied while learning new SQL concepts. However, I made it my own by adding some new queries and concepts. 

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


Looking at countries with highest infection rate compared to population. 

````sql
SELECT Location,Population, MAX(total_cases) AS HighestInfectionCount,MAX((total_cases/Population))*100 AS PercentagePopulationInfected  
FROM CovidDeaths
GROUP BY Location,Population
ORDER BY PercentagePopulationInfected DESC;

````
![image](https://user-images.githubusercontent.com/114582898/199241594-25cd6c8a-5331-4d93-8d24-400f4bc567d1.png)

As expected, small countries have the highest infection rates. 

If we look at the countries with the most total cases, we get the larger countries.

````sql
SELECT Location,Population, MAX(total_cases) AS HighestInfectionCount,MAX((total_cases/Population))*100 AS PercentagePopulationInfected  
FROM CovidDeaths
WHERE continent is not null
GROUP BY Location,Population
ORDER BY HighestInfectionCount DESC;

````

![image](https://user-images.githubusercontent.com/114582898/199244117-583f769f-f018-4972-89cb-2a1d0e5e441c.png)

Let's break things down by looking at infection rates for continents.

````sql
SELECT Location,Population, MAX(total_cases) AS HighestInfectionCount,MAX((total_cases/Population))*100 AS PercentagePopulationInfected  
FROM CovidDeaths
WHERE continent is NULL
GROUP BY Location,Population
ORDER BY PercentagePopulationInfected DESC;

````
![image](https://user-images.githubusercontent.com/114582898/199246913-83db4450-d0fd-4158-a578-d6d41a21addb.png)

We get all the continents, but also some aggregated locations based on income levels for the countries. We can see a relationship where lower-income countries have lower infection rates. This is probably a consequence of the lower capacity for testing. 


Let's group daily cases, daily deaths, and daily death percentage by date. By doing this, we get global numbers for each day. 
````sql
SELECT DateConverted, SUM(new_cases) AS Daily_Cases, SUM(new_deaths) AS Daily_Deaths ,
 SUM(new_deaths)/SUM(new_cases)*100 AS Daily_DeathPercentage
FROM CovidDeaths
WHERE continent is not null 
GROUP BY DateConverted
ORDER BY 1 DESC
````

![image](https://user-images.githubusercontent.com/114582898/199442083-b04b4418-a8bf-42e9-836d-3c1e1c609235.png)


Now let's involve the vaccinations table in the analysis. We join the two tables on the **location** and the **date** variables, and since we will only use the **new_vaccinations** variable from the vaccinations table, we can use the cast function to change the data type.

  Let's create a new variable called **RollingPeopleVaccinated** that represents the cumulative number of vaccinations for each country.
  
  ````sql
  SELECT  dea.continent, dea.location, dea.DateConverted, dea.population, vac.new_vaccinations
, SUM(CAST(vac.new_vaccinations AS DECIMAL(18,2))) OVER (PARTITION BY dea.location
ORDER BY dea.location,dea.DateConverted) AS RollingPeopleVaccinated 
FROM CovidDeaths dea
JOIN CovidVaccinations vac
    ON dea.location = vac.location
	AND dea.date=vac.date
	WHERE dea.continent is not null
	ORDER BY 2,3
  
  ````
  
  
  
  
![image](https://user-images.githubusercontent.com/114582898/199456709-7e68da52-41e8-411e-bf13-709e63b7cec6.png)

In the results, we can see that the column for **RollingPeopleVaccinated** adds up new vaccinations to a cumulative sum.

The problem with this is that if we want to use the new variable **RollingPeopleVaccinated** for further calculations we need to create a common table expression (CTE).  So lets create a new variable where we calculate the cumulative percentage of vaccinated people for each country with a CTE. 

````sql
WITH PopvsVac( Continent, location, DateConverted, population, new_vaccinations, RollingPeobleVaccinated)
AS 
(
SELECT  dea.continent, dea.location, dea.DateConverted, dea.population, vac.new_vaccinations
, SUM(CAST(vac.new_vaccinations AS DECIMAL(18,2))) OVER (PARTITION BY dea.location
ORDER BY dea.location,dea.DateConverted) AS RollingPeopleVaccinated 
FROM CovidDeaths dea
JOIN CovidVaccinations vac
    ON dea.location = vac.location
	AND dea.date=vac.date
	WHERE dea.continent is not null
	)
SELECT * , (RollingPeobleVaccinated/population)*100 AS RollingPercentageVaccinated
FROM PopvsVac

````

![image](https://user-images.githubusercontent.com/114582898/199466135-bf4ac92d-abed-44f7-8fa4-ada4eb395466.png)


Another alternative when we want to use columns we have created for new calculations is to create a temp table (temporary table). 
Let's create a temp table where we take **location** based on income level and group it with **population** and **total vaccinations**.

````sql
DROP TABLE IF EXISTS #GDP_Vaccinations
CREATE TABLE #GDP_Vaccinations 
(
Location nvarchar(255),
Population numeric, 
Total_Vaccinations numeric, 

) 

INSERT INTO #GDP_Vaccinations
SELECT vac.location , dea.population, sum(cast(vac.new_vaccinations as decimal(18,2)))AS Total_Vaccinations 

FROM CovidVaccinations vac
JOIN CovidDeaths dea
  ON dea.location = vac.location
  AND dea.date=vac.date
WHERE dea.location LIKE '%low income%' OR dea.location LIKE '%lower middle income%' 
OR dea.location LIKE '%Upper middle income%' or dea.location LIKE '%high income%'
AND vac.location LIKE '%low income%' OR vac.location LIKE '%lower middle income%'
OR vac.location LIKE '%Upper middle income%' OR vac.location LIKE '%high income%'
GROUP BY dea.location,vac.location,dea.population
 SELECT * 
FROM #GDP_Vaccinations 

````
![image](https://user-images.githubusercontent.com/114582898/199698865-b19f1f8a-40e0-4886-976b-422cc1713048.png)


Now we can use the temp table for further calculations. 
Let's say we want to check the percentage of the population that is vaccinated. 

```` sql
SELECT *, CAST(((Population/Total_vaccinations)*100) AS NUMERIC(36,2))AS PercentVaccinated
FROM #GDP_Vaccinations

````
![image](https://user-images.githubusercontent.com/114582898/199701578-ac756915-bc86-42b4-a57d-834070e94302.png)

These numbers do not seem to be legit but after some double-checking, the numbers are correct. The vaccinations for low income countries are about 315%  which can be correct considering that people get multiple vaccinations, but the numbers for high-income countries seem a bit too low at only 47%. So I think the quality of this data is a bit unreliable when it comes to the classifications of income levels for the countries. However, the calculations are correct. 






/* Covid data exploration with SQL 
    3 tables 'CovidCases' 'CovidDeaths' 'CovidTests' contained
 */ 

Select location, date, population, total_cases, (total_cases/population)*100 AS infection_rate 
From side_projects..CovidCases
where contient is NOT NULL 
order by date DESC 

-- estimate the infection rate and select data needed in the descending order 



Select location, date, population, total_deaths, (total_deaths/population)*100 AS death_rate 
From side_projects..CovidDeaths 
where contient is NOT NULL 
order by date DESC 

-- estimate the death rate and select data needed in the descending order



Select location, date, population, total_tests, (total_tests/population)*100 AS positive_rate 
From side_projects..CovidTests 
where continent is NOT NULL 
order by date DESC 

-- estimate the proportion of confirmed cases over the number of testing done  



Select continent, max((total_cases/population)*100) AS highest_InfectionRate
From side_projects..CovidCases
where continent is NOT NULL 
Group by continent 
Order by continent DESC

-- ordering continent that has the highest infection rate to the lowest 



Select continent, max((total_deaths/population)*100) AS highest_DeathRate 
From side_projects..CovidDeaths 
where continent is NOT NULL 
Group by continent 
Order by continent DESC

-- ordering continent that has the higesht death rate to the lowest  

Select continent, max((total_tests/population)*100) AS highest_PositiveRate
From side_projects..CovidTests 
where continent is NOT NULL 
Group by contient 
Order by continent DESC

-- ordering continent that has the highest positive rate to the lowest 


Select location, date, highest_InfectionRate, highest_DeathRate, highest_PositiveRate
From side_project..CovidCases cas 
JOIN side_project..CovidDeaths dea ON cas.location = dea.location AND cas.date = dea.date 
JOIN side_project..CovidTests test ON dea.location = test.location AND dea.date = test.date 
order by highest_infectionRate 

-- comparing the infection rate, death rate and positive rate of continents directly 



Select location, date, total_cases
From side_project..CovidCases 
Where location LIKE '%a' OR location LIKE 'h%g' 
order by location 

-- Find the data where the country name that ends with A or starts with H and ends with G 



Select location, avg(new_cases) AS mean,
CASE WHEN mean> 10000 THEN 'The country is in high risk' 
WHEN 100 < mean < 10000 THEN 'The country has medium risk level' 
ELSE 'The country has low risk' 
END AS RiskLevel 
From side_projects..CovidCases 
WHERE date > '2020-03-01' 
Group by location

-- simply determining risk level of each country, according to the number of daily new cases 



Select COUNT(location) 
From side_projects..CovidCases 
Where location IN (select location 
				   From side_projects..CovidDeaths
				   Where total_deaths > 10000) 
AND total_cases > 100000 
Group by location 
order by total_cases 

-- find the number of country with more than 10 thousand deaths and 100 thousand cases in total 



CREATE TABLE CovidSummary( 
countryID int NOT NULL AUTO_INCREMENT,
continent varchar(100),
location varchar(100), 
totalCases int, 
Infection DECIMAL,
totalDeaths int,
Death DECIMAL,
totalTests int,
Positive DECIMAL,
Primary Key(CountryID) 
) 

-- Summarizing all usefull information into 1 new table 



INSERT INTO CovidSummary
Select cas.continent, cas.location, cas.total_cases,cas.infection_rate,dea.total_deaths,dea.death_rate,test.total_tests,test.positive_rate 
From side_projects..CovidCases cas 
JOIN side_projects..CovidDeaths dea ON cas.location = dea.location AND cas.date=dea.date
JOIN side_projects..COvidTests test ON dea.location = test.location AND dea.date=test.date
Group by cas.location 

-- Insert data into the new table with current tables 


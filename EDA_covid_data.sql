-- SQL database was created from raw csv found on ourworldindata.org
-- First I looked at the raw data imported into the database

USE PortfolioProject
SELECT * 
FROM PortfolioProject..covid_deaths
WHERE continent is not null
ORDER BY 3,4

SELECT *
FROM PortfolioProject..covid_vaccinations
ORDER BY 3,4

-- Select columns that are going to be used in analysis

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM PortfolioProject..covid_deaths
ORDER BY 1,2

-- First I looked at the likelyhood of dying was after an infection
-- Daily likelihood of dying if someone contracted covid in the United States 

SELECT location, date, total_cases, total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
FROM PortfolioProject..covid_deaths
WHERE location like '%united states%'
ORDER BY 1,2

-- Daily percentage of the population that was infected with Covid sorted by country

SELECT location, date,  population, total_cases,(total_cases/population)*100 as PercentPopulationInfected
FROM PortfolioProject..covid_deaths
ORDER BY 1,2

-- This query shows the maximum percent a county's population was infected durring the pandemic listed in descending order
-- Maximum infection count was included to give context to the percent infected

SELECT location, population, MAX(total_cases) as HighestInfectionCount, (MAX(total_cases/population))*100 as PercentPopulationInfected
FROM PortfolioProject..covid_deaths
GROUP BY Location, population
ORDER BY PercentPopulationInfected desc

-- Total death counts in each country listed in descending order

SELECT location, MAX(CAST(total_deaths as int)) as TotalDeathCount
FROM PortfolioProject..covid_deaths
WHERE continent is not null
GROUP BY Location
ORDER BY TotalDeathCount desc

-- Total death count of each continent listed in descending order

SELECT continent, MAX(CAST(total_deaths as int)) as TotalDeathCount
FROM PortfolioProject..covid_deaths
WHERE continent is not null
GROUP BY continent
ORDER BY TotalDeathCount desc

-- Global death percentage numbers by date

SELECT date, SUM(new_cases) as TotalCases, SUM(CAST(new_deaths as int)) as TotalDeaths, SUM(CAST(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
FROM PortfolioProject..covid_deaths
WHERE continent is not null
GROUP BY date
ORDER BY 1,2

-- Global death percentage totals

SELECT SUM(new_cases) as TotalCases, SUM(CAST(new_deaths as int)) as TotalDeaths, SUM(CAST(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
FROM PortfolioProject..covid_deaths
WHERE continent is not null
ORDER BY 1,2


-- Total population vs vaccinations per day
-- Used CTE to join two tables

WITH PopvsVac (Continent, Location, Date, Population, new_vaccinations, RollingPeopleVaccinated)
AS
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.date) AS RollingPeopleVaccinated
-- ,(RollingPeopleVaccinated/population)*100
FROM PortfolioProject..covid_deaths dea
JOIN PortfolioProject..covid_vaccinations vac
	ON dea.location = vac.location 
	AND dea.date = vac.date
WHERE dea.continent is not null
)
SELECT *,(RollingPeopleVaccinated/Population)*100
FROM PopvsVac

-- Created temp table to store percent population vaccinated

DROP TABLE if exists #PercentPopulationVaccinated
CREATE TABLE #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

INSERT INTO #PercentPopulationVaccinated
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.date) as RollingPeopleVaccinated
-- ,(RollingPeopleVaccinated/population)*100
FROM PortfolioProject..covid_deaths dea
JOIN PortfolioProject..covid_vaccinations vac
	ON dea.location = vac.location 
	AND dea.date = vac.date
WHERE dea.continent is not null

SELECT *,(RollingPeopleVaccinated/Population)*100
FROM #PercentPopulationVaccinated

--Created view to store data for later visualizations

CREATE VIEW PercentPopulationVaccinated as
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.date) as RollingPeopleVaccinated
-- ,(RollingPeopleVaccinated/population)*100
FROM PortfolioProject..covid_deaths dea
JOIN PortfolioProject..covid_vaccinations vac
	ON dea.location = vac.location 
	AND dea.date = vac.date
WHERE dea.continent is not null


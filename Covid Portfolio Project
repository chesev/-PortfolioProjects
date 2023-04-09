Select *
From PortfolioProject..CovidDeaths
Where continent is not null 
order by 3,4


-- Select Data that we are going to be starting with

SELECT
	Location, 
	date, 
	total_cases, 
	new_cases, 
	total_deaths, 
	population
FROM 
	PortfolioProject..CovidDeaths
WHERE 
	continent is not null 
ORDER BY 
	1,2

--------------------------------------------------------------------------------------------------------------------------------------------------------------------


-- Total Cases vs Total Deaths
-- Shows likelihood of dying if you contract covid in your country

SELECT 
	Location, 
	date, 
	total_cases,
	total_deaths, 
	(total_deaths/total_cases)*100 as DeathPercentage
FROM 
	PortfolioProject..CovidDeaths
WHERE 
	location like '%states%'
	and continent is not null 
ORDER BY 
	1,2

--------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Total Cases vs Population
-- Shows what percentage of population infected with Covid

SELECT 
	Location, 
	date, 
	Population, 
	total_cases,  
	(total_cases/population)*100 as PercentPopulationInfected
FROM 
	PortfolioProject..CovidDeaths
--WHERE location like '%states%'
ORDER BY 
	1,2

--------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Countries with Highest Infection Rate compared to Population

SELECT 
	Location, 
	Population, 
	MAX(total_cases) as HighestInfectionCount,  
	Max((total_cases/population))*100 as PercentPopulationInfected
FROM 
	PortfolioProject..CovidDeaths
--Where location like '%states%'
GROUP BY 
	Location, 
	Population
ORDER BY 
	PercentPopulationInfected desc

--------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Countries with Highest Death Count per Population

SELECT 
	Location, 
	MAX(cast(Total_deaths as int)) as TotalDeathCount
FROM 
	PortfolioProject..CovidDeaths
--WHERE location like '%states%'
WHERE 
	continent is not null 
GROUP BY 
	Location
ORDER BY 
	TotalDeathCount desc

--------------------------------------------------------------------------------------------------------------------------------------------------------------------


-- BREAKING THINGS DOWN BY CONTINENT

-- Showing contintents with the highest death count per population

SELECT 
	continent, 
	MAX(cast(Total_deaths as int)) as TotalDeathCount
FROM 
	PortfolioProject..CovidDeaths
--WHERE location like '%states%'
WHERE 
	continent is not null 
GROUP BY 
	continent
ORDER BY 
	TotalDeathCount desc

--------------------------------------------------------------------------------------------------------------------------------------------------------------------


-- GLOBAL NUMBERS

SELECT 
	--date,
	SUM(new_cases) as Total_cases, 
	SUM(new_deaths) as Total_deaths, 
	SUM(new_deaths)/SUM(new_cases)*100 as DeathPercentage 
	--SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
FROM 
	CovidDeaths
--Where location like '%states%'
WHERE 
	continent is not null
--GROUP BY date
ORDER BY 1,2

--------------------------------------------------------------------------------------------------------------------------------------------------------------------


-- Total Population vs Vaccinations
-- Shows Percentage of Population that has received at least one Covid Vaccine

SELECT 
	dea.continent,
	dea.location,
	dea.date,
	dea.population,
	vac.new_vaccinations,
	SUM(cast(vac.new_vaccinations as bigint)) 
	OVER (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
	--(RollingPeopleVaccinated/population)*100 
FROM CovidDeaths as dea
	JOIN CovidVaccinations as vac 
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent is not null
ORDER BY 2,3

--------------------------------------------------------------------------------------------------------------------------------------------------------------------


-- Using CTE to perform Calculation on Partition By in previous query

With PopvsVac (continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
as
(
SELECT 
	dea.continent,
	dea.location,
	dea.date,
	dea.population,
	vac.new_vaccinations,
	SUM(cast(vac.new_vaccinations as bigint)) 
	OVER (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
	--(RollingPeopleVaccinated/population)*100 
FROM CovidDeaths as dea
	JOIN CovidVaccinations as vac 
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent is not null
--ORDER BY 2,3
)

SELECT 
	*, 
	(RollingPeopleVaccinated/Population)*100 as PercentageOfPeopleVaccinated
FROM 
	PopvsVac

--------------------------------------------------------------------------------------------------------------------------------------------------------------------


-- TEMP TABLE
-- Using Temp Table to perform Calculation on Partition By in previous query

DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
SELECT 
	dea.continent,
	dea.location,
	dea.date,
	dea.population,
	vac.new_vaccinations,
	SUM(cast(vac.new_vaccinations as bigint)) 
	OVER (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
	--(RollingPeopleVaccinated/population)*100 
FROM CovidDeaths as dea
	JOIN CovidVaccinations as vac 
	ON dea.location = vac.location
	AND dea.date = vac.date
--WHERE dea.continent is not null
--ORDER BY 2,3

SELECT 
	*, 
	(RollingPeopleVaccinated/Population)*100
FROM 
	#PercentPopulationVaccinated
  
--------------------------------------------------------------------------------------------------------------------------------------------------------------------


-- Creating View to store data for later visualizations

Create View TotalCasesvsTotalDeaths as
SELECT 
	Location, 
	date, 
	total_cases,
	total_deaths, 
	(total_deaths/total_cases)*100 as DeathPercentage
FROM 
	PortfolioProject..CovidDeaths
WHERE 
	location like '%states%'
	and continent is not null 
--ORDER BY 1,2

SELECT 
	*
FROM 
	TotalCasesvsTotalDeaths

--------------------------------------------------------------------------------------------------------------------------------------------------------------------


-- VIEW for HighestInfectionRate_Country

Create View HighestInfectionRate_Country as

SELECT 
	Location, 
	Population, 
	MAX(total_cases) as HighestInfectionCount,  
	Max((total_cases/population))*100 as PercentPopulationInfected
FROM 
	PortfolioProject..CovidDeaths
--WHERE location like '%states%'
GROUP BY
	Location, 
	Population
--order by PercentPopulationInfected desc

SELECT 
	*
FROM 
	HighestInfectionRate_Country
ORDER BY 
	PercentPopulationInfected desc

--------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- VIEW for Countries with Highest Death Count per Population

Create View HighestDeathCount_Country as

SELECT 
	Location, 
	MAX(cast(Total_deaths as int)) as TotalDeathCount
FROM 
	PortfolioProject..CovidDeaths
--WHERE location like '%states%'
WHERE
	continent is not null 
GROUP BY 
	Location
--ORDER BY TotalDeathCount desc

SELECT 
	*
FROM 
	HighestDeathCount_Country
ORDER BY 
	TotalDeathCount desc
  
--------------------------------------------------------------------------------------------------------------------------------------------------------------------


-- VIEW for contintents with the highest death count per population

Create View DeathCount_Continent as

SELECT 
	continent, 
	MAX(cast(Total_deaths as int)) as TotalDeathCount
FROM 
	PortfolioProject..CovidDeaths
--WHERE location like '%states%'
WHERE 
	continent is not null 
GROUP BY 
	continent
-- ORDER BY TotalDeathCount desc

SELECT 
	*
FROM 
	DeathCount_Continent
ORDER BY 
	TotalDeathCount desc


--------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- VIEW for Global Numbers

Create View GlobalNumber as

SELECT
	--date,
	SUM(new_cases) as Total_cases, 
	SUM(new_deaths) as Total_deaths, 
	SUM(new_deaths)/SUM(new_cases)*100 as DeathPercentage 
	--SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
FROM 
	CovidDeaths
--WHERE location like '%states%'
WHERE 
	continent is not null
--GROUP BY date
--ORDER BY 1,2

SELECT 
	*
FROM 
	GlobalNumber


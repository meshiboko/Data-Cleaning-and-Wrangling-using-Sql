/*
Covid 19 Data Exploration 
Skills used: Joins, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types
*/

Select *
From CovidReport..CovidDeaths
Where continent is not null 
order by 3,4

Select *
From CovidReport..CovidVaccinations
Where continent is not null 
order by 3,4


-- Select Data that we are going to be starting with
--Summing up the total deaths vs the total population

Select YEAR (date) as years, SUM(CAST (total_deaths as bigint)) AS  deaths, 
SUM(CAST(population as bigint)) AS total_population, SUM(CAST(total_cases as bigint)) AS cases_reported
From CovidReport..CovidDeaths
Where location like '%kenya%'
GROUP BY YEAR(date)



-- Total Cases vs Total Deaths
-- Shows likelihood of dying if you contract covid in your country

Select Location, date,total_cases,total_deaths, cast(total_deaths/total_cases as float)*100 as DeathPercentage
From CovidReport..CovidDeaths
Where location like '%kenya%'
and continent is not null 
order by 1,2



-- Total Cases vs Population
-- Shows what percentage of population infected with Covid

Select continent, CAST(date AS DATE), Population, total_cases, (total_cases/population)*100 as PercentPopulationInfected
From CovidReport..CovidDeaths
Where continent is not null
--order by 1,2 
GROUP BY continent, CAST(date AS DATE), population, total_cases

--create column PercentPopulationInfected


-- The percentage of the Countries with Highest Infection Rate compared to Population

Select Location, Population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From CovidReport..CovidDeaths
Group by Location, Population
order by HighestInfectionCount desc


-- Countries with Highest Death Count per Population

Select Location, MAX(cast(Total_deaths as int)) as TotalDeathCount
From CovidReport..CovidDeaths
--Where location like '%states%'
Where continent is not null 
Group by Location
order by TotalDeathCount desc



-- BREAKING THINGS DOWN BY CONTINENT

-- Showing contintents with the highest death count per population

Select continent, MAX(cast(Total_deaths as int)) as TotalDeathCount
From CovidReport..CovidDeaths
--Where location like '%states%'
Where continent is not null 
Group by continent
order by TotalDeathCount desc



-- GLOBAL NUMBERS
Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From CovidReport..CovidDeaths
--Where location like '%states%'
where continent is not null 
--Group By date
order by 1,2



-- Total Population vs Vaccinations
-- Using inner join
-- Shows Percentage of Population that has recieved at least one Covid Vaccine
SELECT CovidDeaths.continent, CAST (CovidVaccinations.date AS DATE), CovidDeaths.population, 
(CovidVaccinations.total_vaccinations / CovidVaccinations.population )* 100 as  percentage_people_vaccinated 
FROM CovidReport.. CovidDeaths
INNER JOIN CovidReport.. CovidVaccinations
ON CovidDeaths.population=CovidVaccinations.population
WHERE CovidDeaths.continent is not null 




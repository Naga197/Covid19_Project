--select count(*) from CovidDeaths

select location ,DATE,total_cases,population,(total_cases/population)*100 as Deathpercentage
from CovidDeaths cd 
where location like '%states%'
order by 1,2 


-- death percentages by location

select location ,DATE,total_deaths,total_cases ,CAST(total_deaths as float)/CAST (total_cases as float)*100 as Deathpercentage
from CovidDeaths cd 
--where location like '%states%'
where continent is NOT NULL 
order by 1,2 DESC --



--select total cases and deaths by location

select Location,Date,total_cases,total_deaths,population
from CovidDeaths cd 
order by 1,2


--select testcases and vaccinations by location

select a.continent,a.location,a.date,a.population,b.new_vaccinations,
sum(CAST (b.new_vaccinations as int)) over (partition by a.location order by a.location,a.date) as RollingPeopleVaccinated
from CovidDeaths a, CovidVaccinations b 
where a.location=b.location
and a.date=b.date 
and a.continent is not NULL 
order by 2,3


--percentage of rolling population vaccinated


With popvsvac(continent,location,date,population,new_vaccinations,RollingPeopleVaccinated)
as(
select a.continent,a.location,a.date,a.population,b.new_vaccinations,
sum(CAST (b.new_vaccinations as int)) over (partition by a.location order by a.location,a.date) as RollingPeopleVaccinated
from CovidDeaths a, CovidVaccinations b 
where a.location=b.location
and a.date=b.date 
and a.continent is not NULL 
--order by 2,3
)
select *,cast(RollingPeopleVaccinated as float)/population*100
from popvsvac 
--

--using temp table

create temporary table percentpopulationvaccinated
(continent nvarchar(255),
location nvarchar(255),
date nvarchar(255),
population numeric,
new_vaccinations numeric,
RollingPeopleVaccinated numeric
)
Insert into percentpopulationvaccinated
select a.continent,a.location,a.date,a.population,b.new_vaccinations,
sum(CAST (b.new_vaccinations as int)) over (partition by a.location order by a.location,a.date) as RollingPeopleVaccinated
from CovidDeaths a, CovidVaccinations b 
where a.location=b.location
and a.date=b.date 
and a.continent is not NULL 

--create VIEW 

Create View Percentpopulationvaccinated as
select a.continent,a.location,a.date,a.population,b.new_vaccinations,
sum(CAST (b.new_vaccinations as int)) over (partition by a.location order by a.location,a.date) as RollingPeopleVaccinated
from CovidDeaths a, CovidVaccinations b 
where a.location=b.location
and a.date=b.date 
and a.continent is not NULL 


select * from percentpopulationvaccinated




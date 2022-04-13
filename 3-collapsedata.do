****set working directory to folder with data to analyze***


***following loop collapses data for all respondents reporting a recent screen and collapses data for all respondents asked about a recent screen****
foreach i in  sum  count{

clear all 

***use data***

global outcomes mam_yr pap_yr bloodst_yr colsig_yr 

drop if svywave==2017 | svywave==2019
drop if year==2021 | year==2019

keep if year==2020 | year==2018
tab year

sum $outcomes if year==2020
sum $outcomes if year==2018


collapse (`i') $outcomes [pw=perwt], by(edate statefips rucca)

***save new collapsd data***
clear all 

}

***repeat analysis replacing rucca with "male"****

***repeat analysis with by(edate statefips)****
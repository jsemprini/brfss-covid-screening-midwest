
***set outcomes***
global outcomes mam_yr pap_yr bloodst_yr colsig_yr 


***set working director

clear all
foreach i in sum count  {

***use full, rucca, or male collapased data***

***keep midwest states***
keep if statefips==19 | statefips==18 | statefips==17 | statefips==20 | statefips==26 | statefips==27 | statefips==29 | statefips==31 | statefips==38 | statefips==39 | statefips==46 | statefips==55 


global outcomes mam_yr pap_yr bloodst_yr colsig_yr 
			


	gen quarter=.
	replace quarter=1 if edate<=d(30mar2018)
	replace quarter=2 if edate>=d(01oct2018) & edate<d(01jan2020)
	replace quarter=3 if edate>=d(01jan2020) & edate<=d(30mar2020)
	replace quarter=4 if edate>=d(01oct2020)
	


sort quarter statefips rucca
		  
by quarter statefips rucca: eststo: estpost summarize $outcomes, listwise 
esttab  using "SAVENEWFILE",  label replace cells(sum) 

	estimates clear

	
	
}



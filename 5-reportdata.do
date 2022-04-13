clear all 

***estab files must be transposed before importing***

***import transposed results***

tostring(year), force replace
tostring(quarter), force replace

gen id=year+quarter

destring(id), force replace

drop year quarter

reshape wide sum_mam_yr sum_pap_yr sum_bloodst_yr sum_colsig_yr count_mam_yr count_pap_yr count_bloodst_yr count_colsig_yr prop_mam_yr prop_pap_yr prop_bloodst_yr prop_colsig_yr , i(state group subgroup) j(id)


foreach x in sum_mam_yr sum_pap_yr sum_bloodst_yr sum_colsig_yr count_mam_yr count_pap_yr count_bloodst_yr count_colsig_yr prop_mam_yr prop_pap_yr prop_bloodst_yr prop_colsig_yr {
	
	gen `x'predif=`x'20184-`x'20181
	gen `x'postdif=`x'20204-`x'20201
	gen `x'dd=`x'postdif-`x'predif
	gen `x'change=`x'dd/`x'20201
	
	
}

 

foreach x in dd change{
	global outcomes`x' prop_mam_yr`x' prop_pap_yr`x' prop_bloodst_yr`x' prop_colsig_yr`x'

}

***set cd****

***by state***

estimates clear

sort state
by state: eststo: estpost summarize $outcomesdd if group=="full" & subgroup=="all", listwise 
by state: eststo: estpost summarize $outcomeschange if group=="full" & subgroup=="all", listwise 

esttab  using "SAVETABLE.csv",  label replace cells(sum(fmt(3)))




***by state & rural mam/pap***

estimates clear

sort state subgroup

by state subgroup: eststo: estpost summarize prop_mam_yrdd prop_pap_yrdd if group=="region" , listwise 
by state subgroup: eststo: estpost summarize prop_mam_yrchange prop_pap_yrchange if group=="region" , listwise 

esttab  using "SAVERESULTSTABLE.csv",  label replace cells(sum(fmt(3)))


estimates clear

sort state subgroup

by state subgroup: eststo: estpost summarize prop_bloodst_yrdd prop_colsig_yrdd if group=="region" , listwise 
by state subgroup: eststo: estpost summarize prop_bloodst_yrchange prop_colsig_yrchange if group=="region", listwise 

esttab  using "SAVERESULTSTABLE.csv",  label replace cells(sum(fmt(3)))


***by state & gender/rural colorectal***

estimates clear

sort state subgroup
by state subgroup: eststo: estpost summarize prop_bloodst_yrdd prop_colsig_yrdd if group=="sex", listwise 
by state subgroup: eststo: estpost summarize prop_bloodst_yrchange prop_colsig_yrchange if group=="sex", listwise 

esttab  using "SAVERESULTSTABLE.csv",  label replace cells(sum(fmt(3)))





*****graphs****
****by state***

foreach x in mam pap bloodst colsig{
graph bar (mean) prop_`x'_yrdd prop_`x'_yrchange if group=="full", over(state) ylabel(-0.80(0.4)0.8)
graph save state`x'.gph, replace

}

graph combine statemam.gph statepap.gph statebloodst.gph statecolsig.gph, ycommon

graph save f1state.gph, replace




****by state, gender crc***
foreach x in bloodst colsig{
graph bar (mean) prop_`x'_yrdd prop_`x'_yrchange if group=="sex", over(subgroup) by(state) ylabel(-0.80(0.4)0.8)
graph save gender`x'.gph, replace

}

graph combine genderbloodst.gph gendercolsig.gph, ycommon

graph save f2gendercrc.gph, replace


****by state, rural crc***

replace subgroup="r" if subgroup=="rural"
replace subgroup="u" if subgroup=="urban"
replace subgroup="m" if subgroup=="metro"

gen rurlab=.
replace rurlab=1 if subgroup=="m" & group=="region"
replace rurlab=2 if subgroup=="u"
replace rurlab=3 if subgroup=="r"

foreach x in bloodst colsig{
graph bar (mean) prop_`x'_yrdd prop_`x'_yrchange if group=="region", over(rurlab, relabel(1 m 2 u 3 r))  by(state) ylabel(-0.80(0.4)0.8)
graph save rural`x'.gph, replace

}

graph combine ruralbloodst.gph ruralcolsig.gph, ycommon

graph save f3ruralcrc.gph, replace


***state rural, pap/mam***

foreach x in mam pap{
graph bar (mean) prop_`x'_yrdd prop_`x'_yrchange if group=="region", over(rurlab, relabel(1 m 2 u 3 r))  by(state) ylabel(-0.80(0.4)0.8)
graph save rural`x'.gph, replace

}

graph combine ruralmam.gph ruralpap.gph, ycommon

graph save f3ruralmampap.gph, replace







clear all

***set working directory of BRFSS datasets (2018-2020)****

***the following code 1) imports each brfss datafile and extracts listed variables***
local satafiles: dir . files "*.dta"
foreach file of local satafiles { 

preserve
use `file', clear
gen filename =  regexr("`file'", "_.20", "")

#delimit;
isvar
genhlth
physhlth
menthlth
poorhlth
hlthplan
hlthpln1
medcost
checkup
checkup1
persdoc2
smoke100
smokday2
stopsmok
stopsmk2
drnkany4
drnkany5
alcdays
alcday3
alcday4
alcday5
avedrnk2
drinkge5
drnk2ge5
drnk3ge5
maxdrnks
drocdy2_
drocdy3_
_rfbing3
_rfbing4
_rfbing5
_bmi4
_bmi5
_ageg5yr
chld04
chld0512
chld1317
children
educa
employ
employ1
income2
marital
numadult
sex
_racegr
diabetes
diabete2
diabete3
_state idate imonth iday iyear dispcode seqno _psu
_finalwt
mscode
_llcpwt
hadmam*
howlong*
hadpap*
lastpap*
bldstool*
lstblds*
bldstol1
hadsigm*
lastsigm*
lastsig*
hadsgcol*
colnscpy
colntest
sigmscpy
sigmtest
hpv*
hpl*
csrvc*
csrvdoc*
csrvt*
chcs*
chco*
cncrt*
cncra*
cncrh*
lcsctscn
_metstat
_urbstat
hlthcvr
hlthcvr1

;


#delimit cr

keep `r(varlist)' filename

save temp, replace
restore
append using temp, force
}
erase temp.dta

****save new datafile****
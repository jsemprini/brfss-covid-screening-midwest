clear all 

****use new datafile****

***basic changes***

destring imonth iday iyear, replace

gen svywave=substr(filename,6,4)
destring svywave, replace


gen perwt=.
replace perwt=_finalwt if svywave<=2010
replace perwt=_llcpwt  if svywave>=2011
drop _finalwt _llcpwt

replace _racegr3=_racegr2 if svywave<=2012
drop _racegr2
rename _racegr3 race

rename _ageg5yr age

drop filename

rename _state statefips


rename iyear year
rename imonth month
rename iday day
rename idate date

label define STATEFIP 1 `"alabama"', modify
label define STATEFIP 2 `"alaska"', modify
label define STATEFIP 4 `"arizona"', modify
label define STATEFIP 5 `"arkansas"', modify
label define STATEFIP 6 `"california"', modify
label define STATEFIP 8 `"colorado"', modify
label define STATEFIP 9 `"connecticut"', modify
label define STATEFIP 10 `"delaware"', modify
label define STATEFIP 11 `"district of columbia"', modify
label define STATEFIP 12 `"florida"', modify
label define STATEFIP 13 `"georgia"', modify
label define STATEFIP 15 `"hawaii"', modify
label define STATEFIP 16 `"idaho"', modify
label define STATEFIP 17 `"illinois"', modify
label define STATEFIP 18 `"indiana"', modify
label define STATEFIP 19 `"iowa"', modify
label define STATEFIP 20 `"kansas"', modify
label define STATEFIP 21 `"kentucky"', modify
label define STATEFIP 22 `"louisiana"', modify
label define STATEFIP 23 `"maine"', modify
label define STATEFIP 24 `"maryland"', modify
label define STATEFIP 25 `"massachusetts"', modify
label define STATEFIP 26 `"michigan"', modify
label define STATEFIP 27 `"minnesota"', modify
label define STATEFIP 28 `"mississippi"', modify
label define STATEFIP 29 `"missouri"', modify
label define STATEFIP 30 `"montana"', modify
label define STATEFIP 31 `"nebraska"', modify
label define STATEFIP 32 `"nevada"', modify
label define STATEFIP 33 `"new hampshire"', modify
label define STATEFIP 34 `"new jersey"', modify
label define STATEFIP 35 `"new mexico"', modify
label define STATEFIP 36 `"new york"', modify
label define STATEFIP 37 `"north carolina"', modify
label define STATEFIP 38 `"north dakota"', modify
label define STATEFIP 39 `"ohio"', modify
label define STATEFIP 40 `"oklahoma"', modify
label define STATEFIP 41 `"oregon"', modify
label define STATEFIP 42 `"pennsylvania"', modify
label define STATEFIP 44 `"rhode island"', modify
label define STATEFIP 45 `"south carolina"', modify
label define STATEFIP 46 `"south dakota"', modify
label define STATEFIP 47 `"tennessee"', modify
label define STATEFIP 48 `"texas"', modify
label define STATEFIP 49 `"utah"', modify
label define STATEFIP 50 `"vermont"', modify
label define STATEFIP 51 `"virginia"', modify
label define STATEFIP 53 `"washington"', modify
label define STATEFIP 54 `"west virginia"', modify
label define STATEFIP 55 `"wisconsin"', modify
label define STATEFIP 56 `"wyoming"', modify
label define STATEFIP 61 `"maine-new hampshire-vermont"', modify
label define STATEFIP 62 `"massachusetts-rhode island"', modify
label define STATEFIP 63 `"minnesota-iowa-missouri-kansas-nebraska-s.dakota-n.dakota"', modify
label define STATEFIP 64 `"maryland-delaware"', modify
label define STATEFIP 65 `"montana-idaho-wyoming"', modify
label define STATEFIP 66 `"utah-nevada"', modify
label define STATEFIP 67 `"arizona-new mexico"', modify
label define STATEFIP 68 `"alaska-hawaii"', modify
label define STATEFIP 72 `"puerto rico"', modify
label define STATEFIP 97 `"military/mil. reservation"', modify
label define STATEFIP 99 `"state not identified"', modify

label values statefips STATEFIP

gen iowa=.
replace iowa=0 if statefips!=19
replace iowa=1 if statefips==19

drop diabete3

order statefips iowa date month day year svywave dispcode seqno _psu perwt _racegr race age sex sex1 _metstat _urbstat mscode

****create analytic variables***

*mammogram*
gen mam_ever=.
replace mam_ever=0 if hadmam==2
replace mam_ever=1 if hadmam==1

gen mam_yr=.
replace mam_yr=0 if mam_ever==0 | (howlong>=2 & howlong<7)
replace mam_yr=1 if howlong==1

*pap smear*

gen pap_ever=.
replace pap_ever=0 if (hadpap==2 & svywave<2004) | (hadpap2==2 & svywave>=2004)
replace pap_ever=1 if (hadpap==1 & svywave<2004) | (hadpap2==1 & svywave>=2004)

gen pap_yr=.
replace pap_yr=0 if pap_ever==0 | (svywave<2004 & lastpap>=2 & lastpap<7) |  (svywave>=2004 & lastpap2>=2 & lastpap2<7)
replace pap_yr=1 if (svywave<2004 & lastpap==1) |  (svywave>=2004 & lastpap2==1)

*bloodstool, colonoscopy, sigmodoscopy*

gen bloodst_ever=.
replace bloodst_ever=0 if bldstool==2 & svywave<2020
replace bloodst_ever=0 if bldstol1==2 & svywave==2020
replace bloodst_ever=1 if bldstool==1 & svywave<2020
replace bloodst_ever=1 if bldstol1==1 & svywave==2020 

gen bloodst_yr=.
replace bloodst_yr=0 if bloodst_ever==0 | (lstbldst>=2 & lstbldst<7 & svywave==2000) | (lstblds2>=2 & lstblds2<7 & svywave>2000 & svywave<=2007) | (lstblds3>=2 & lstblds3<7 & svywave>2007 & svywave<=2019) | (lstblds4>=2 & lstblds4<7 & svywave==2020) 
replace bloodst_yr=1 if bloodst_ever==0 | (lstbldst==1 & svywave==2000) | (lstblds2==1 & svywave>2000 & svywave<=2007) | (lstblds3==1 &  svywave>2007 & svywave<=2019) | (lstblds4==1 &  svywave==2020) 

gen colsig_ever=.
replace colsig_ever=0 if (hadsigm==2 & svywave==2000) | (hadsigm2==2 & svywave>2000 & svywave<=2003) | (hadsigm3==2 &  svywave>2003 & svywave<=2019) 
replace colsig_ever=0 if svywave==2020 & (colnscpy==2 & sigmscpy==2)


replace colsig_ever=1 if (hadsigm==1 & svywave==2000) | (hadsigm2==1 & svywave>2000 & svywave<=2003) | (hadsigm3==1 &  svywave>2003 & svywave<=2019) 
replace colsig_ever=1 if svywave==2020 & (colnscpy==1 | sigmscpy==1)

gen colsig_yr=.
replace colsig_yr=0 if colsig_ever==0
replace colsig_yr=0 if (lastsigm>=2 & lastsigm<7 & svywave==2000) | (lastsig2>=2 & lastsig2<7 & svywave>2000 & svywave<=2008) | (lastsig3>=2 & lastsig3<7 & svywave>2008 & svywave<=2019)
replace colsig_yr=0 if svywave==2020 & (colntest>=2 & colntest<7 & sigmtest>=2 & sigmtest<7)

replace colsig_yr=1 if (lastsigm==1 &  svywave==2000) | (lastsig2==1 & svywave>2000 & svywave<=2008) | (lastsig3==1 & svywave>2008 & svywave<=2019)
replace colsig_yr=1 if svywave==2020 & (colntest==1 | sigmtest==1)

*lung ct*

gen lct_yr=.
replace lct_yr=0 if lcsctscn==2 | lcsctscn==3
replace lct_yr=1 if lcsctscn==1

*hpv*

gen hpvax_ever=.
replace hpvax_ever=0 if (hpvadvc==2 | hpvadvc==3) | (hpvadvc2==2 | hpvadvc2==3) | (hpvadvc3==2 | hpvadvc3==3) | (hpvadvc4==2 | hpvadvc4==3)
replace hpvax_ever=1 if hpvadvc==1 | hpvadvc2==1 | hpvadvc3==1 | hpvadvc4==1

gen hpvax_n=.
replace hpvax_n=0 if hpvax_ever==0
replace hpvax_n=1 if hpvadsht==1
replace hpvax_n=2 if hpvadsht==2
replace hpvax_n=3 if hpvadsht==3

gen hpvax_full=.
replace hpvax_full=0 if hpvax_n>=0 & hpvax_n<=2
replace hpvax_full=1 if hpvax_n==3

gen hpvtest_ever=. 
replace hpvtest_ever=0 if hpvtest==2
replace hpvtest_ever=1 if hpvtest==1

gen hpvtest_yr=.
replace hpvtest_yr=0 if hplsttst>1 & hplsttst<=5
replace hpvtest_yr=1 if hplsttst==1

*cancer treat*

gen clintri=.
replace clintri=0 if csrvclin==2
replace clintri=1 if csrvclin==1

gen currenttreat=.
replace currenttreat=0 if csrvtrt>=2 & csrvtrt<7 & (svywave>=1009 & svywave<=2010)
replace currenttreat=1 if csrvtrt==1  & (svywave>=1009 & svywave<=2010)

replace currenttreat=0 if (csrvtrt1>=2 & csrvtrt1<7 & svywave<2017) | (csrvtrt2>=2 & csrvtrt2<7 & svywave>=2017 & svywave<2019) | (csrvtrt3>=2 & csrvtrt3<7 & svywave>=2019)

replace currenttreat=1 if (csrvtrt1==1 & svywave<2017) | (csrvtrt2==1 & svywave>=2017 & svywave<2019) | (csrvtrt3==1 & svywave>=2019)

gen notstart=.
replace notstart=0 if currenttreat==1
replace notstart=0 if csrvtrt!=4 & csrvtrt!=. & csrvtrt!=7 & csrvtrt!=9
replace notstart=0 if csrvtrt1!=4 & csrvtrt1!=. & csrvtrt1!=7 & csrvtrt1!=9
replace notstart=0 if csrvtrt2!=4 & csrvtrt2!=. & csrvtrt2!=7 & csrvtrt2!=9
replace notstart=0 if csrvtrt3!=4 & csrvtrt3!=. & csrvtrt3!=7 & csrvtrt3!=9

replace notstart=1 if csrvtrt==4
replace notstart=1 if csrvtrt1==4
replace notstart=1 if csrvtrt2==4
replace notstart=1 if csrvtrt3==4

gen typedoc=.
replace typedoc=csrvdoc if csrvdoc>=1 & csrvdoc<=10
replace typedoc=csrvdoc1 if csrvdoc!=. & csrvdoc1>=1 & csrvdoc1<=10

*cancer diagnosis*

gen skincancer=.
replace skincancer=0 if chcscncr==2
replace skincancer=0 if cncrtype!=20 & cncrtype!=21 & cncrtype>=1 & cncrtype<=30
replace skincancer=0 if cncrtyp1!=20 & cncrtyp1!=21 & cncrtyp1>=1 & cncrtyp1<=30
replace skincancer=1 if chcscncr==1
replace skincancer=1 if cncrtype==20 | cncrtype==21 | cncrtyp1==20 | cncrtyp1==21

gen othercancer=.
replace othercancer=0 if cncrhave==2 | chcocncr==2
replace othercancer=0 if cncrtype<1 | cncrtype>30 | cncrtyp1<1 | cncrtyp1>30
replace othercancer=1 if cncrhave==1 | chcocncr==1
replace othercancer=1 if (cncrtype>=1 & cncrtype<=30) | (cncrtyp1>=1 & cncrtyp1<=30)

gen anycancer=.
replace anycancer=0 if skincancer==0 & othercancer==0
replace anycancer=1 if skincancer==1 | othercancer==1

gen cancertype=.
foreach n of numlist 1/29{
    replace cancertype=`n' if cncrtype==`n'
	
}

foreach n of numlist 1/8{
    replace cancertype=`n' if cncrtyp1==`n'
	
}

gen cncrtype2=cncrtyp1-1

replace cancertype=7 if cncrtyp1==9

foreach n of numlist 10/29{
    replace cancertype=`n' if cncrtype2==`n'
	
}

gen cancergroup=.
replace cancergroup=1 if cancertype>=5 & cancertype<=7
replace cancergroup=2 if cancertype>=19 & cancertype<=14
replace cancergroup=3 if cancertype==23
replace cancergroup=4 if skincancer==1
replace cancergroup=5 if cancertype==1
replace cancergroup=6 if cancertype==2 | cancertype==4
replace cancergroup=7 if cancertype==18 | cancertype==19
replace cancergroup=8 if cancergroup==. & cancertype!=.

gen recentcancer=.
replace recentcancer=0 if age==1 & (cncrage<18) & cncrage!=.
replace recentcancer=1 if age==1 & (cncrage>=18)  & cncrage!=.

replace recentcancer=0 if age==2 & (cncrage<25)  & cncrage!=.
replace recentcancer=1 if age==2 & (cncrage>=25)  & cncrage!=.

replace recentcancer=0 if age==3 & (cncrage<30)  & cncrage!=.
replace recentcancer=1 if age==3 & (cncrage>=30)  & cncrage!=.

replace recentcancer=0 if age==4 & (cncrage<35)  & cncrage!=.
replace recentcancer=1 if age==4 & (cncrage>=35)  & cncrage!=.

replace recentcancer=0 if age==5 & (cncrage<40)  & cncrage!=.
replace recentcancer=1 if age==5 & (cncrage>=40)  & cncrage!=.

replace recentcancer=0 if age==6 & (cncrage<45)  & cncrage!=.
replace recentcancer=1 if age==6 & (cncrage>=45)  & cncrage!=.

replace recentcancer=0 if age==7 & (cncrage<50)  & cncrage!=.
replace recentcancer=1 if age==7 & (cncrage>=50)  & cncrage!=.
 
replace recentcancer=0 if age==8 & (cncrage<55)  & cncrage!=.
replace recentcancer=1 if age==8 & (cncrage>=5)  & cncrage!=.

replace recentcancer=0 if age==9 & (cncrage<60)  & cncrage!=.
replace recentcancer=1 if age==9 & (cncrage>=60)  & cncrage!=.

replace recentcancer=0 if age==10 & (cncrage<65)  & cncrage!=.
replace recentcancer=1 if age==10 & (cncrage>=65)  & cncrage!=.

replace recentcancer=0 if age==11 & (cncrage<70)  & cncrage!=.
replace recentcancer=1 if age==11 & (cncrage>=70)  & cncrage!=.

replace recentcancer=0 if age==12 & (cncrage<75)  & cncrage!=.
replace recentcancer=1 if age==12 & (cncrage>=75)  & cncrage!=.



gen covid=.
replace covid=0 if year<2020 | (year==2020 & month<3) | (year==2020 & month==3 & day<11)
replace covid=1 if year==2020 & month==3 & day>=11
replace covid=1 if year==2020 & month>=3
replace covid=1 if year>2020


gen nonmetro=.
replace nonmetro=0 if _metstat==1
replace nonmetro=1 if _metstat==2

gen rural=.
replace rural=0 if _urbstat==1
replace rural=1 if _urbstat==2

gen urban=.
replace urban=0 if rural==1 | nonmetro==0
replace urban=1 if rural==0 & nonmetro==1

gen metro=.
replace metro=0 if _metstat==2
replace metro=1 if _metstat==1

gen edate = mdy(month, day, year)

format edate %d

gen male=.
replace male=1 if sex==1 | sex1==1 | sexvar==1
replace male=0 if sex==2 | sex1==2 | sexvar==2

gen rucca=.
replace rucca=1 if metro==1
replace rucca=2 if urban==1
replace rucca=3 if rural==1




****save final dataset to analyze****

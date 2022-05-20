* This script is prepared for running the main regression analysis 
* Author: Jiehong Lou 



******************************
* Section one  Regression model
******************************

clear
import delimited "cobenefit.csv", encoding(ISO-8859-1)
encode hostcountry, generate(hlocation) label(location)
encode firstcountry, generate(hbuyercountry) label(buyercountry)
encode type, generate(hprojecttype) label(projecttype)
encode firstcompany, generate(hbuyercompany) label(buyercompany)
encode cobnefits, generate(cobenefit) label(cobenefit)

drop if cobnefits=="."

*labelling variables 
label variable yrs   "Years of projects" 
label variable stperiodktco2eyr   "1st period ktCO2e/yr" 
label variable expectedaccumulated2020ktco2e  "Expected accumulated 2020 ktCO2e"
label variable investmentmus "Investment"

replace cobenefit= 9 if cobenefit== 7
replace cobenefit= 7 if cobenefit== 8
replace cobenefit= 8 if cobenefit== 9

gen cer_log = log(cer)
reg cer i.cobenefit i.year i.hlocation i.hbuyercountry stperiodktco2eyr yrs treat expectedaccumulated2020ktco2e expectedaccumulated2030ktco2e investmentmus 
est sto m1
reg cer i.cobenefit i.year i.hprojecttype i.hlocation i.hbuyercountry stperiodktco2eyr yrs treat expectedaccumulated2020ktco2e expectedaccumulated2030ktco2e investmentmus 
est sto m2
reg cer i.cobenefit i.year i.hprojecttype psize i.hlocation i.hbuyercountry stperiodktco2eyr yrs treat expectedaccumulated2020ktco2e expectedaccumulated2030ktco2e investmentmus 
est sto m3
reg cer_log i.cobenefit i.year i.hprojecttype psize i.hlocation i.hbuyercountry stperiodktco2eyr yrs treat expectedaccumulated2020ktco2e expectedaccumulated2030ktco2e investmentmus 
est sto m4
esttab m1 m2 m3 m4, starlevel(* 0.10 ** 0.05 *** 0.01)  label nonumber title("Paper 1 log Regression ") mtitle("Model 1" "Model 2" "Model3" "Model4"), using paper1fullregressionlog.csv, replace se



* coeffient bar figure 
tab cobenefit, gen(CB)
matrix beta=J(8,3,0)

quietly reg cer CB2-CB8 i.year i.hprojecttype psize i.hlocation i.hbuyercountry stperiodktco2eyr yrs treat expectedaccumulated2020ktco2e expectedaccumulated2030ktco2e investmentmus 

foreach y of numlist 2/8{
quietly lincom CB`y'
matrix beta[`y',1]=`y'
matrix beta[`y',2]=r(estimate)
matrix beta[`y',3]=r(se)
}

svmat beta
keep beta*
keep if beta1!=.
rename beta1 cobenefit
rename beta2 beta
rename beta3 se
gen lo=beta-1.96*(se)
gen hi=beta+1.96*(se)
replace cobenefit = 1 in 1
gen n=_n
twoway rcap lo hi cobenefit, xlabel(1 "Cobenefit1" 2 "Cobenefit2" 3 "Cobenefit3" 4 "Cobenefit4" 5 "Cobenefit5" 6 "Cobenefit6" 7 "Cobenefit7" 8"Cobenefit8", angle(vertical) labsize(small)) lcolor(dkorange) lwidth(thick) ytitle("$/CO2e", size(small)) ylabel(-0.5(1)6.5,nogrid labsize(small)) plotregion(style(none)) graphregion(fcolor(white)) legend(off) || scatter beta cobenefit, ms(Oh) msize(large) mcolor(black) xtitle(" ") yline(0)
graph export "p1.eps", replace as(eps)



**********************
* natural log
**********************

clear
import delimited "cobenefit7.csv", encoding(ISO-8859-1)
encode hostcountry, generate(hlocation) label(location)
encode firstcountry, generate(hbuyercountry) label(buyercountry)
encode type, generate(hprojecttype) label(projecttype)
encode firstcompany, generate(hbuyercompany) label(buyercompany)
encode cobnefits, generate(cobenefit) label(cobenefit)

drop if cobnefits=="."

*labelling variables 
label variable yrs   "Years of projects" 
label variable stperiodktco2eyr   "1st period ktCO2e/yr" 
label variable expectedaccumulated2020ktco2e  "Expected accumulated 2020 ktCO2e"
label variable investmentmus "Investment"


replace cobenefit= 9 if cobenefit== 7
replace cobenefit= 7 if cobenefit== 8
replace cobenefit= 8 if cobenefit== 9

gen cer_log = log(cer)
reg cer_log i.cobenefit i.year i.hlocation i.hbuyercountry stperiodktco2eyr yrs treat expectedaccumulated2020ktco2e expectedaccumulated2030ktco2e investmentmus 
est sto m1
reg cer_log i.cobenefit i.year i.hprojecttype i.hlocation i.hbuyercountry stperiodktco2eyr yrs treat expectedaccumulated2020ktco2e expectedaccumulated2030ktco2e investmentmus 
est sto m2
reg cer_log i.cobenefit i.year i.hprojecttype psize i.hlocation i.hbuyercountry stperiodktco2eyr yrs treat expectedaccumulated2020ktco2e expectedaccumulated2030ktco2e investmentmus 
est sto m3
esttab m3, starlevel(* 0.10 ** 0.05 *** 0.01)  label nonumber title("Paper 1 log Regression ") mtitle("Model 1"), using paper1fullregressionlog.csv, replace se


* coeffient bar figure 
tab cobenefit, gen(CB)
matrix beta=J(8,3,0)

quietly reg cer_log CB2-CB8 i.year i.hprojecttype psize i.hlocation i.hbuyercountry stperiodktco2eyr yrs treat expectedaccumulated2020ktco2e expectedaccumulated2030ktco2e investmentmus 

foreach y of numlist 2/8{
quietly lincom CB`y'
matrix beta[`y',1]=`y'
matrix beta[`y',2]=r(estimate)
matrix beta[`y',3]=r(se)
}

svmat beta
keep beta*
keep if beta1!=.
rename beta1 cobenefit
rename beta2 beta
rename beta3 se
gen lo=beta-1.96*(se)
gen hi=beta+1.96*(se)
replace cobenefit = 1 in 1

twoway rcap lo hi cobenefit, ///
xlabel(1 "Cobenefit1" 2 "Cobenefit2" 3 "Cobenefit3" 4 "Cobenefit4" 5 "Cobenefit5" 6 "Cobenefit6" 7 "Cobenefit7" 8"Cobenefit8", ///
angle(vertical) labsize(small)) lcolor(dkorange) lwidth(thick) ytitle("Log CER price unit $/CO2e", size(small)) ///
ylabel(-0.1 (0.2)0.5,nogrid labsize(small)) plotregion(style(none)) graphregion(fcolor(white)) legend(off) || ///
scatter beta cobenefit, ms(Oh) msize(large) mcolor(black) xtitle(" ") yline(0)
graph export "p2.eps", replace as(eps)



clear

*******************************
*sectoral analysis 
*******************************
clear 
import delimited "buyercompany.csv", encoding(ISO-8859-1)
encode sector, generate(comsector) label(companysector)
encode industry, generate(comindustry) label(companyindustry)
encode buyerstat, generate(combuyerstat) label(companybuyerstat)
encode location, generate(hlocation) label(location)
encode locationregion, generate(hlocationregion) label(locationregion)
encode buyercountry, generate(combuyercountry) label(buyercountry)
encode subregion, generate(hlocationsubregion) label(locationsubregion)

reg cer projectnumber i.comsector i.comindustry i.combuyerstat psize 
reg cer projectnumber i.comsector i.combuyerstat psize i.hlocation i.hlocationregion treat
reg cer projectnumber i.comsector i.combuyerstat psize  i.hlocationregion treat
reg cer projectnumber i.combuyerstat psize  i.hlocationregion treat
reg cer projectnumber i.comsector psize  i.hlocationregion treat i.combuyercountry


reg cer projectnumber i.comsector psize  i.hlocationregion treat i.combuyercountry  
reg cer projectnumber i.combuyerstat psize  i.hlocationregion treat i.combuyercountry  

*using country instead of region 
reg cer projectnumber i.comsector psize  i.hlocation treat i.combuyercountry  
est sto m1
reg cer projectnumber i.combuyerstat psize  i.hlocation treat i.combuyercountry 
est sto m2
reg cer projectnumber i.combuyerstat i.comsector psize  i.hlocation treat i.combuyercountry 
est sto m3
esttab m1 m2 m3, starlevel(* 0.10 ** 0.05 *** 0.01)  label nonumber title("Paper 1 Sectoral Sector ") mtitle("Model 1" "Model 2" "Model 3"), using paper1sectoralsector.csv, replace se

reg cer projectnumber i.comsector psize  ib2.hlocation treat i.combuyercountry  

gen cer_log = log(cer)
reg cer_log projectnumber i.comsector psize  i.hlocationregion treat i.combuyercountry  
reg cer_log projectnumber i.combuyerstat psize  i.hlocationregion treat i.combuyercountry  

*using country instead of region 
reg cer_log projectnumber i.comsector psize  i.hlocation treat i.combuyercountry  
est sto m1
reg cer_log projectnumber i.combuyerstat psize  i.hlocation treat i.combuyercountry  
est sto m2
reg cer_log projectnumber i.combuyerstat i.comsector psize  i.hlocation treat i.combuyercountry 
est sto m3 

esttab m1 m2 m3, starlevel(* 0.10 ** 0.05 *** 0.01)  label nonumber title("Paper 1 Sectoral status ") mtitle("Model 1" "Model 2" "Model 3"), using paper1sectoralstatus.csv, replace se

****************************************
* aggregation level at region
clear 
import delimited "buyercompany.csv", encoding(ISO-8859-1)
encode sector, generate(comsector) label(companysector)
encode industry, generate(comindustry) label(companyindustry)
encode buyerstat, generate(combuyerstat) label(companybuyerstat)
encode location, generate(hlocation) label(location)
encode locationregion, generate(hlocationregion) label(locationregion)
encode buyercountry, generate(combuyercountry) label(buyercountry)
encode subregion, generate(hlocationsubregion) label(locationsubregion)

gen cer_log = log(cer)

reg cer projectnumber i.combuyerstat i.comsector psize  asiapacificp latinamericap  middleeastp europecentralasiap africap treat i.combuyercountry 
est sto m1
reg cer_log projectnumber i.combuyerstat i.comsector  psize asiapacificp latinamericap  middleeastp europecentralasiap africap treat i.combuyercountry
est sto m2 
esttab m1 m2, starlevel(* 0.10 ** 0.05 *** 0.01)  label nonumber title("Paper 1 Sectoral Agg Region ") mtitle("Model 1" "Model 2"), using paper1sectoralaggregion.csv, replace se

reg cer projectnumber ib1.combuyerstat ib7.comsector psize  asiapacificp latinamericap  middleeastp europecentralasiap africap treat i.combuyercountry 

****************************************
*aggreation level at subregion
clear 
import delimited "buyercompany.csv", encoding(ISO-8859-1)
encode sector, generate(comsector) label(companysector)
encode industry, generate(comindustry) label(companyindustry)
encode buyerstat, generate(combuyerstat) label(companybuyerstat)
encode location, generate(hlocation) label(location)
encode locationregion, generate(hlocationregion) label(locationregion)
encode buyercountry, generate(combuyercountry) label(buyercountry)
encode subregion, generate(hlocationsubregion) label(locationsubregion)

gen cer_log = log(cer)

reg cer projectnumber i.combuyerstat i.comsector  psize eastasiap southernasiap centralamericap southeastasiap northamericap southernafricap southamericap arabianpeninsulap eastafricap northafricap europep centralasiap iranianplateaup souteastasiap fertilecresentp treat i.combuyercountry  
est sto m1
reg cer_log projectnumber i.combuyerstat i.comsector  psize eastasiap southernasiap centralamericap southeastasiap northamericap southernafricap southamericap arabianpeninsulap eastafricap northafricap europep centralasiap iranianplateaup souteastasiap fertilecresentp treat i.combuyercountry  
est sto m2 
esttab m1 m2, starlevel(* 0.10 ** 0.05 *** 0.01)  label nonumber title("Paper 1 Sectoral Agg subRegion ") mtitle("Model 1" "Model 2"), using paper1sectoralaggsubregion.csv, replace se

****************************************
*aggreation level at country
clear 
import delimited "buyercompany.csv", encoding(ISO-8859-1)
encode sector, generate(comsector) label(companysector)
encode industry, generate(comindustry) label(companyindustry)
encode buyerstat, generate(combuyerstat) label(companybuyerstat)
encode location, generate(hlocation) label(location)
encode locationregion, generate(hlocationregion) label(locationregion)
encode buyercountry, generate(combuyercountry) label(buyercountry)
encode subregion, generate(hlocationsubregion) label(locationsubregion)

gen cer_log = log(cer)

reg cer projectnumber i.combuyerstat i.comsector psize  chinap indiap guatemalap philippinesp mexicop southafricap perup unitedarabemiratesp thailandp indonesiap malaysiap vietnamp uruguayp kenyap chilep cambodiap laopdrp nicaraguap myanmarp hondurasp southkoreap egyptp tunisiap madagascarp argentinap colombiap pakistanp macedoniap azerbaijanp iranp nepalp brazilp srilankap northkoreap bosniaandherzegovinap bangladeshp moldovap lebanonp rwandap papuanewguineap treat i.combuyercountry 

reg cer_log projectnumber i.combuyerstat i.comsector psize  chinap indiap guatemalap philippinesp mexicop southafricap perup unitedarabemiratesp thailandp indonesiap malaysiap vietnamp uruguayp kenyap chilep cambodiap laopdrp nicaraguap myanmarp hondurasp southkoreap egyptp tunisiap madagascarp argentinap colombiap pakistanp macedoniap azerbaijanp iranp nepalp brazilp srilankap northkoreap bosniaandherzegovinap bangladeshp moldovap lebanonp rwandap papuanewguineap treat i.combuyercountry 

*******
*Figure Coefficient Bar
tab combuyercountry, gen(CBC)
matrix beta=J(21,3,0)
gen cer_log = log(cer)
quietly reg cer_log projectnumber i.combuyerstat i.comsector  psize asiapacificp latinamericap africap middleeastp europecentralasiap treat CBC2-CBC21

foreach y of numlist 2/21{
quietly lincom CBC`y'
matrix beta[`y',1]=`y'
matrix beta[`y',2]=r(estimate)
matrix beta[`y',3]=r(se)
}

svmat beta
keep beta*
keep if beta1!=.
rename beta1 Country
rename beta2 beta
rename beta3 se
gen lo=beta-1.96*(se)
gen hi=beta+1.96*(se)

replace beta=beta*100
replace lo=lo*100
replace hi=hi*100
sort beta
gen n=_n
twoway rcap lo hi n, xlabel(1 "Luxembourg" 2 "Portugal" 3 "Italy" 4 "Netherlands" 5 "Czech Republic" 6 "Austria" 7 "France" 8"Germany" 9 "Japan"  10 "United K." 11 "Finland" 12 "Switzerland"  13 "Belgium" 14 "Sweden" 15 "Ireland" 16 "Denmark"  17 "Spain"   18 "United States"  19 "Norway" 20 "New Zealand"  21 "Australia", angle(vertical) labsize(small)) lcolor(dkorange) lwidth(thick) ytitle("Percentage Points", size(small)) ylabel(-160(40)80,nogrid labsize(small)) plotregion(style(none)) graphregion(fcolor(white)) legend(off) || scatter beta n, ms(Oh) msize(large) mcolor(black) xtitle(" ") yline(0)



**********************
*robustness check 2
********************
clear 
import delimited "cobenefit.csv", encoding(ISO-8859-1)
encode hostcountry, generate(hlocation) label(location)
encode firstcountry, generate(hbuyercountry) label(buyercountry)
encode type, generate(hprojecttype) label(projecttype)
encode firstcompany, generate(hbuyercompany) label(buyercompany)
encode cobnefits, generate(cobenefit) label(cobenefit)

drop if cobnefits=="."
drop if year==2008 

gen cer_log = log(cer)
reg cer i.cobenefit i.year i.hlocation i.hbuyercountry stperiodktco2eyr yrs treat expectedaccumulated2020ktco2e expectedaccumulated2030ktco2e investmentmus 
est sto m1
reg cer i.cobenefit i.year i.hprojecttype i.hlocation i.hbuyercountry stperiodktco2eyr yrs treat expectedaccumulated2020ktco2e expectedaccumulated2030ktco2e investmentmus 
est sto m2
reg cer i.cobenefit i.year i.hprojecttype psize i.hlocation i.hbuyercountry stperiodktco2eyr treat expectedaccumulated2020ktco2e expectedaccumulated2030ktco2e investmentmus 
est sto m3

reg cer_log i.cobenefit i.year i.hprojecttype psize i.hlocation i.hbuyercountry stperiodktco2eyr yrs treat expectedaccumulated2020ktco2e expectedaccumulated2030ktco2e investmentmus 
est sto m4
esttab m1 m2 m3 m4, starlevel(* 0.10 ** 0.05 *** 0.01)  label nonumber title("Paper 1 Regression Robustness ") mtitle("Model 1" "Model 2" "Model 3" "Model 4"), using paper1fullregressionrobustness.csv, replace se


*************************
*Statistical data
**************************
clear
import delimited "cobenefit.csv", encoding(ISO-8859-1)
encode hostcountry, generate(hlocation) label(location)
encode firstcountry, generate(hbuyercountry) label(buyercountry)
encode type, generate(hprojecttype) label(projecttype)
encode firstcompany, generate(hbuyercompany) label(buyercompany)
encode cobnefits, generate(cobenefit) label(cobenefit)

drop if cobnefits=="."

*labelling variables 
label variable yrs   "Years of projects" 
label variable stperiodktco2eyr   "1st period ktCO2e/yr" 
label variable expectedaccumulated2020ktco2e  "Expected accumulated 2020 ktCO2e"
label variable investmentmus "Investment"

reg cer_log i.cobenefit i.year i.hlocation i.hbuyercountry stperiodktco2eyr yrs treat expectedaccumulated2020ktco2e expectedaccumulated2030ktco2e investmentmus 

sum cer year stperiodktco2eyr  yrs expectedaccumulated2020ktco2e expectedaccumulated2030ktco2e investmentmus



******************
*supplemental robustness check: The variation of co-benefits can be originated from project features, such as type, size, etc. 
****************
clear
import delimited "cobenefit.csv", encoding(ISO-8859-1)
encode hostcountry, generate(hlocation) label(location)
encode firstcountry, generate(hbuyercountry) label(buyercountry)
encode type, generate(hprojecttype) label(projecttype)
encode firstcompany, generate(hbuyercompany) label(buyercompany)
encode cobnefits, generate(cobenefit) label(cobenefit)


gen typesize= psize*hprojecttype

reg cer i.typesize i.year i.hlocation i.hbuyercountry stperiodktco2eyr yrs treat expectedaccumulated2020ktco2e expectedaccumulated2030ktco2e investmentmus 

reg cer i.typesize i.hprojecttype psize i.year i.hlocation i.hbuyercountry stperiodktco2eyr yrs treat expectedaccumulated2020ktco2e expectedaccumulated2030ktco2e investmentmus 

reg cer ib0.typesize i.hprojecttype  i.year i.hlocation i.hbuyercountry stperiodktco2eyr yrs treat expectedaccumulated2020ktco2e expectedaccumulated2030ktco2e investmentmus 
est sto m1

reg cer ib1.typesize i.hprojecttype  i.year i.hlocation i.hbuyercountry stperiodktco2eyr yrs treat expectedaccumulated2020ktco2e expectedaccumulated2030ktco2e investmentmus 
est sto m2



gen ppsize=0
replace ppsize=1 if psize==0
gen typepsize= ppsize*hprojecttype
reg cer ib1.typepsize i.hprojecttype psize i.year i.hlocation i.hbuyercountry stperiodktco2eyr yrs treat expectedaccumulated2020ktco2e expectedaccumulated2030ktco2e investmentmus 
est sto m3
esttab m1 m2 m3, starlevel(* 0.10 ** 0.05 *** 0.01)  label nonumber title("Paper 1 Interaction term") mtitle("Model 1" "Model 2" "Model 3"), using paperoneinteractionterm.csv, replace se

esttab m1 m2, starlevel(* 0.10 ** 0.05 *** 0.01)  label nonumber title("Paper 1 Interaction term") mtitle("Model 1" "Model 2"), using paperoneinteractionterm.csv, replace se


*******
*Figure Coefficient Bar (Large projects)
****************
clear
import delimited "cobenefit.csv", encoding(ISO-8859-1)
encode hostcountry, generate(hlocation) label(location)
encode firstcountry, generate(hbuyercountry) label(buyercountry)
encode type, generate(hprojecttype) label(projecttype)
encode firstcompany, generate(hbuyercompany) label(buyercompany)
encode cobnefits, generate(cobenefit) label(cobenefit)
gen typesize= psize*hprojecttype
* by creating the interactive term, the coeffients of the project types are the difference between for example: large wind-large biomass, if we set biomass as the base
tab hprojecttype, gen(CBC)
matrix beta=J(9,3,0)
quietly reg cer ib1.typesize  psize i.year i.hlocation i.hbuyercountry stperiodktco2eyr yrs treat expectedaccumulated2020ktco2e expectedaccumulated2030ktco2e investmentmus CBC2-CBC9

foreach y of numlist 2/9{
quietly lincom CBC`y'
matrix beta[`y',1]=`y'
matrix beta[`y',2]=r(estimate)
matrix beta[`y',3]=r(se)
}

svmat beta
keep beta*
keep if beta1!=.
rename beta1 Country
rename beta2 beta
rename beta3 se
gen lo=beta-1.96*(se)
gen hi=beta+1.96*(se)


sort beta
gen n=_n
twoway rcap lo hi n, xlabel(1 "Methane avoidance" 2 "Landfill gas" 3 "Hydro" 4 "EE own generation" 5 "Coal bed/mine methane" 6 "Biomass" 7 "EE Household" 8"Solar" 9 "Wind", angle(vertical) labsize(small)) lcolor(dkorange) lwidth(thick) ytitle("Point Estimates", size(small)) ylabel(-6(2)4,nogrid labsize(small)) plotregion(style(none)) graphregion(fcolor(white)) legend(off) || scatter beta n, ms(Oh) msize(large) mcolor(black) xtitle(" ") yline(0)

*******
*Figure Coefficient Bar (small projects) + difference between large and small biomass projects (2.25) 
****************
clear
import delimited "cobenefit.csv", encoding(ISO-8859-1)
encode hostcountry, generate(hlocation) label(location)
encode firstcountry, generate(hbuyercountry) label(buyercountry)
encode type, generate(hprojecttype) label(projecttype)
encode firstcompany, generate(hbuyercompany) label(buyercompany)
encode cobnefits, generate(cobenefit) label(cobenefit)

gen ppsize=0
replace ppsize=1 if psize==0
gen typepsize= ppsize*hprojecttype
* by creating the interactive term, the coeffients of the project types are the difference between for example: small wind-large biomass, if we set biomass as the base


*******
*how we get 2.25
*set the base of typepsize as 0 instead of 1. the coefficents are the differerece between project size. for example: large biomass-small biomass
reg cer ib0.typepsize i.hprojecttype psize i.year i.hlocation i.hbuyercountry stperiodktco2eyr yrs treat expectedaccumulated2020ktco2e expectedaccumulated2030ktco2e investmentmus 

 
tab hprojecttype, gen(CBC)
matrix beta=J(9,3,0)
quietly reg cer ib1.typepsize psize i.year i.hlocation i.hbuyercountry stperiodktco2eyr yrs treat expectedaccumulated2020ktco2e expectedaccumulated2030ktco2e investmentmus CBC2-CBC9

foreach y of numlist 2/9{
quietly lincom CBC`y'
matrix beta[`y',1]=`y'
matrix beta[`y',2]=r(estimate)
matrix beta[`y',3]=r(se)
}

svmat beta
keep beta*
keep if beta1!=.
rename beta1 Country
rename beta2 beta
rename beta3 se
gen lo=beta-1.96*(se)
gen hi=beta+1.96*(se)

replace beta=beta+2.25
replace lo=lo+2.25
replace hi=hi+2.25
sort beta
gen n=_n


twoway rcap lo hi n, xlabel(1 "Methane avoidance" 2 "Landfill gas" 3 "EE household" 4 "EE own generation" 5 "Hydro" 6 "Solar" 7 "Wind" 8"Coal bed/mine methane" 9 "Biomass", angle(vertical) labsize(small)) lcolor(dkorange) lwidth(thick) ytitle("Poins Estimates", size(small)) ylabel(-6(2)4,nogrid labsize(small)) plotregion(style(none)) graphregion(fcolor(white)) legend(off) || scatter beta n, ms(Oh) msize(large) mcolor(black) xtitle(" ") yline(2.25)


*******
*Figure Coefficient Bar (small projects)without 2.25
****************
clear
import delimited "cobenefit.csv", encoding(ISO-8859-1)
encode hostcountry, generate(hlocation) label(location)
encode firstcountry, generate(hbuyercountry) label(buyercountry)
encode type, generate(hprojecttype) label(projecttype)
encode firstcompany, generate(hbuyercompany) label(buyercompany)
encode cobnefits, generate(cobenefit) label(cobenefit)

gen ppsize=0
replace ppsize=1 if psize==0
gen typepsize= ppsize*hprojecttype
* by creating the interactive term, the coeffients of the project types are the difference between for example: small wind-large biomass, if we set biomass as the base

 
tab hprojecttype, gen(CBC)
matrix beta=J(9,3,0)
quietly reg cer ib1.typepsize psize i.year i.hlocation i.hbuyercountry stperiodktco2eyr yrs treat expectedaccumulated2020ktco2e expectedaccumulated2030ktco2e investmentmus CBC2-CBC9

foreach y of numlist 2/9{
quietly lincom CBC`y'
matrix beta[`y',1]=`y'
matrix beta[`y',2]=r(estimate)
matrix beta[`y',3]=r(se)
}

svmat beta
keep beta*
keep if beta1!=.
rename beta1 Country
rename beta2 beta
rename beta3 se
gen lo=beta-1.96*(se)
gen hi=beta+1.96*(se)

replace beta=beta
replace lo=lo
replace hi=hi
sort beta
gen n=_n


twoway rcap lo hi n, xlabel(1 "Methane avoidance" 2 "Landfill gas" 3 "EE household" 4 "EE own generation" 5 "Hydro" 6 "Solar" 7 "Wind" 8"Coal bed/mine methane" 9 "Biomass", angle(vertical) labsize(small)) lcolor(dkorange) lwidth(thick) ytitle("Point Estimates", size(small)) ylabel(-6(2)4,nogrid labsize(small)) plotregion(style(none)) graphregion(fcolor(white)) legend(off) || scatter beta n, ms(Oh) msize(large) mcolor(black) xtitle(" ") yline(0)

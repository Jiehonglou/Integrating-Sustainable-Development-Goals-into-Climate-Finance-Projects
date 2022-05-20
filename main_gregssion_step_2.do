* Paper 2 V2.23.2020 



/* control location or not. Because location are highly correlated with the treatment. some countries have a lot of certification, while other countries 
have 0 GS. while year, project type, and buyercountry have no such an issue. Because every year will have at least 1 GS, probably every project type and every buyer country will have a GS project. 
But the project location, same small country has o GS project. 
*/

* Matching 
* Step one, run regression to see the whole resultls by importing data 
import excel "7800 projects main (sector).xls", sheet("7800 projects main (sector)") firstrow

foreach var of varlist * {
label variable `var' "`=`var'[1]'"
destring `var', replace
}

encode hostcountry, generate(location) label(location)
encode region, generate(locationregion) label(locationregion)
encode firstcountry, generate(buyercountry) label(buyercountry)
encode type, generate(projecttype) label(projecttype)
encode firstcompany, generate(buyercompany) label(buyercompany)
encode subregion, generate(locationsubregion) label(locationsubregion)
encode buyer, generate(buyerdetination) label(buyerdetination)

*labelling variables 
label variable treat "TREAT"
label variable yrs   "Years of projects" 
label variable stperiodktco2eyr   "1st period ktCO2e/yr" 
label variable expectedaccumulated2020ktco2e  "Expected accumulated 2020 ktCO2e"
label variable expectedaccumulated2030ktco2e  "Expected accumulated 2030 ktCO2e"
label variable investmentmus "Investment"

*treatment interaction term 
gen tcer=treat*cer
reg cer treat tcer stperiodktco2eyr yrs expectedaccumulated2020ktco2e expectedaccumulated2030ktco2e investmentmus i.location i.projecttype i.year i.buyercountry, cluster(buyercompany)

*step one: regular regression 
reg cer treat stperiodktco2eyr yrs expectedaccumulated2020ktco2e expectedaccumulated2030ktco2e investmentmus i.location i.projecttype i.year i.buyercountry, cluster(buyercompany)
est sto m1
esttab m1, starlevel(* 0.10 ** 0.05 *** 0.01)  label nonumber title("Full Regression ") mtitle("Model 1"), using fullregression.csv, replace se
clear 

** log 07/20/2020 and F joint test
gen logcer=log(cer)
reg logcer treat stperiodktco2eyr yrs expectedaccumulated2020ktco2e expectedaccumulated2030ktco2e investmentmus i.location i.projecttype i.year i.buyercountry
test  treat stperiodktco2eyr yrs expectedaccumulated2020ktco2e expectedaccumulated2030ktco2e investmentmus 
reg cer treat stperiodktco2eyr yrs expectedaccumulated2020ktco2e expectedaccumulated2030ktco2e investmentmus i.location i.projecttype i.year i.buyercountry
test  treat stperiodktco2eyr yrs expectedaccumulated2020ktco2e expectedaccumulated2030ktco2e investmentmus 


*******************************
* Model 2 General Propensity score
*******************************
* Propensity score at  both the catergocial and continuous level

import excel "fullsetmatchingstep1.xlsx", sheet("Sheet1") firstrow
encode hostcountry, generate(location) label(location)
encode region, generate(locationregion) label(locationregion)
encode firstcountry, generate(buyercountry) label(buyercountry)
encode type, generate(projecttype) label(projecttype)
encode firstcompany, generate(buyercompany) label(buyercompany)
encode subregion, generate(locationsubregion) label(locationsubregion)

label variable treat "TREAT"
label variable yrs   "Years of projects" 
label variable stperiodktco2eyr   "1st period ktCO2e/yr" 
label variable expectedaccumulated2020ktco2e  "Expected accumulated 2020 ktCO2e"
label variable expectedaccumulated2030ktco2e  "Expected accumulated 2030 ktCO2e"
label variable investmentmus "Investment"

destring year, replace

reg cer treat stperiodktco2eyr yrs expectedaccumulated2020ktco2e expectedaccumulated2030ktco2e investmentmus i.projecttype i.year i.buyercountry, cluster(buyercompany)


*model 3 Propensity score at the continuous level, which is only including four variables, then run regression 
clear
import excel "fullsetmatchingstep2.xlsx", sheet("Sheet1") firstrow
encode hostcountry, generate(location) label(location)
encode region, generate(locationregion) label(locationregion)
encode firstcountry, generate(buyercountry) label(buyercountry)
encode type, generate(projecttype) label(projecttype)
encode firstcompany, generate(buyercompany) label(buyercompany)
encode subregion, generate(locationsubregion) label(locationsubregion)

label variable treat "TREAT"
label variable yrs   "Years of projects" 
label variable stperiodktco2eyr   "1st period ktCO2e/yr" 
label variable expectedaccumulated2020ktco2e  "Expected accumulated 2020 ktCO2e"
label variable expectedaccumulated2030ktco2e  "Expected accumulated 2030 ktCO2e"
label variable investmentmus "Investment"

reg cer treat stperiodktco2eyr yrs expectedaccumulated2020ktco2e expectedaccumulated2030ktco2e  investmentmus i.projecttype i.year i.buyercountry, cluster(buyercompany)


clear 
* model 4 Matching at the buyers' level 
import excel "countryexact224.xlsx", sheet("Sheet1") firstrow
encode hostcountry, generate(location) label(location)
encode region, generate(locationregion) label(locationregion)
encode firstcountry, generate(buyercountry) label(buyercountry)
encode type, generate(projecttype) label(projecttype)
encode firstcompany, generate(buyercompany) label(buyercompany)
encode subregion, generate(locationsubregion) label(locationsubregion)

label variable treat "TREAT"
label variable yrs   "Years of projects" 
label variable stperiodktco2eyr   "1st period ktCO2e/yr" 
label variable expectedaccumulated2020ktco2e  "Expected accumulated 2020 ktCO2e"
label variable expectedaccumulated2030ktco2e  "Expected accumulated 2030 ktCO2e"
label variable investmentmus "Investment"

*treatment interaction term 
gen tcer=treat*cer

reg cer treat stperiodktco2eyr yrs expectedaccumulated2020ktco2e expectedaccumulated2030ktco2e  investmentmus i.projecttype i.year i.buyercountry, cluster(buyercompany)

clear
* model 5 Matching at the both buyer and location level 
import excel "countrytocountryexactv223.xlsx", sheet("Sheet1") firstrow
encode hostcountry, generate(location) label(location)
encode region, generate(locationregion) label(locationregion)
encode firstcountry, generate(buyercountry) label(buyercountry)
encode type, generate(projecttype) label(projecttype)
encode firstcompany, generate(buyercompany) label(buyercompany)
encode subregion, generate(locationsubregion) label(locationsubregion)

label variable treat "TREAT"
label variable yrs   "Years of projects" 
label variable stperiodktco2eyr   "1st period ktCO2e/yr" 
label variable expectedaccumulated2020ktco2e  "Expected accumulated 2020 ktCO2e"
label variable expectedaccumulated2030ktco2e  "Expected accumulated 2030 ktCO2e"
label variable investmentmus "Investment"


*treatment interaction term 
gen tcer=treat*cer
reg cer treat stperiodktco2eyr yrs expectedaccumulated2020ktco2e expectedaccumulated2030ktco2e  investmentmus i.projecttype i.year i.buyercountry i.location, cluster(buyercompany)



*******************************
*END
*******************************




**instead of running re.do or typing these commands manually, this do-file closes
**the log and resets the frames automatically before running the file again.

qui clear
qui capture log close
qui frame reset 

log using "StLouisSynths", text replace

****Criminal Ram-page: The Impact of National Team Movements on Local Crime****
			***Method by Sythetic Control***
		**Collin Zoeller, Porter Harding, Kent Allen**
		  **Brigham Young University-- Winter 2022**

*Data required for this do-file:  
* year.csv: a collection of crime data obtained from FBI UCR program for years 2006-2018
*CleanedPRedictors.dta: demographic information for each statistical metropolitan area
	*for 2006-2018
*stlouis.grec is graph edit macro that formats the graph automatically

**Installing Necessary Packages
qui ssc install synth, replace all //installing the synth package and mat2txt
qui ssc install mat2txt, replace all
qui ssc install outreg2, replace all
qui net install synth_runner, from(https://raw.github.com/bquistorff/synth_runner/master/) replace all

frame rename default Crime

*save all CSVs as a .dta *
local STATA : dir . files "*.csv"
foreach file of local STATA {
	clear
	import delim using "`file'", varn(4) bindquote(strict)
	save "`file'.dta", replace
}

*Clean the .dta files so that numbers are formatted correctly
local STATA : dir . files "*.csv.dta"
foreach file of local STATA {
	qui clear
	use "`file'"
	qui encode aggravatedassault, gen(assault)
	qui drop aggravatedassault
	qui encode burglary, gen(bgy)
	qui drop burglary
	qui encode larcenytheft, gen(theft)
	qui drop larcenytheft
	qui encode motorvehicletheft, gen(vtheft)
	qui drop motorvehicletheft
	qui encode murderandnonnegligentmanslaughte, gen(kill)
	qui drop murderandnonnegligentmanslaughte
	qui encode population, gen(pop)
	qui drop population
	qui encode propertycrime, gen(propcrime)
	qui drop propertycrime
	qui encode robbery, gen(rob)
	qui drop robbery
	qui encode violentcrime, gen(violent)
	qui drop violentcrime
	qui rename metropolitanstatisticalarea area
	qui rename countiesprincipalcities spec_area
	capture drop v13 v14 v15
	capture rename rape1 forciblerape
	capture encode forciblerape, gen(rape)
	capture drop forciblerape

	*keep only crime rateper 100,000 and population
	keep if spec_area == "Rate per 100,000 inhabitants"| spec_area == ""
	
	*remove all of the spacing/consolidate data*
	qui gen temp = area[_n-1]
	replace area = temp
	qui drop temp
	qui gen temp1 = pop[_n-1]
	replace pop = temp1
	qui drop temp1
	drop if spec_area == ""
	
	notes assault: rate per 100k inhabitants
	notes bgy: rate per 100k inhabitants
	notes kill: rate per 100k inhabitants
	notes pop: rate per 100k inhabitants
	notes propcrime: rate per 100k inhabitants
	notes rape: rate per 100k inhabitants
	notes rob: rate per 100k inhabitants
	notes theft: rate per 100k inhabitants
	notes violent: rate per 100k inhabitants
	notes vtheft: rate per 100k inhabitants
	drop spec_area
	
	*generate year variable*
	qui gen year = subinstr("`file'", ".csv.dta","",.)
	
	
	*make area variable a mergible value*
	gen area_s = area //converts to str57 instead of strL
	la var area_s "Metropolitan Statistical Area"
	drop area
	rename area_s area
	drop if area == ""
	
	save "`file'", replace
}

*Check that the above code works*
use 2006.csv.dta

*begin merge

append using 2007.csv.dta
append using 2008.csv.dta
append using 2009.csv.dta
append using 2010.csv.dta
append using 2011.csv.dta
append using 2012.csv.dta
append using 2013.csv.dta
append using 2014.csv.dta
append using 2015.csv.dta
append using 2016.csv.dta
append using 2017.csv.dta
append using 2018.csv.dta

*converting year from string to int
destring year, replace

frame create precleaned 
frame copy Crime precleaned, replace 
					//houses all of the appended data before cleaning it below
					//in case we need to verify no flagrant mistakes or 
					//data finagling ocurred. Can be checked under
					//Data>>Frames Manager

*make names uniform, if the are not, same locations are assigned different IDs
sort area //check that each area has unique identifier
qui gen area1 = subinstr(area, "M.S.A.","",.)
qui replace area = area1 
qui drop area1
qui gen area1 = subinstr(area, "1","",.)
qui replace area = area1 
qui drop area1
qui gen area1 = subinstr(area, "2","",.)
qui replace area = area1 
qui drop area1
qui gen area1 = subinstr(area, "3","",.)
qui replace area = area1 
qui drop area1
qui gen area1 = subinstr(area, "4","",.)
qui replace area = area1 
qui drop area1
qui gen area1 = subinstr(area, "5","",.)
qui replace area = area1 
qui drop area1
qui gen area1 = subinstr(area, "6","",.)
qui replace area = area1 
qui drop area1
qui gen area1 = subinstr(area, "7","",.)
qui replace area = area1 
qui drop area1
qui gen area1 = subinstr(area, " ,","",.)
qui replace area = area1 
qui drop area1
qui gen area1 = subinstr(area, " , ","",.) //do it again for a few double-comma obs
qui replace area = area1 
qui drop area1
qui gen area1 = subinstr(area, " M.S.A","",.)
qui replace area = area1 
qui drop area1
qui gen area1 = subinstr(area, "M.D.","",.)
qui replace area = area1 
qui drop area1
qui gen area1 = subinstr(area, " A","A",.) //remove the extra space
qui replace area = area1 
qui drop area1
qui gen area1 = subinstr(area, " B","B",.)
qui replace area = area1 
qui drop area1
qui gen area1 = subinstr(area, " C","C",.)
qui replace area = area1 
qui drop area1
qui gen area1 = subinstr(area, " D","D",.)
qui replace area = area1 
qui drop area1
qui gen area1 = subinstr(area, " E","E",.)
qui replace area = area1 
qui drop area1
qui gen area1 = subinstr(area, " F","F",.)
qui replace area = area1 
qui drop area1
qui gen area1 = subinstr(area, " H","H",.)
qui replace area = area1 
qui drop area1
qui gen area1 = subinstr(area, " I","I",.)
qui replace area = area1 
qui drop area1
qui gen area1 = subinstr(area, " J","J",.)
qui replace area = area1 
qui drop area1
qui gen area1 = subinstr(area, " K","K",.)
qui replace area = area1 
qui drop area1
qui gen area1 = subinstr(area, " L","L",.)
qui replace area = area1 
qui drop area1
qui gen area1 = subinstr(area, " M","M",.)
qui replace area = area1 
qui drop area1
qui gen area1 = subinstr(area, " N","N",.)
qui replace area = area1 
qui drop area1
qui gen area1 = subinstr(area, " O","O",.)
qui replace area = area1 
qui drop area1
qui gen area1 = subinstr(area, " P","P",.)
qui replace area = area1 
qui drop area1
qui gen area1 = subinstr(area, " Q","Q",.)
qui replace area = area1 
qui drop area1
qui gen area1 = subinstr(area, " R","R",.)
qui replace area = area1 
qui drop area1
qui gen area1 = subinstr(area, " S","S",.)
qui replace area = area1 
qui drop area1
qui gen area1 = subinstr(area, " T","T",.)
qui replace area = area1 
qui drop area1
qui gen area1 = subinstr(area, " U","U",.)
qui replace area = area1 
qui drop area1
qui gen area1 = subinstr(area, " V","V",.)
qui replace area = area1 
qui drop area1
qui gen area1 = subinstr(area, " W","W",.)
qui replace area = area1 
qui drop area1
qui gen area1 = subinstr(area, " X","X",.)
qui replace area = area1 
qui drop area1
qui gen area1 = subinstr(area, " Y","Y",.)
qui replace area = area1 
qui drop area1
qui gen area1 = subinstr(area, " Z","Z",.)
qui replace area = area1 
qui drop area1

*Change wierd anomolies in formatting, most are missing a space
replace area = "Allentown-Bethlehem-Easton, PA-NJ " in 102
replace area = "Nashville, TN " in 3030/3042
replace area = "HiltonHeadIsland-Bluffton-Beaufort,SC " in 1907
replace area = "Ithaca,NY " in 2030
replace area = "Mobile,AL " in 2871
replace area = "Morgantown,WV " in 2945
replace area = "OceanCity,NJ " in 3173/3185
replace area = "OklahomaCity,OK " in 3222
replace area = "PineBluff,AR " in 3407/3411
replace area = "Wilmington,NC " in 4782
replace area = "BattleCreek,MI " in 361/364
replace area = "Beckley,WV " in 398/401
replace area = "Bloomsburg-Berwick,PA "  in 515/517
replace area = "Chicago-Naperville-ArlingtonHeights,IL " in 847
replace area = "Chicago-Naperville-Evanston,IL " in 855
replace area = "Dallas-Plano-Irving,TX " in 1082
replace area = "Dothan,AL " in 1230
replace area = "Duluth,MN-WI " in 1263
replace area = "ElCentro,CA " in 1320
replace area = "Farmington,NM " in 1454
replace area = "Gary,IN " in 1660
replace area = "Hattiesburg,MS " in 1899
replace area = "LakeCounty-KenoshaCounty,IL-WI " in 2328
replace area = "NewYork-JerseyCity-WhitePlains,NY-NJ " in 3086
replace area = "Seattle-Bellevue-Everett,WA " in 4044
replace area = "Seattle-Bellevue-Kent,WA " in 4045
replace area = "Bellingham,WA " in 404/407
replace area = "Philadelphia,PA " in 3381
replace area = "Sacramento--Arden-Arcade--Roseville,CA " in 3749/3751
replace area = "Sacramento--Arden-Arcade--Roseville,CA " in 3753/3761

qui gen area1 = subinstr(area, ", ",",",.)
qui replace area = area1 
qui drop area1

qui gen area1 = subinstr(area, " ","",.)
qui replace area = area1 
qui drop area1

egen id = group(area) //generate id for each observation

save "rate_full", replace 

**Combine Predictors**

frame create Predictors
frame change Predictors
use CleanedPredictors.dta
gen area = strupper(areastr)
sort area year
qui gen area1 = subinstr(area, ", ",",",.)
qui replace area = area1 
qui drop area1
qui gen area1 = subinstr(area, " ","",.)
qui replace area = area1 
qui drop area1

qui drop areaid
qui drop areastr

save covar.dta, replace

frame change Crime
qui gen area1 = strupper(area) //Makes names uniform se we can merge on area
qui replace area = area1
qui drop area1

merge m:1 area year using covar.dta, keep(match)
egen tot_crime = rowtotal(assault bgy theft vtheft kill pop propcrime rob violent rape)
sort area year _merge
order area _merge year id tot_crime
la var tot_crime "total crime rate for all crimes"
la var inctot "(mean) total income"


******I THINK THE DATA IS CLEAN NOW******

**Enter Darth Synthious and the Synth-dicate**


duplicates report id year //because a few obs are repeated, tsset won't work
qui duplicates tag id year, gen(duplicate)
qui drop if duplicate==1
duplicates report id year
qui drop duplicate

**Apparently some area names are too long so we can't use area in unitnames()**
/*compress area*/
gen id_name = id
tostring id_name, replace



**droping years we don't have for st. louis**
drop if year == 2006
drop if year == 2007
drop if year == 2008
drop if year == 2009
drop if year == 2010
drop if year == 2011

**dropping observations that are missing years**
duplicates tag id, g(flag) 
drop if flag<6

#delimit;
tsset id year;
synth tot_crime 
	  tot_crime(2012) tot_crime(2013) tot_crime(2014) tot_crime(2015) 
	  pop(2012(1)2015) violent(2012(1)2015) rob(2012(1)2015) 
	  propcrime(2012(1)2015) age(2012(1)2015) asian(2012(1)2015) 
	  amerin(2012(1)2015) assault(2012(1)2015) bgy(2012(1)2015)
	  black(2012(1)2015) college(2012(1)2015) gradhigh(2012(1)2015)
	  inctot(2012(1)2015) kill(2012(1)2015) male1525(2012(1)2015) pover(2012(1)2015)
	  propcrime(2012(1)2015) theft(2012(1)2015) unem(2012(1)2015) vtheft(2012(1)2015)
	  white(2012(1)2015),	
	  trunit(506) trperiod(2016) unitnames(id_name)
	  mspreperiod(2012(1)2015) resultsperiod(2012(1)2018)
	  keep(synth.dta) replace fig;
		gr save "fit", replace;
		mat list e(V_matrix);
		mat list e(X_balance);
#delimit cr

#delimit
putexcel set "weights.xlsx", sheet("predictors") modify;

putexcel A1 = "Predictor Balance"
		 A2 = "Variable"
		 B2 = "Treated" 
		 C2 = "Synthetic" 
		 A3 = mat(e(X_balance)), rownames;
#delimit cr
		 
gr use "fit.gph" 
gr play stlouis.grec
gr save "fit", replace
gr export "stlouis_synths-total.png", replace


**Creaing a frame for the Synth data**
frame create synth
frame change synth
use synth.dta
rename _Co_Number id
rename _time year
rename _W_Weight weight
merge 1:m id using rate_full, keepusing(area)
order id area weight

drop if missing(weight)
keep in 1/143 //because it merges each area for that year several times
order id area weight year
drop _merge
drop if weight == 0 & year == . 
save, replace

	
export excel area weight using "weights.xlsx" in 1/30, sheet("balance") sheetreplace firstrow(variables)

sort year
export excel year _Y_treated _Y_synthetic using "weights.xlsx", sheet("prediction") sheetreplace firstrow(variables)
		
*For placebos
cwf Crime
#delimit ;	
tsset id year ;
synth_runner tot_crime 
	tot_crime(2012) tot_crime(2013) tot_crime(2014) tot_crime(2015) 
	pop(2012(1)2015) violent(2012(1)2015) rob(2012(1)2015) 
	propcrime(2012(1)2015) age(2012(1)2015) asian(2012(1)2015) 
	amerin(2012(1)2015) assault(2012(1)2015) bgy(2012(1)2015)
	black(2012(1)2015) college(2012(1)2015) gradhigh(2012(1)2015)
	inctot(2012(1)2015) kill(2012(1)2015) male1525(2012(1)2015) pover(2012(1)2015)
	propcrime(2012(1)2015) theft(2012(1)2015) unem(2012(1)2015) vtheft(2012(1)2015)
	white(2012(1)2015),
	trunit(506) trperiod(2016) unitnames(id_name) mspreperiod(2012(1)2016) 
	keep(synth_runner.dta) gen_vars replace;

	mat list e(pvals);
	mat list e(pvals_std);
	
single_treatment_graphs, trlinediff(-1) effects_ylabels(-4000(2000)4000) ;

putexcel set "synth";
putexcel C1 = "Table 6: P-Values by Year"
		 A3 = mat(e(pvals)), names;
#delimit cr

graph export raw.png, name(raw) replace
graph export effects.png, name(effects) replace

*Output synth_runner data
frame create runner
frame change runner
use synth_runner.dta
merge 1:m id year using rate_full, keepusing(area)
drop if pre_rmspe == . 

order id area year
drop _merge
save, replace

export excel using "placebos.xlsx", firstrow(variables) sheet("placebos") sheetreplace


*A diff in diff
cwf Crime
drop _merge
gen treat = 0, after(id)
replace treat = 1 if (id == 506) & (year >= 2016)

xi: reg tot_crime i.year i.area treat, vce(cl area)
outreg2 using DifinDif.doc, replace ctitle(Without Controls) keep(treat)
xi: reg tot_crime i.year i.area treat pop male age white black amerin asian otherrace male1525 unem pover inctot college gradhigh , vce(cl area)


outreg2 using DifinDif.doc, append ctitle(Controls) keep(treat pop male age male1525 white black amerin asian otherrace unem pover inctot college gradhigh)

save, replace

*determine statistical significance*
gen prepost = pre_rmspe/post_rmspe
egen rank = group(prepost)
order area prepost rank id year
sort rank
duplicates drop rank, force
gen stat = rank/144
order area prepost rank stat id year

list rank area sig stat in f/30, noobs
list rank area sig stat if id==506

save "significance", replace

frame create sig
frame change sig
use significance

keep in 1/30

export excel rank area stat using "placebos.xlsx", sheet("pval") firstrow(variables) sheetreplace

keep if id == 506
export excel rank area stat using "placebos.xlsx", sheet("St.Louis") firstrow(variables) sheetreplace

log close


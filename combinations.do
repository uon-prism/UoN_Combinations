* CREATED BY RMJ AT THE UNIVERSITY OF NOTTINGHAM 2023-04-05
*************************************
* Name:	combinations
* Creator:	RMJ
* Date:	20230405
* Desc:	program to pick out all existing combinations of 2-6 meds
* Notes: requires frameappend
* Version History:
*	Date	Reference	Update
* 20230405	combinations.do	File created
* 20230405	combinations.do	frlink version of reshape
*************************************

/* BASIC LOGIC FOR INCREASING NUM OF DRUGS IN COMBO
local testlist drug1 drug2 drug3 drug4 drug5 drug6 drug7 drug8 drug9 drug10
local numinlist = `:word count `testlist''
di "`numinlist'"

forval X1=1/`numinlist' {
	
	local d1 `: word `X1' of `testlist''
	forval X2=2/`numinlist' {
		
		if `X2'<=`X1' continue	// skip loop for items 1 and 2 in list (i.e. no replacement)
		local d2 `: word `X2' of `testlist''	
		
		forval X3=3/`numinlist' {
		
			if `X3'<=`X2' continue
			local d3 `: word `X3' of `testlist''		
			
			forval X4=4/`numinlist' {
			
				if `X4'<=`X3' continue
				local d4 `: word `X4' of `testlist''			
			
				forval X5=5/`numinlist' {
				
					if `X5'<=`X4' continue
					local d5 `: word `X5' of `testlist''			
								
					forval X6=6/`numinlist' {
				
						if `X6'<=`X5' continue
						local d6 `: word `X6' of `testlist''			
				
						di "`d1' `d2' `d3' `d4' `d5' `d6'"
					} //6
				} //5 
			} //4
		} //3
	} //2
}
*/


capture program drop drugcombos
program define drugcombos

version 17.0
syntax , LIST1(varlist)  LIST2(varlist) NUMINCOMBO(integer)

if (`numincombo'<2) |( `numincombo'>6) {
	di as error "numincombo must be between 2 and 6"
	exit
}

** Simplify the dataset
tempvar i
gen `i' = _n
order `i'

tempname TEMP
frame put *, into(`TEMP')
frame `TEMP': drop `list1' `list2'

keep `i' `list1' `list2'


** Get variable lists and numbers of variables in lists to use in loops
unab list1: `list1'
local numinlist1 = `:word count `list1''

unab list2: `list2'
local numinlist2 = `:word count `list2''




** All possible combos of [n=numincombo] drugs 
** Find all possible combos of n drugs in list2, where at least one is in list1.
** Create a variable for that combination and set to 1 if person has that combo.
** Drop the new variable if there are no records of that combo.

** TWO DRUGS
if `numincombo'==2 {
	
	forval X1=1/`numinlist1' {
		
		local d1 `: word `X1' of `list1''
		forval X2=2/`numinlist2' {
			
			if `X2'<=`X1' continue
			local d2 `: word `X2' of `list2''	
			

			di "`d1' `d2'"
			
			gen C`d1'`d2'=.
			replace C`d1'`d2'=1 if (`d1'+`d2')==2
			egen SUM=sum(C`d1'`d2')
			if SUM==0	drop C`d1'`d2'
			drop SUM

		} //2
	}

}


** THREE DRUGS
if `numincombo'==3 {
	
	forval X1=1/`numinlist1' {
		
		local d1 `: word `X1' of `list1''
		forval X2=2/`numinlist2' {
			
			if `X2'<=`X1' continue
			local d2 `: word `X2' of `list2''	
			
			forval X3=3/`numinlist2' {
			
				if `X3'<=`X2' continue
				local d3 `: word `X3' of `list2''		
				

				di "`d1' `d2' `d3'"
				
				gen C`d1'`d2'`d3'=.
				replace C`d1'`d2'`d3'=1 if (`d1'+`d2'+`d3')==3
				egen SUM=sum(C`d1'`d2'`d3')
				if SUM==0	drop C`d1'`d2'`d3'
				drop SUM
			} //3
		} //2
	}

}

** FOUR DRUGS
if `numincombo'==4 {
	
	forval X1=1/`numinlist1' {
		
		local d1 `: word `X1' of `list1''
		forval X2=2/`numinlist2' {
			
			if `X2'<=`X1' continue
			local d2 `: word `X2' of `list2''	
			
			forval X3=3/`numinlist2' {
			
				if `X3'<=`X2' continue
				local d3 `: word `X3' of `list2''		
				
				forval X4=4/`numinlist2' {

					if `X4'<=`X3' continue
					local d4 `: word `X4' of `list2''					
					
					di "`d1' `d2' `d3' `d4'"
					
					gen C`d1'`d2'`d3'`d4'=.
					replace C`d1'`d2'`d3'`d4'=1 if (`d1'+`d2'+`d3'+`d4')==4
					egen SUM=sum(C`d1'`d2'`d3'`d4')
					if SUM==0	drop C`d1'`d2'`d3'`d4'
					drop SUM
					
				} //4
			} //3
		} //2
	}

}


** FIVE DRUGS
if `numincombo'==5 {
	
	forval X1=1/`numinlist1' {
		
		local d1 `: word `X1' of `list1''
		forval X2=2/`numinlist2' {
			
			if `X2'<=`X1' continue
			local d2 `: word `X2' of `list2''	
			
			forval X3=3/`numinlist2' {
			
				if `X3'<=`X2' continue
				local d3 `: word `X3' of `list2''		
				
				forval X4=4/`numinlist2' {

					if `X4'<=`X3' continue
					local d4 `: word `X4' of `list2''					

					forval X5=5/`numinlist2' {

						if `X5'<=`X4' continue
						local d5 `: word `X5' of `list2''	
						
						di "`d1' `d2' `d3' `d4' `d5'"
						
						gen C`d1'`d2'`d3'`d4'`d5'=.
						replace C`d1'`d2'`d3'`d4'`d5'=1 if (`d1'+`d2'+`d3'+`d4' + `d5')==5
						egen SUM=sum(C`d1'`d2'`d3'`d4'`d5')
						if SUM==0	drop C`d1'`d2'`d3'`d4'`d5'
						drop SUM
						
					} //5
				} //4
			} //3
		} //2
	}

}


** SIX DRUGS
if `numincombo'==6 {
	
	forval X1=1/`numinlist1' {
		
		local d1 `: word `X1' of `list1''
		forval X2=2/`numinlist2' {
			
			if `X2'<=`X1' continue
			local d2 `: word `X2' of `list2''	
			
			forval X3=3/`numinlist2' {
			
				if `X3'<=`X2' continue
				local d3 `: word `X3' of `list2''		
				
				forval X4=4/`numinlist2' {

					if `X4'<=`X3' continue
					local d4 `: word `X4' of `list2''					

					forval X5=5/`numinlist2' {

						if `X5'<=`X4' continue
						local d5 `: word `X5' of `list2''	
						
						forval X6=6/`numinlist2' {

							if `X6'<=`X5' continue
							local d6 `: word `X6' of `list2''						
						
							di "`d1' `d2' `d3' `d4' `d5' `d6'"
							
							gen C`d1'`d2'`d3'`d4'`d5'`d6'=.
							replace C`d1'`d2'`d3'`d4'`d5'`d6'=1 if (`d1'+`d2'+`d3'+`d4' + `d5' + `d6')==6
							egen SUM=sum(C`d1'`d2'`d3'`d4'`d5'`d6')
							if SUM==0	drop C`d1'`d2'`d3'`d4'`d5'`d6'
							drop SUM
							
						} // 6
					} //5
				} //4
			} //3
		} //2
	}

}


** Reshape LONG and link back the extra info
keep `i' C*

*reshape long C, i(`i') j(pattern) string
*drop if C==.
*drop C


*** Copy each var in turn into new frame, use frameappend to create long dataset
tempname TEMP1 TEMP2
frame create `TEMP2'

foreach VAR of varlist C* {
	capture frame drop `TEMP1'
	frame put `i' `VAR', into(`TEMP1')
	
	// make variable "pattern" containing varname stripped of C (analogous to j)
	// keep only records with data
	frame `TEMP1' {
		local name=substr("`VAR'",2,.)
		gen pattern="`name'"
		drop if `VAR'==.
		drop `VAR'
	}
	
	frame `TEMP2': frameappend `TEMP1'
}

*** Copy results (in frame TEMP2) to working frame
clear
frameappend `TEMP2'


** Link the remaining variables back from frame TEMP
frlink m:1 `i', frame(`TEMP')
frget *, from(`TEMP')


end

# UoN_Combinations
Stata do-file that identifies all possible combinations of 2-6 variables from a list of indicator variables (e.g. combinations of prescribed drugs from a longer list).

The files in this repository were designed and written by researchers at the University of Nottingham. They were created for projects funded by the National Institute for Health and Care Research Nottingham Biomedical Research Centre. Any views expressed are those of the author(s) and not necessarily those of the NIHR or the Department of Health and Social Care.


## Overview and user guide
The file combinations.do defines a program that identifies all possible combinations of two to six variables out of a given list of indicator variables. These are initially stored as variable names, with flags indicating when the combination is present, before the dataset is reshaped to a long dataset. The resulting dataset therefore contains a list of all combinations of 2-6 variables present within each of the original records. The code was originally developed to identify combinations of medicines prescribed during a particular time point.

To use the code, first run "combinations.do" to define the program drugcombos. Then run drugcombos as described below.


## Requirements
* Stata v16+ (frames functionality required).
* Depending on the number of possible combinations, StataMP may be required (max variables may be large)
* A wide dataset (one line per record/period of interest) with a list of binary indicator variables coded 1 if present, 0 otherwise
* Variable names should be max (30/number in combination) characters - recommend max 5 characters.


## joinsplit
**Syntax**

`drugcombos, list1(varlist) list2(varlist) numincombo(integer)`

**Options**
|option                   |description|
|-------------------------|-----------|
|**list1**(_varlist_)     |variable list - one of these _must_ be present in the resulting combination|
|**list2**(_varlist_)     |variable list - all variables to search for combinations within (can==list1)|
|**numincombo**(_integer_)|integer (2 to 6) showing the size of the combination of interest|

**Description**
**drugcombos** was written to identify all possible combinations of two to six medicines prescribed to a patient during a particular exposure period out of all medicines present in the dataset. It should run on any list of indicator variables as long as they are coded 1 if present 0 if not. The names of the variables of interest should be short (5 charas recommended) so it may be necessary to create a code/lookup for variable names. The code loops over all possible combinations of [2-6] variables out of the given variable list, which can end up being a very large list and so take a long time to run. Think about this before running. It may be necessary to increase the maximum number of variables to avoid crashes (set maxvar ...). The resulting dataset contains all instances of [2-6] variables present in the original dataset. Variables may be counted more than once: the logic is sampling without relacement, if a person/record has variable1 variable2 and variable 3, the result will be (variable1+variable2) (variable1+variable3) (variable2+variable3) for that record.

### options
**list1** - at least one of the variables in this list must be in the final combination. This allows the user to look for a subset of combinations rather than every possible combination. For example, to look for all combinations of an antidepressant plus one other drug, the user could supply the list of antidepressants to list1.

**list2** - the list of variables to look for combinations within. This can be the same as list1. Due to the logic of the code, the loops start from the _second_ item in this list. This means the first item in list2 gets ignored, and so should either be the same as the first item in list1 _or_ another variable that is not of interest.

**numincombo** - an integer ranging from 2 to 6, showing the size of the combination the user wants to extract.

### examples
dataset:
|recno|ad1|ad2|drug1|drug2|
|-----|---|---|-----|-----|
|1    |1  |0  |1    |0    |
|2    |0  |1  |1    |1    |

**eg1**

`drugcombos, list1(ad*) list2(ad* drug*) numincombo(2)`

result:
|recno|pattern |
|-----|--------|
|1    |ad1drug1|
|2    |ad2drug1|
|2    |ad2drug2|

**eg2**

`drugcombos, list1(ad*) list2(ad* drug*) numincombo(3)`

result:
|recno|pattern |
|-----|--------|
|2    |ad2drug1drug2|


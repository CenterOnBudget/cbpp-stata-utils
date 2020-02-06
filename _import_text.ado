*! version 1.1.2 12jun2019 Vincent Palacios
*! Description: Imports plain text files into memory for processing
*! Note: preserves empty lines, but not indentation

* version 1.1.2 12jun2019 Vincent Palacios
* version 1.1.1 08feb2019 Vincent Palacios
* version 1.1 29jan2019 Vincent Palacios
* version 1.0 15aug2018 Vincent Palacios

* Description: clear memory; write simple dictionary; save as tempfile; use dict to read text

* Updates:
*   v1.1.2: option lines takes in statment range, i.e. 1/10 or 5/L (see help in)
*           added support for strL, and formatted input as left-justified
*   v1.1.1: using %#S to preserve leading and trainling spaces
*   v1.1: changed name from importtext to import_text


program define _import_text
  version 13.0

  syntax using, [strlength(integer 500) lines(string)] clear
  * Can't use [in] bc that limits obs range to range of current data  

  * setup
  local strformat = `strlength'
  if `strlength' > 2045 local strlength = "L"
  `clear'
  if "`lines'" != "" local lines = "in " + "`lines'"
  
  * create dictionary
  quietly {
    set obs 4
    gen str150 output = ""
    replace output = `"  infile dictionary  `using' {"' in 1
    replace output =  "  _line(1)"                           in 2
    replace output =  "  str`strlength' input %`strformat'S" in 3 
      // if lines are longer than 2045 char, needs to be strL
    replace output =  "}"                                    in 4
    
    * temporarily store dictionary
    tempfile mydict
    outfile using `mydict', noquote replace
    
    * read in data using temp dictionary
    `clear'
    infile using `mydict' `lines'
    format input %-100s
  }

end 

* import_text using https://www2.census.gov/programs-surveys/acs/tech_docs/pums/data_dict/PUMSDataDict16.txt, clear
* stata infile dictionary preserve white space: https://www.stata.com/statalist/archive/2007-05/msg00643.html
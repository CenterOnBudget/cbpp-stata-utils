{smcl}

{title:Title}

{p 4 4 2}
{bf:inspect_2} {hline 2} Summary statistics for positive, zero, negative, and missing values. 



{title:Description}

{p 4 4 2}
A cross between {help summarize} and {help inspect}, {bf:inspect_2} gives the frequency of positive, zero, negative, and missing values in a variable, as well as the mean, minimum, and maximum value of a variable within those categories and overall.

{p 4 4 2}
Results may be stored in a matrix (or matrices, if {it:varlist} is multiple variables) by specifying matrix name(s) in the {it:matrix()} option.



{title:Syntax}

{p 8 8 2} {bf:inspect_2} {it:{help varlist}} [{it:{help if}}] [{it:{help weight}}], [{bf:matrix(names)}]

{p 4 4 2}
{bf:fweight}s, {bf:iweight}s, and {bf:pweight}s are allowed; see {help weight}.



{title:Example(s)}
  
{p 4 4 2}
		{bf:. inspect_2 pincp pearnp if agep >= 18 [fw=pwgtp]}
		 
{p 4 4 2}
		{bf:. inspect_2 thnetworth, save}



{title:Website}

{p 4 4 2}
{browse "https://github.com/CenterOnBudget/cbppstatautils":github.com/CenterOnBudget/cbppstatautils}


{space 4}{hline}
{it:This help file was dynamically produced by {browse "http://www.haghish.com/markdoc/":MarkDoc Literate Programming package}.}


